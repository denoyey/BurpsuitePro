#!/bin/bash
# Github: github.com/denoyey/BurpsuitePro.git


os_type=$(uname | tr '[:upper:]' '[:lower:]')

case "$os_type" in
  linux*|darwin*)
    echo -e "\nDetected Unix-like OS. Running Linux/macOS installer..."
    bash burp-files/os/linux/install.sh
    ;;
  mingw*|cygwin*|msys*)
    echo -e "\nDetected Windows OS. Running Windows installer..."
    if command -v pwsh &>/dev/null; then
      pwsh -NoProfile -ExecutionPolicy Bypass -File burp-files/os/windows/install.ps1
    elif command -v powershell &>/dev/null; then
      powershell -NoProfile -ExecutionPolicy Bypass -File burp-files/os/windows/install.ps1
    else
      echo "PowerShell not found. Cannot continue."
      exit 1
    fi
    ;;
  *)
    echo "Unsupported OS: $os_type"
    exit 1
    ;;
esac
