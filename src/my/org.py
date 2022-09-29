from orgparse import load
import pandas as pd
import datetime
import re
from collections import deque
import tabulate
import os
import json

def get_timesheet_df(file_paths):
    records = []
    for f in file_paths:
        root = load(f)
        for node in root:
            if hasattr(node, "clock"):
                for d in node.clock:
                    if d.end is None:
                        d._end = datetime.datetime.now()
                    records.append({"start": d.start,
                                    "end": d.end,
                                    "tags": ":".join(node.tags),
                                    "duration": d.duration,
                                    "heading": node.heading,
                                    "todo": "" if node.todo is None else node.todo,
                                    "file": f})
    df = pd.DataFrame.from_records(records)
    return df

def filter_by_idd(node, idd):
    fifo = deque([node])
    while len(fifo) != 0:
        node = fifo.pop()
        if ("ID" in node.properties.keys()
            and node.properties["ID"] == idd):
            return node
        else:
            fifo += node.children
    return []


def filter_forecast(node):
    parent = node.parent
    if parent:
        if hasattr(parent, "todo"):
            parent = "" if parent.todo is None else parent.todo
        else:
            parent = ""
    else:
        parent = ""
    return "FORECAST" not in parent

def get_columnview_df(file_paths,
                      filter_f=lambda x: True,
                      idd=None):

    records = []
    for f in file_paths:
        root = load(f)
        if idd:
            root = filter_by_idd(root, idd)
        for node in root:
            parent = node.parent
            if parent:
                parent = parent.heading
            else:
                parent = ""
            dat = {k.upper(): v
                   for k, v in node.properties.items()}
            dat["PARENT"] = parent
            dat["LEVEL"] = node.level
            dat["ITEM"] = node.heading
            dat["TAGS"] = ":".join(node.tags)
            if hasattr(node, "todo"):
                dat["TODO"] = "" if node.todo is None else node.todo
            dat["CLOCKSUM"] = datetime.timedelta(0)
            if hasattr(node, "clock"):
                dat["CLOCKSUM"] = sum([c.duration for c in node.clock],
                                      datetime.timedelta())
            if filter_f(node):
                records.append(dat)

    df = pd.DataFrame.from_records(records)
    return df

def format_second_to_hour_minute(second):
    return f"{second // 60 // 60}:{(second // 60) % 60:02d}"

def read_config(conf_path):
    with open(conf_path, 'r') as f:
        config = json.load(f)
    return config


class Org():


    def __init__(self):

        self.config = read_config(conf_path=os.path.expanduser("~/plain/config.json"))
        self.agenda_files = self.config["agenda_files"]
        self.timmi_file = self.config["timmi_file"]
        self.nb_hour_worked = self.config["nb_hour_worked"]
        self.project_tags = self.config["project_tags"]

    def format_project_tags(self, tags):
        res = []
        for t in tags:
            match = False
            for p in self.project_tags:
                if p in t.lower():
                    res.append(p)
                    match = True
                    break
            if not match:
                res.append("other")
        return res

    def format_second_to_worked(self, second):
        h = second // 60 // 60
        d = h // self.nb_hour_worked
        h = h % self.nb_hour_worked
        m = second // 60 % 60
        s = f"{d}d {h}:{m:02d}" if d != 0 else f"{h}:{m:02d}"
        return s


    def get_velotaf_df(self, date):
        ## TODO
        df = (get_columnview_df(self.agenda_files)[["CREATED", "ITEM", "K", "S"]]
              .dropna())
        df = df.query("S == 'velotaf'")
        cond = [date in d for d in df.CREATED]
        return df[["ITEM", "K" ]][cond]

    def get_date_time_df(self, date, forecast=False):
        time_df = get_timesheet_df(self.agenda_files)
        cond = [date in d.strftime("%Y-%m-%d") for d in time_df.end]
        return time_df[cond]

    def get_date_timmi_df(self, date):
        timmi_df = get_columnview_df([self.timmi_file],
                                     filter_f=filter_forecast)

        timmi_df = timmi_df.query("LEVEL == 4")

        cond =  [date in d for d in timmi_df.PARENT]
        timmi_df = timmi_df[cond]

        timmi_df["tags"] = self.format_project_tags(timmi_df["TAGS"])
        timmi_df = timmi_df.dropna(subset=['TIME_SPENT'])
        timmi_df["TIME_SPENT"] = [float(d.replace("d", "")) for d in timmi_df["TIME_SPENT"]]
        return timmi_df

    def get_date_time_sumup(self, date):
        time_df = self.get_date_time_df(date)
        time_df["day_p"] = (time_df["duration"].dt.seconds /
                            (60 * 60 * self.nb_hour_worked))
        time_df["tags"] = self.format_project_tags(time_df["tags"])

        time_df = (time_df.groupby('tags')[["day_p", "duration"]]
                   .agg({"duration": "sum", "day_p": "sum"})
                   .reset_index())

        timmi_df = self.get_date_timmi_df(date)
        timmi_df = timmi_df.groupby("tags")[["tags", "TIME_SPENT"]].sum().reset_index()

        df = pd.merge(timmi_df,
                      time_df,
                      how="outer")

        total_df = pd.DataFrame.from_records([{"tags": "total",
                                               "TIME_SPENT": df["TIME_SPENT"].sum(),
                                               "duration": df["duration"].sum(),
                                               "day_p": df["day_p"].sum()
                                               }])
        df = pd.concat([df, total_df])
        return df


    def print_today_time_sumup(self):
        date = datetime.date.today().strftime("%Y-%m-%d")
        df = self.get_date_time_sumup(date)
        print(tabulate.tabulate(df,
                                showindex=False,
                                headers=df.columns,
                                tablefmt="orgtbl"))


    def print_month_time_sumup(self):
        date = datetime.date.today().strftime("%Y-%m")
        df = self.get_date_time_sumup(date)
        print(tabulate.tabulate(df,
                                showindex=False,
                                headers=df.columns,
                                tablefmt="orgtbl"))

    def get_today_time_df(self):
        date = datetime.date.today().strftime("%Y-%m-%d")
        return self.get_date_time_df(date)

    def get_week_time_df(self):
        time_df = get_timesheet_df(self.agenda_files)
        today = datetime.date.today()
        monday = (datetime.date.today()
                  + datetime.timedelta(days=-today.weekday()))
        cond = time_df.end.dt.floor("D") >= monday.strftime("%Y-%m-%d")
        return time_df[cond]

    def print_total_work_today(self):
        time_df = self.get_today_time_df()
        tot = time_df.duration.sum().seconds
        all_tags = "|".join(self.project_tags)
        cond = [bool(re.search(all_tags, tag)) for tag in time_df["tags"]]
        work_tot = time_df.duration[cond].sum().seconds
        perso_tot = tot - work_tot
        print(f"👷 {self.format_second_to_worked(work_tot)}"
              + f" 🤸 {self.format_second_to_worked(perso_tot)}"
              + f" 🔔 {self.format_second_to_worked(tot)}")

    def print_total_work_week(self):
        time_df = self.get_week_time_df()
        tot = time_df.duration.sum().seconds
        all_tags = "|".join(self.project_tags)
        cond = [bool(re.search(all_tags, tag)) for tag in time_df["tags"]]
        work_tot = time_df.duration[cond].sum().seconds
        perso_tot = tot - work_tot
        print(f"👷 {self.format_second_to_worked(work_tot)}"
              + f" 🤸 {self.format_second_to_worked(perso_tot)}"
              + f" 🔔 {self.format_second_to_worked(tot)}")
