import os
import shutil
from pathlib import Path
import subprocess
from my.utils import section

HOME_DIR = Path("~/").expanduser()

def init():
    section("Updating system")
    rc = subprocess.call(["sudo", "apt", "update"])
    rc = subprocess.call(["sudo", "apt", "upgrade", "-y"])
    rc = subprocess.call(["sudo", "apt", "autoremove"])


    section("Updating doom")
    rc = subprocess.call([f"{HOME_DIR}/.config/emacs/bin/doom", "up"])
