#!/bin/python3
# Github: github.com/denoyey/BurpsuitePro.git
# run.py - Script to install Burp Suite Pro on various operating systems

import os
import platform
import subprocess
import sys
import shutil

RED = "\033[91m"
GREEN = "\033[92m"
YELLOW = "\033[93m"
BLUE = "\033[94m"
CYAN = "\033[96m"
RESET = "\033[0m"


def check_python_installed():
    python_exec = shutil.which("python") or shutil.which("python3")
    if not python_exec:
        print(f"{RED}[X]{RESET} Python is not installed or not found in PATH.")
        print(f"{YELLOW}[!] Please install Python 3.x and try again.{RESET}")
        sys.exit(1)
    else:
        version = subprocess.check_output([python_exec, "--version"]).decode().strip()
        print(f"{GREEN}[DONE]{RESET} Python detected: {version}")


try:
    check_python_installed()
    os_type = platform.system().lower()
    if "microsoft" in platform.release().lower():
        os_type = "wsl"
    print(f"\n{CYAN}Detected OS:{RESET} {YELLOW}{os_type}{RESET}")
    if "windows" in os_type:
        print(f"\n{BLUE}[*]{RESET} Running Windows installer...")
        if shutil.which("powershell") is None:
            print(
                f"{RED}[X] PowerShell not found in PATH. Please ensure PowerShell is installed and available.{RESET}"
            )
            sys.exit(1)
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
    print(f"{YELLOW}[!] Installation cancelled by user.{RESET}\n")
    sys.exit(130)
