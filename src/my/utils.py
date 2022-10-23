from colorama import Back, Style, Fore
from pathlib import Path
import os

def section(msg):
    print(Fore.GREEN + "=>" + msg + Style.RESET_ALL)


def message(msg):
    print(Fore.YELLOW +"::" + msg)
    print(Style.RESET_ALL)


def info(msg):
    print(msg)

def warning(msg):
    print(Back.RED + "WARNING::" + msg)
    print(Style.RESET_ALL)


def create_dir(path_dir):
    path_dir = Path(path_dir)
    if not path_dir.exists():
        os.makedirs(path_dir, exist_ok=True)
    return path_dir
