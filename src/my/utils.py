from colorama import Back, Style


def section(msg):
    print(Back.GREEN + "=>" + msg)
    print(Style.RESET_ALL)


def message(msg):
    print(Back.YELLOW +"::" + msg)
    print(Style.RESET_ALL)


def info():
    print(msg)


def warning(msg):
    print(Back.RED + "WARNING::" + msg)
    print(Style.RESET_ALL)
