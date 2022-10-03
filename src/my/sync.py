from pathlib import Path
import re
import os
import datetime
import subprocess
from my.utils import section

def iter_projects(root_dir):
    root_dir = Path(root_dir)

    for f in root_dir.glob("**/.git"):
        yield f.parent

def sync_project(project_dir):

    section(f"Syncing project: {project_dir}")
    t = datetime.datetime.now()
    os.chdir(project_dir)
    if (project_dir / "sync").exists():
        rc = subprocess.call(["./sync"],
                             stderr=subprocess.DEVNULL,
                             stdout=subprocess.DEVNULL)
    cmd = ["git",
            "commit",
            "-am",
            f'"{t}"']
    rc = subprocess.call(cmd,
                         stderr=subprocess.DEVNULL,
                         stdout=subprocess.DEVNULL)
    # TODO git add -all
    # TODO check if dirty

def sync_all_projects(root_dir):

    regex = r"torefile|git|code|data|dev"

    section("Syncing all org files")
    cmd = ["emacsclient", "-e", "(org-save-all-org-buffers)"]
    rc = subprocess.call(cmd,
                         stderr=subprocess.DEVNULL,
                         stdout=subprocess.DEVNULL)

    # git add all org file
    for f in Path(root_dir).glob("**/*.org"):
        if not re.search(regex, str(f)):
            d = f.parent
            os.chdir(d)
            rc = subprocess.call(["git", "add", f"./{f.name}"])
            if rc != 0:
                print(f)


    # TODO dvc add all ext file ^^ if in a dvc repo

    # call sync and commit
    for p in iter_projects(root_dir):
        if not re.search(regex, str(p)):
            sync_project(p)

    print("Synchronisation done 🍺")
