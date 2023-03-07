from my.helpers import read_config
import os
import pandas as pd
import sqlite3

def parse_alist(alist):
    d = {}
    for e in alist[2:-2].split(") ("):
        e = e.split(" . ")
        d[e[0][1:-1]] = e[1][1:-1]
    return d

class OrgRoam():

    def __init__(self):

        self.config = read_config(conf_path=os.path.expanduser("~/plain/config.json"))
        self.db_path = self.config["org_roam_db"]

    def get_nodes_table(self):
        db_conn = sqlite3.connect(self.db_path)
        ref_df = pd.read_sql('SELECT * FROM nodes', db_conn)
        aux_df = []
        for i, r in ref_df.iterrows():
            l = parse_alist(r["properties"])
            l["index"] = i
            aux_df.append(l)
        aux_df = pd.DataFrame.from_records(aux_df)
        ref_df = ref_df.reset_index().merge(aux_df)

    def show_tab(self):
        pass
