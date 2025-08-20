#!/bin/python3
# Github: github.com/denoyey/BurpsuitePro.git
# run.py - Script to install Burp Suite Pro on various operating systems

import os
import platform
import subprocess
import sys

RED = "\033[91m"
GREEN = "\033[92m"
YELLOW = "\033[93m"
BLUE = "\033[94m"
CYAN = "\033[96m"
RESET = "\033[0m"

try:
    os_type = platform.system().lower()
    if "microsoft" in platform.release().lower():
        os_type = "wsl"
    print(f"\n{CYAN}Detected OS:{RESET} {YELLOW}{os_type}{RESET}")
    if "windows" in os_type:
        print(f"\n{BLUE}[*]{RESET} Running Windows installer...")
        try:
            subprocess.run(
                [
                    "powershell",
                    "-NoProfile",
                    "-ExecutionPolicy",
                    "Bypass",
                    "-File",
                    "burp-files/os/windows/install.ps1",
                ],
                check=True,
            )
        except subprocess.CalledProcessError as e:
            print(f"\n{RED}[X]{RESET} PowerShell execution failed: {e}")
            sys.exit(1)
    elif os_type in ("linux", "wsl", "darwin"):
        print(f"\n{BLUE}[*]{RESET} Running Linux/macOS installer...")
        subprocess.run(["bash", "burp-files/os/linux/install.sh"])
    else:
        print(f"\n{RED}[X]{RESET} Unsupported OS")
except KeyboardInterrupt:
    os.system("clear" if os_type != "windows" else "cls")
    ascii_art = """
░█░░░█▀█░▀█▀░█▀▀░█▀▀░▀█▀░░░█▀▄░█░█░█▀▄░█▀█░█▀█░█▀▄░█▀█
░█░░░█▀█░░█░░█▀▀░▀▀█░░█░░░░█▀▄░█░█░█▀▄░█▀▀░█▀▀░█▀▄░█░█
░▀▀▀░▀░▀░░▀░░▀▀▀░▀▀▀░░▀░░░░▀▀░░▀▀▀░▀░▀░▀░░░▀░░░▀░▀░▀▀▀                                                                                                                 
    Github: github.com/denoyey/BurpsuitePro.git
    """
    print(ascii_art)
    print(f"{RED}[!] Installation cancelled by user.{RESET}")
    sys.exit(130)
