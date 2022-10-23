import os
import shutil
from pathlib import Path
import subprocess
from my.utils import section, create_dir, message
from my.helpers import PROJECT_DIR, read_config

HOME_DIR = Path("~/").expanduser()


# TODO create installer class
# class installer:

#     def __init__(self):
#         pass

class Update():

    def __call__(self):
        section("Updating system")
        rc = subprocess.call(["sudo", "apt", "update"])
        rc = subprocess.call(["sudo", "apt", "upgrade", "-y"])
        rc = subprocess.call(["sudo", "apt", "autoremove"])


class Base():

    def __call__(self):
        section("Install base packages")
        rc = subprocess.call(["sudo", "apt", "update"])
        rc = subprocess.call(["sudo", "apt", "install", "zsh",
                              "git", "curl", "make", "stow"])

        if not (HOME_DIR / ".oh-my-zsh").exists():
            # TODO check hash
            rc = subprocess.call(["sh", "-c",
                                  "curl",
                                  "-fsSL",
                                  "https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh"])

class Emacs():

    def __call__(self):

        section("Install emacs")
        # install with apt
        # get emacs version
        p = subprocess.Popen(["emacs", "--version"], stdout=subprocess.PIPE)
        out, err = p.communicate()
        if "28.1" in str(out):
            message("emacs 28.1 installed")
        else:
            cmd = ["sudo", "add-apt-repository", "ppa:kelleyk/emacs"]
            assert subprocess.call(cmd) == 0
            cmd = ["sudo", "apt", "search", "emacs28"]
            p = subprocess.Popen(cmd, stdout=subprocess.PIPE)
            out, err = p.communicate()
            if "emacs28-nativecomp" in str(out):
                cmd = ["sudo", "apt", "install", "emacs28-nativecomp"]
                assert subprocess.call(cmd, stdout=subprocess.PIPE) == 0
            else:
                cmd = ["sudo", "apt", "install", "emacs28"]
                assert subprocess.call(cmd, stdout=subprocess.PIPE) == 0

# TODO
# implement module classes: update, base, emacs, doom
# autre module secret (with gopass etc)
# load all module from json in ~/plain/config.json
# run it in init file


MODULES = {"update": Update,
           "base": Base,
           "emacs": Emacs}

def init(m="all"):

    config = read_config(conf_path=os.path.expanduser("~/plain/config.json"))
    if m == "all":
        for m in config["modules"]:
            module = MODULES[m]()
            module()
    else:
        module = MODULES[m]()
        module()

    # section("Updating system")
    # rc = subprocess.call(["sudo", "apt", "update"])
    # rc = subprocess.call(["sudo", "apt", "upgrade", "-y"])
    # rc = subprocess.call(["sudo", "apt", "autoremove"])

    # # call all modules
    # for s in (PROJECT_DIR / "modules/").glob("*.py"):
    #     section("Updating {s}")

    # section("Updating doom")
    # rc = subprocess.call([f"{HOME_DIR}/.config/emacs/bin/doom", "up"])
