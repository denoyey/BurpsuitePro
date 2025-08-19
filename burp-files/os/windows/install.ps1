#!/bin/bash
# Github: github.com/denoyey/BurpsuitePro.git
# Script to install BurpSuitePro on Windows with JDK 21 and JRE 8


Clear-Host
for ($i = 0; $i -lt 2; $i++) {
    Write-Host ""
}

$colors = @("Blue", "Cyan", "Green", "Magenta", "Red", "White", "Yellow")
$selectedColor = Get-Random -InputObject $colors
$ascii_art = @'
░█░░░█▀█░▀█▀░█▀▀░█▀▀░▀█▀░░░█▀▄░█░█░█▀▄░█▀█░█▀█░█▀▄░█▀█
░█░░░█▀█░░█░░█▀▀░▀▀█░░█░░░░█▀▄░█░█░█▀▄░█▀▀░█▀▀░█▀▄░█░█
░▀▀▀░▀░▀░░▀░░▀▀▀░▀▀▀░░▀░░░░▀▀░░▀▀▀░▀░▀░▀░░░▀░░░▀░▀░▀▀▀                                                                                                                  
    Github: github.com/denoyey/BurpsuitePro.git
'@ -split "`n"
foreach ($line in $ascii_art) {
    foreach ($char in $line.ToCharArray()) {
        Write-Host -NoNewline $char -ForegroundColor $selectedColor
    }
    Write-Host ""
}

# Mengsetting progress display ke silent untuk meningkatkan kecepatan download
Write-Host "`n[*] Setting PowerShell progress display to silent to improve download speed..."
$ProgressPreference = 'SilentlyContinue'

# Mengecek JDK 21
Write-Host "`n[*] Checking for Java Development Kit (JDK) 21..."
$jdk21 = Get-WmiObject -Class Win32_Product -Filter "Vendor='Oracle Corporation'" | Where-Object { $_.Caption -like "Java(TM) SE Development Kit 21*" }
if (-not $jdk21) {
    Write-Host "`t[-] JDK 21 not found. Downloading..."
    Invoke-WebRequest -Uri "https://download.oracle.com/java/21/archive/jdk-21_windows-x64_bin.exe" -OutFile "jdk-21.exe"
    Write-Host "`t[*] Installing JDK 21..."
    Start-Process -FilePath ".\jdk-21.exe" -Wait
    Write-Host "`t[*] Cleaning up installer..."
    Remove-Item "jdk-21.exe" -Force
} else {
    Write-Host "`t[✔] Java JDK 21 is already installed."
}

# Mengecek JRE 8
Write-Host "`n[*] Checking for Java Runtime Environment (JRE) 8..."
$jre8 = Get-WmiObject -Class Win32_Product -Filter "Vendor='Oracle Corporation'" | Where-Object { $_.Caption -like "Java 8 Update *" }
if (-not $jre8) {
    Write-Host "`t[-] JRE 8 not found. Downloading..."
    Invoke-WebRequest -Uri "https://javadl.oracle.com/webapps/download/AutoDL?BundleId=247947_0ae14417abb444ebb02b9815e2103550" -OutFile "jre-8.exe"
    Write-Host "`t[*] Installing JRE 8..."
    Start-Process -FilePath ".\jre-8.exe" -Wait
    Write-Host "`t[*] Cleaning up installer..."
    Remove-Item "jre-8.exe" -Force
} else {
    Write-Host "`t[✔] Java JRE 8 is already installed."
}

# Menginput versi Burp Suite Pro yang ingin diunduh
Write-Host "`n[*] Checking latest STABLE version of Burp Suite Pro at:"
Write-Host "    https://portswigger.net/burp/releases/professional/latest"
Write-Host "[!] Use only STABLE versions (.jar)`n"
function c($v) {
    try {
        Invoke-WebRequest -Uri "https://portswigger.net/burp/releases/download?product=pro&version=$v&type=Jar" -Method Head -UseBasicParsing -ErrorAction Stop
        $true
    } catch {
        $false
    }
}
while ($true) {
    $inputVersion = Read-Host "    >> Enter Burp Suite Pro version (e.g. 2025.7.3)"
    $v = $inputVersion -replace '[-,\/]', '.'
    if (c $v) {
        Write-Host "`n    [✔] Version '$v' is valid and available (.jar file found)."
        break
    } else {
        Write-Host "`n    [✘] Version '$v' not found or .jar file missing. Please try again.`n"
    }
}

# Mendownload Burp Suite Pro .jar file
Write-Host "`n[*] Downloading Burp Suite Pro version $v..."
$downloadFolder = Get-Location
$jarPath = Join-Path $downloadFolder "burpsuite_pro_v$v.jar"
$url = "https://portswigger-cdn.net/burp/releases/download?product=pro&type=Jar&version=$v"
try {
    Invoke-WebRequest -Uri $url -OutFile $jarPath -UseBasicParsing -ErrorAction Stop
    Write-Host "`n[✔] Download complete: $jarPath"
} catch {
    Write-Host "`n[✘] Failed to download version '$v'. Check the version and your internet connection."
    Write-Host "    URL attempted: $url`n"
}

# Membuat file burp.bat untuk menjalankan Burp Suite Pro
Write-Host "`n[*] Creating burp.bat file to run Burp Suite Pro"
if (Test-Path burp.bat) {
    Remove-Item burp.bat -Force
}
$batCmd = "java --add-opens=java.desktop/javax.swing=ALL-UNNAMED --add-opens=java.base/java.lang=ALL-UNNAMED --add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED --add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED --add-opens=java.base/jdk.internal.org.objectweb.asm.Opcodes=ALL-UNNAMED -javaagent:`"$pwd\loader.jar`" -noverify -jar `"$pwd\burpsuite_pro_v$v.jar`""
$batCmd | Add-Content -Path burp.bat
Write-Host "`n[✔] burp.bat file has been created."
Read-Host "`nPress Enter to exit..."

# Membuat file VBS untuk menjalankan burp.bat secara silent
Write-Host "`n[*] Creating Burp-Suite-Pro.vbs file..."
if (Test-Path Burp-Suite-Pro.vbs) {
    Remove-Item Burp-Suite-Pro.vbs -Force
}
@"
Set WshShell = CreateObject("WScript.Shell")
WshShell.Run chr(34) & "$pwd\burp.bat" & Chr(34), 0
Set WshShell = Nothing
"@ | Set-Content -Encoding ASCII -Path Burp-Suite-Pro.vbs
Write-Host "[✔] Burp-Suite-Pro.vbs file has been created."
Read-Host "`nPress Enter to exit..."

# Mengaktifkan loader.jar untuk keygen
Write-Host "`n[*] Reloading environment variables..."
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
Write-Host "`n[*] Starting Keygenerator (loader.jar)..."
Start-Process java.exe -ArgumentList "-jar loader.jar"
Write-Host "`n[*] Starting Burp Suite Pro..."
Start-Process java.exe -ArgumentList "--add-opens=java.desktop/javax.swing=ALL-UNNAMED --add-opens=java.base/java.lang=ALL-UNNAMED --add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED --add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED --add-opens=java.base/jdk.internal.org.objectweb.asm.Opcodes=ALL-UNNAMED -javaagent:`"loader.jar`" -noverify -jar `"burpsuite_pro_v$v.jar`""
Read-Host "`nPress Enter to exit..."
