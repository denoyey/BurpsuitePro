# Requires -RunAsAdministrator
# Github: github.com/denoyey/BurpsuitePro.git
# Script ini untuk menginstall Burp Suite Pro di Windows

function Download-FileWithProgress {
    param (
        [Parameter(Mandatory = $true)][string]$url,
        [Parameter(Mandatory = $true)][string]$output
    )
    Write-Host "[*] Downloading from $url"
    try {
        Invoke-WebRequest -Uri $url -OutFile $output -UseBasicParsing
    } catch {
        Write-Host "[!] Download failed: $_"
        throw
    }
}

function Test-BurpVersion($v) {
    try {
        $testUrl = "https://portswigger.net/burp/releases/download?product=pro&version=$v&type=Jar"
        Invoke-WebRequest -Uri $testUrl -Method Head -UseBasicParsing -ErrorAction Stop | Out-Null
        return $true
    } catch {
        return $false
    }
}

Clear-Host
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
for ($i = 0; $i -lt 2; $i++) { Write-Host "" }

$ascii_art = @'
/============================================================================\
||   |            |               |      _ )                                ||
||   |      _` |   _|   -_) (_-<   _|    _ \  |  |   _| _ \  _ \   _| _ \   ||
||  ____| \__,_| \__| \___| ___/ \__|   ___/ \_,_| _|  .__/ .__/ _| \___/   ||
||                                                    _|   _|               ||
\============================================================================/
                Github: github.com/denoyey/BurpsuitePro.git
'@ -split "`n"
foreach ($line in $ascii_art) {
    foreach ($char in $line.ToCharArray()) {
        Write-Host -NoNewline $char
    }
    Write-Host ""
}

# Memeriksa apakah PowerShell dijalankan sebagai Administrator
Write-Host "`n[*] Checking if PowerShell is running as Administrator..."
$IsAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
if (-not $IsAdmin) {
    Write-Host "`n[ERROR] Please run this script as Administrator." -ForegroundColor Red
    exit 1
}

# Mengsetting powershell progress display ke silent untuk meningkatkan kecepatan download
Write-Host "`n[*] Setting PowerShell progress display to silent to improve download speed..."
$ProgressPreference = 'Continue'

# Melakukan pengecekan Java JDK 21
Write-Host "`n[*] Checking for Java Development Kit (JDK) 21..."
$jdk21 = Get-CimInstance -ClassName Win32_Product | Where-Object { $_.Vendor -eq "Oracle Corporation" -and $_.Caption -like "Java(TM) SE Development Kit 21*" }
if (-not $jdk21) {
    Write-Host "`t[-] JDK 21 not found. Downloading..."
    Download-FileWithProgress -url "https://download.oracle.com/java/21/archive/jdk-21_windows-x64_bin.exe" -output "jdk-21.exe"
    Write-Host "`t[*] Installing JDK 21..."
    Start-Process -FilePath ".\jdk-21.exe" -Wait
    Remove-Item "jdk-21.exe" -Force
} else {
    Write-Host "`t[DONE] Java JDK 21 is already installed."
}

# Melakukan pengecekan JRE 8
Write-Host "`n[*] Checking for Java Runtime Environment (JRE) 8..."
$jre8 = Get-CimInstance -ClassName Win32_Product | Where-Object { $_.Vendor -eq "Oracle Corporation" -and $_.Caption -like "Java 8 Update *" }
if (-not $jre8) {
    Write-Host "`t[-] JRE 8 not found. Downloading..."
    Download-FileWithProgress -url "https://javadl.oracle.com/webapps/download/AutoDL?BundleId=247947_0ae14417abb444ebb02b9815e2103550" -output "jre-8.exe"
    Write-Host "`t[*] Installing JRE 8..."
    Start-Process -FilePath ".\jre-8.exe" -Wait
    Remove-Item "jre-8.exe" -Force
} else {
    Write-Host "`t[DONE] Java JRE 8 is already installed."
}

# Menginput versi Burp Suite Pro
Write-Host "`n[*] Checking latest STABLE version of Burp Suite Pro:"
Write-Host "    https://portswigger.net/burp/releases/professional/latest"
Write-Host "[ALERT] Use only STABLE versions (.jar)`n"

