from my.helpers import DATA_DIR, PROJECT_DIR, create_dir
from orgparse import load
from my.org import *
import os

def test_get_timesheet_df():

    # given
    config = read_config(conf_path=os.path.expanduser("~/plain/config.json"))

    # with
    df = get_timesheet_df(config["agenda_files"])

def test_get_columnview_df():

    # given
    file_paths = [PROJECT_DIR / "tests/my/test.org"]

    # with
    time_df = get_timesheet_df(file_paths)

    # then
    cond = time_df.end.dt.floor('D') == "2022-04-26"
    tot = time_df.duration[cond].sum()

def test_filter_by_idd():
    root = load(PROJECT_DIR / "tests/my/test.org")
    idd = "057b1da5-5a7a-424f-9b37-8129aa8efa90"
    node = filter_by_idd(root, idd)
    assert node.properties['ID'] == idd

def test_orgparse():
    root = load(PROJECT_DIR / "tests/my/test.org")
    node = root.children[0]
    node.clock


def test_get_today_time_sumup(self):
    self = Org()
    Org().print_month_time_sumup()

    date = "2022-06"
    Org().get_date_time_sumup(date)
