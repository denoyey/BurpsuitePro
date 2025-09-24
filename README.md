<div align="center">

# BURPSUITE PROFESSIONAL v2025

<p align="center">
  <img src="https://raw.githubusercontent.com/denoyey/BurpsuitePro/main/burp-files/img/banner.gif" alt="Banner BurpsuitePro"/>
</p>

<p align="center">
<strong>Burp Suite Professional</strong> is a powerful tool used for security testing of web applications. It helps professionals analyze, intercept, and manipulate HTTP/S traffic between the browser and the target application. Packed with features such as Proxy, Scanner, Repeater, Intruder, and more, it enables users to detect and exploit common vulnerabilities like SQL injection, XSS, and CSRF. This version is fully unlocked and intended for ethical hacking and educational purposes.

<div align="center">

![Build](https://img.shields.io/badge/build-stable-28a745?style=for-the-badge&logo=github)
![Platform](https://img.shields.io/badge/platform-Linux-0078D6?style=for-the-badge&logo=linux&logoColor=white)
![Platform](https://img.shields.io/badge/platform-Windows-0078D6?style=for-the-badge&logo=windows&logoColor=white)
![Last Commit](https://img.shields.io/github/last-commit/denoyey/BurpsuitePro?style=for-the-badge&logo=git)
![Language](https://img.shields.io/github/languages/top/denoyey/BurpsuitePro?style=for-the-badge&color=informational)
![Technologies](https://img.shields.io/badge/technologies-Bash%20%7C%20PowerShell%20%7C%20Python-yellow?style=for-the-badge&logo=terminal)
![Stars](https://img.shields.io/github/stars/denoyey/BurpsuitePro?style=for-the-badge&color=ffac33&logo=github)
![Forks](https://img.shields.io/github/forks/denoyey/BurpsuitePro?style=for-the-badge&color=blueviolet&logo=github)
![Issues](https://img.shields.io/github/issues/denoyey/BurpsuitePro?style=for-the-badge&logo=github)
![Contributors](https://img.shields.io/github/contributors/denoyey/BurpsuitePro?style=for-the-badge&color=9c27b0)

<br />

<img src="https://api.visitorbadge.io/api/VisitorHit?user=denoyey&repo=BurpsuitePro&countColor=%237B1E7A&style=flat-square" alt="visitors"/>

</div>

</p>

</div>

## 📖 Table of Contents

- [🔍 Overview](#-overview)
- [🌐 Official Website](#-official-website)
- [🐍 Python Required](#-python-required)
- [💻 Linux Installation](#-linux-installation)
  - [🔧 Installation](#-installation)
  - [☕ Select Java Version](#-select-java-version)
  - [🔑 Setup License](#-setup-license)
  - [📌 Create Desktop Launcher (XFCE)](#-create-desktop-launcher-xfce)
- [🖥️ Windows Installation](#%EF%B8%8F-windows-installation)
  - [📁 Setup](#-setup)
  - [⚙️ PowerShell Setup](#%EF%B8%8F-powershell-setup)
  - [🎨 Change Icon](#-change-icon)
  - [📂 Add to Start Menu](#-add-to-start-menu)
- [🙌 Credits](#-credits)

## 🔍 Overview

**BurpSuitePro** (Latest) is an advanced web vulnerability scanner and proxy tool for efficient and precise security testing.
<p align="center">
  <img src="https://github.com/denoyey/BurpsuitePro/blob/main/burp-files/img/BurpsuitePro-v2025.png" alt="BurpSuitePro Interface"/>
</p>

## 🌐 Official Website

Visit the official **BurpSuitePro** site: [https://portswigger.net/burp/pro](https://portswigger.net/burp/pro)

<p align="center">
  <img src="https://github.com/denoyey/BurpsuitePro/blob/main/burp-files/img/Web-BurpsuitePro.png" alt="BurpSuite Website"/>
</p>

## 🐍 Python Required

Make sure Python 3 is installed:

- **Linux**: `python3 --version`  
- **Windows**: install from [python.org](https://www.python.org/downloads/) and check "Add to PATH"

<h2 align="left">💻 Linux Installation</h2>

### 🔧 Installation
> Clone and install directly
```terminal
git clone https://github.com/denoyey/BurpsuitePro.git
cd BurpsuitePro
chmod +x run.py
python run.py
```

###  ☕ Select Java Version
> If you have multiple versions of Java installed (e.g., Java 17 and Java 21), you can manually select the default version by running:
```terminal
sudo update-alternatives --config java
```
This command will display a list of installed Java versions. Enter the corresponding number to set your preferred version as the system default.

### 🔑 Setup License
Follow these steps to activate your license:
- Open **BurpSuitePro**
- Go to **Manual Activation**
- Copy the **Request Key** from BurpSuite
- Paste it into the loader
- Copy the **Response Key** from loader
- Paste it back into BurpSuite

### 📌 Create Desktop Launcher (XFCE)

You can easily launch BurpSuitePro from your desktop by creating a launcher:

1. **Right-click** on your desktop and choose **"Create Launcher"**
2. Set the following:
   - **Name**: `BurpSuite Professional`
   - **Command**: `directory/burpsuitepro`
3. Click the icon box and **select the BurpSuite icon** (usually located in your install folder)

> ✅ This allows you to launch BurpSuitePro just like a native application.

<br>

<div align="center">
  <img src="https://github.com/denoyey/BurpsuitePro/blob/main/burp-files/img/Launcher.png" alt="BurpSuite Desktop Launcher Example" width="600"/>
</div>

<h2 align="left">🖥️ Windows Installation</h2>

### 📁 Step 1: Setup Folder

1. Download the [repository as ZIP](https://github.com/denoyey/BurpsuitePro/archive/refs/heads/main.zip)
3. Extract **all contents** to any folder.Example:
   ```powershell
   C:\BurpsuitePro
   ```
   >⚠️ Do NOT rename the main folder.

### ⚙️ Step 2: Install via PowerShell

1. Open **PowerShell** as **Administrator**
   - Search powershell, then right-click → Run as administrator
2. Go to the folder where you extracted the files:
```powershell
cd path\to\BurpsuitePro
```
3. Run the installer:
```powershell
python run.py
```

### 🚀 What This Script Does
This script will automatically:
<br>
✅ Download and install **JDK 21** (if not installed) <br>
✅ Download and install **JRE 8** (if not installed) <br>
✅ Ask for a valid **Burp Suite Pro version** (e.g. 2025.8.5) <br>
✅ Download Burp `.jar` file from official PortSwigger <br>
✅ Download the custom **loader** <br>
✅ Create a clean **.bat** launcher <br>
✅ Create a **.vbs** launcher for silent execution <br>
✅ Create a **Desktop Shortcut** + **Start Menu Shortcut** <br>
✅ Set proper **icon** for easier identification <br>
✅ Automatically **delete the repo folder** `(C:\BurpsuitePro)` if installed from GitHub <br>

<hr>

### 🎨 Optional: Change Icon (If Needed)
If the shortcut icon doesn’t appear: <br>
1. Right-click Burp Suite Pro.lnk on your Desktop
2. Go to **Properties → Shortcut → Change Icon**
3. Choose the icon from:
```makefile
C:\BurpsuitePro-v<your-version>\logo.ico
```
Example:
```text
C:\BurpsuitePro-v2025.8.5\logo.ico
```

## 🧩 Credits

- Original loader by [h3110w0r1d-y](https://github.com/h3110w0r1d-y/BurpLoaderKeygen)  
- Tweaked & maintained by [denoyey](https://github.com/denoyey)