do {
    $inputVersion = Read-Host "    >> Enter Burp Suite Pro version (e.g. 2025.8.5)"
    $v = $inputVersion -replace '[-,\/]', '.'
    if (Test-BurpVersion $v) {
        Write-Host "`n    [DONE] Version '$v' is valid and available (.jar file found)."
        $installDir = "C:\BurpsuitePro-v$v"
        Write-Host "`n[*] Setting up installation directory: $installDir"
        if (Test-Path -Path $installDir) {
            Write-Host "`n[!] Directory already exists: $installDir"
            $choice = Read-Host "    >> Do you want to delete and recreate it? (y/n)"
            if ($choice -eq 'y') {
                try {
                    Remove-Item -Path $installDir -Recurse -Force
                    Write-Host "    [+] Folder deleted."
                    New-Item -ItemType Directory -Path $installDir | Out-Null
                    Write-Host "    [+] New folder created: $installDir"
                } catch {
                    Write-Host "[ERROR] Failed to delete or recreate folder. Exiting." -ForegroundColor Red
                    exit 1
                }
            } else {
                Write-Host "    [SKIPPED] Using existing folder: $installDir"
            }
        } else {
            Write-Host "`n[*] Creating installation directory..."
            New-Item -ItemType Directory -Path $installDir | Out-Null
        }
        Set-Location -Path $installDir
        break
    } else {
        Write-Host "`n    [ALERT] Version '$v' not found or .jar file missing. Please try again.`n"
    }
} while ($true)

# Mendownload Burp Suite Pro .jar file
$jarPath = Join-Path -Path $installDir -ChildPath "burpsuite_pro_v$v.jar"
$downloadUrl = "https://portswigger-cdn.net/burp/releases/download?product=pro&version=$v&type=Jar"
if (Test-Path $jarPath) {
    Write-Host "`n[*] burpsuite_pro_v$v.jar already exists. Skipping download."
} else {
    Write-Host "`n[*] Downloading Burp Suite Pro version $v..."
    try {
        Download-FileWithProgress -url $downloadUrl -output $jarPath
        Write-Host "`n[DONE] Download complete: $jarPath"
    } catch {
        Write-Host "`n[ALERT] Failed to download version '$v'. Check the version and your internet connection."
        Write-Host "    URL attempted: $downloadUrl"
        exit 1
    }
}

# Mengecek loader dan logo
if (!(Test-Path -Path "$installDir\loader.jar")) {
    Write-Host "`n[*] Downloading loader.jar..."
    Download-FileWithProgress -url "https://github.com/denoyey/BurpsuitePro/raw/refs/heads/main/burp-files/loader/loader.jar" -output "$installDir\loader.jar"
} else {
    Write-Host "[*] loader.jar already exists. Skipping download."
}
if (!(Test-Path -Path "$installDir\logo.png")) {
    Write-Host "`n[*] Downloading logo.png..."
    Download-FileWithProgress -url "https://github.com/denoyey/BurpsuitePro/blob/main/burp-files/img/logo.png?raw=true" -output "$installDir\logo.png"
} else {
    Write-Host "[*] logo.png already exists. Skipping download."
}
if (!(Test-Path -Path "$installDir\logo.ico")) {
    Write-Host "`n[*] Downloading logo.ico..."
    Download-FileWithProgress -url "https://github.com/denoyey/BurpsuitePro/blob/main/burp-files/img/logo.ico?raw=true" -output "$installDir\logo.ico"
} else {
    Write-Host "[*] logo.ico already exists. Skipping download."
}

# Membuat burp.bat agar bisa dijalankan oleh VBS/Shortcut
Write-Host "`n[*] Creating burp.bat launcher..."
$batContent = @"
@echo off
cd /d "%~dp0"
echo [*] Starting loader in background...
start "Loader" java -jar loader.jar
timeout /t 5 >nul
echo [*] Launching Burp Suite Pro...
"C:\Program Files\Java\jdk-21\bin\java.exe" ^
  --add-opens=java.desktop/javax.swing=ALL-UNNAMED ^
  --add-opens=java.base/java.lang=ALL-UNNAMED ^
  --add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED ^
  --add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED ^
  --add-opens=java.base/jdk.internal.org.objectweb.asm.Opcodes=ALL-UNNAMED ^
  -javaagent:""$installDir\loader.jar"" ^
  -noverify -jar ""$installDir\burpsuite_pro_v$v.jar""
if %ERRORLEVEL% NEQ 0 (
    echo [!] Error occurred during launch. Press any key to exit.
    pause >nul
)
"@
$batPath = Join-Path $installDir "burp.bat"
$batContent | Out-File -FilePath $batPath -Encoding ASCII
Write-Host "[DONE] burp.bat created."

