#!/bin/bash
# Github: github.com/denoyey/BurpsuitePro.git

os_type=$(uname | tr '[:upper:]' '[:lower:]')

case "$os_type" in
  linux*)
    echo -e "\nDetected Linux OS. Running Linux installer..."
    bash burp-files/os/linux/install.sh
    ;;
  mingw*|cygwin*|msys*)
    echo -e "\nDetected Windows OS. Running Windows installer..."
    pwsh -File burp-files/os/windows/install.ps1
    ;;
  *)
    echo "Unsupported OS: $os_type"
    exit 1
    ;;
esac
