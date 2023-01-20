import logging
from pathlib import Path
import os
import sys
import json

######################################
# global variables usefull for testing

_THIS_DIR = Path(os.path.dirname(os.path.abspath(__file__)))
PROJECT_DIR = _THIS_DIR.parent.parent
DATA_DIR = PROJECT_DIR / "data"

LOG = logging.getLogger(__name__)


def create_dir(path_dir):
    path_dir = Path(path_dir)
    if not path_dir.exists():
        os.makedirs(path_dir, exist_ok=True)
    return path_dir

def read_config(conf_path):
    with open(conf_path, 'r') as f:
        config = json.load(f)
    if "agenda_dir" in config.keys():
        config["agenda_files"] = list(Path(config["agenda_dir"]).glob("*.org"))
    return config
