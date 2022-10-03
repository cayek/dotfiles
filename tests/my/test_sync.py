from my.helpers import DATA_DIR, PROJECT_DIR, create_dir
from my.sync import *
import os

def test_list_projects():

    # given
    root_dir = os.path.expanduser("~/plain/")

    # with
    for f in iter_projects(root_dir):
        print(f)
