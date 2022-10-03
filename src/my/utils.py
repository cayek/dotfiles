from colorama import Back, Style, Fore


def section(msg):
    print(Fore.GREEN + "=>" + msg + Style.RESET_ALL)


def message(msg):
    print(Fore.YELLOW +"::" + msg)
    print(Style.RESET_ALL)


def info():
    print(msg)

def warning(msg):
    print(Back.RED + "WARNING::" + msg)
    print(Style.RESET_ALL)