# Membuat VBS launcher untuk Burp Suite Pro (agar run hidden)
Write-Host "`n[*] Creating Burp-Suite-Pro.vbs (for shortcut only)..."
$vbsContentShortcut = @"
Set WshShell = CreateObject("WScript.Shell")
WshShell.Run """C:\Program Files\Java\jdk-21\bin\java.exe"" --add-opens=java.desktop/javax.swing=ALL-UNNAMED --add-opens=java.base/java.lang=ALL-UNNAMED --add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED --add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED --add-opens=java.base/jdk.internal.org.objectweb.asm.Opcodes=ALL-UNNAMED -javaagent:""$installDir\loader.jar"" -noverify -jar ""$installDir\burpsuite_pro_v$v.jar""", 0
Set WshShell = Nothing
"@
$vbsPathShortcut = Join-Path $installDir "Burp-Suite-Pro.vbs"
$vbsContentShortcut | Out-File -FilePath $vbsPathShortcut -Encoding ASCII
Write-Host "[DONE] Burp-Suite-Pro.vbs created."

# Menjalankan Burpro & Loader
Write-Host "`n[*] Launching BurpPro & Loader..."
Start-Process -FilePath "$batPath"

# Membuat shortcut ke Desktop
Write-Host "`n[*] Creating shortcut on Desktop..."
$desktopPath = [Environment]::GetFolderPath("Desktop")
$shortcutPath = Join-Path $desktopPath "Burp Suite Pro.lnk"
$targetPath = "$installDir\Burp-Suite-Pro.vbs"
$shell = New-Object -ComObject WScript.Shell
$desktopShortcut = $shell.CreateShortcut($shortcutPath)
$desktopShortcut.TargetPath = $targetPath
$desktopShortcut.WorkingDirectory = $installDir
$icoPath = "$installDir\logo.ico"
$desktopShortcut.IconLocation = "$icoPath,0"
$desktopShortcut.WindowStyle = 1
$desktopShortcut.Save()
$startMenuPath = [Environment]::GetFolderPath("StartMenu")
$shortcutPathSM = Join-Path $startMenuPath "Burp Suite Pro.lnk"
$startMenuShortcut = $shell.CreateShortcut($shortcutPathSM)
$startMenuShortcut.TargetPath = $targetPath
$startMenuShortcut.WorkingDirectory = $installDir
$icoPath = "$installDir\logo.ico"
$startMenuShortcut.IconLocation = "$icoPath,0"
$startMenuShortcut.WindowStyle = 1
$startMenuShortcut.Save()
Write-Host "[DONE] Shortcut created on Desktop: $shortcutPath"

# Membersihkan repo github hasil clone (jika applicable)
Write-Host "`n[*] Checking if script is inside a Git cloned repo from github.com/denoyey/BurpsuitePro.git..."
$scriptDir = $PSScriptRoot
if (-not $scriptDir) {
    $scriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
}
Write-Host "[DEBUG] Script directory detected: $scriptDir"
$current = Get-Item $scriptDir
$gitRoot = $null
while ($current -ne $null) {
    $gitPath = Join-Path $current.FullName ".git"
    if (Test-Path $gitPath) {
        $gitRoot = $current.FullName
        break
    }
    $current = $current.Parent
}
if ($gitRoot) {
    $configPath = Join-Path $gitRoot ".git\config"
    if (Test-Path $configPath) {
        $configContent = Get-Content $configPath -Raw
        if ($configContent -match "github.com[:\/]denoyey\/BurpsuitePro(\.git)?") {
            Write-Host "[*] This folder is a cloned repo from github.com/denoyey/BurpsuitePro.git"
            Write-Host "[*] Preparing to delete entire cloned folder: $gitRoot"
            $deleteScript = Join-Path $env:TEMP ("delete_repo_" + [System.Guid]::NewGuid().ToString() + ".ps1")
            $deleteCommand = @"
Start-Sleep -Seconds 5
Try {
    Remove-Item -Path '$gitRoot' -Recurse -Force -ErrorAction Stop
    Write-Output '[*] Repo folder deleted: $gitRoot'
} Catch {
    Write-Output '[!] Failed to delete: $_'
}
Remove-Item -Path '$deleteScript' -Force -ErrorAction SilentlyContinue
"@
            $deleteCommand | Set-Content -Path $deleteScript -Encoding UTF8
            $taskName = "Delete_BurpRepo_" + [System.Guid]::NewGuid().ToString("N")
            schtasks /Create /TN $taskName /TR "powershell.exe -ExecutionPolicy Bypass -File `"$deleteScript`"" /SC ONCE /ST 00:00 /RL HIGHEST /F | Out-Null
            schtasks /Run /TN $taskName | Out-Null
            schtasks /Delete /TN $taskName /F | Out-Null
            Write-Host "[DONE] Scheduled deletion of Git repo: $gitRoot"
        } else {
            Write-Host "[*] Git config found, but not from expected repo. Skipping cleanup."
        }
    } else {
        Write-Host "[*] No git config found. Skipping cleanup."
    }
} else {
    Write-Host "[*] This script is not running inside a Git repository. Skipping cleanup."
}

Read-Host "`nPress Enter to exit..."
