# Requires -RunAsAdministrator
# Github: github.com/denoyey/BurpsuitePro.git
# Script ini untuk menginstall Burp Suite Pro di Windows


function Download-FileWithProgress {
    param (
        [Parameter(Mandatory = $true)][string]$url,
        [Parameter(Mandatory = $true)][string]$output
    )
    $client = New-Object System.Net.WebClient
    $client.Proxy = [System.Net.WebRequest]::DefaultWebProxy
    $client.Proxy.Credentials = [System.Net.CredentialCache]::DefaultCredentials
    $progress = 0
    $client.DownloadProgressChanged += {
        $progress = $_.ProgressPercentage
        Write-Progress -Activity "Downloading $output" -Status "$progress% Complete" -PercentComplete $progress
    }
    $client.DownloadFileAsync($url, $output)
    while ($client.IsBusy) {
        Start-Sleep -Milliseconds 200
    }
    Write-Progress -Activity "Downloading $output" -Completed
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

# Membuat direktori instalasi jika belum ada dan masuk ke direktori
Write-Host "`n[*] Checking installation directory..."
$installDir = "C:\BurpsuitePro"
if (!(Test-Path -Path $installDir)) {
    Write-Host "`n[*] Creating installation directory: $installDir"
    New-Item -ItemType Directory -Path $installDir | Out-Null
} else {
    Write-Host "`n[*] Using existing directory: $installDir"
}
Set-Location -Path $installDir

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

function Test-BurpVersion($v) {
    try {
        $testUrl = "https://portswigger.net/burp/releases/download?product=pro&version=$v&type=Jar"
        Invoke-WebRequest -Uri $testUrl -Method Head -UseBasicParsing -ErrorAction Stop | Out-Null
        return $true
    } catch {
        return $false
    }
}

do {
    $inputVersion = Read-Host "    >> Enter Burp Suite Pro version (e.g. 2025.8.5)"
    $v = $inputVersion -replace '[-,\/]', '.'
    if (Test-BurpVersion $v) {
        Write-Host "`n    [DONE] Version '$v' is valid and available (.jar file found)."
        break
    } else {
        Write-Host "`n    [ALERT] Version '$v' not found or .jar file missing. Please try again.`n"
    }
} while ($true)

# Mendownload Burp Suite Pro .jar file
Write-Host "`n[*] Downloading Burp Suite Pro version $v..."
$jarPath = Join-Path -Path (Get-Location) -ChildPath "burpsuite_pro_v$v.jar"
$downloadUrl = "https://portswigger-cdn.net/burp/releases/download?product=pro&version=$v&type=Jar"

try {
    Download-FileWithProgress -url $downloadUrl -output $jarPath
    Write-Host "`n[DONE] Download complete: $jarPath"
} catch {
    Write-Host "`n[ALERT] Failed to download version '$v'. Check the version and your internet connection."
    Write-Host "    URL attempted: $downloadUrl"
    exit 1
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

# Membuat Burp Suite Pro .bat file
Write-Host "`n[*] Creating burp.bat file to run Burp Suite Pro"
$batContent = "java --add-opens=java.desktop/javax.swing=ALL-UNNAMED --add-opens=java.base/java.lang=ALL-UNNAMED --add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED --add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED --add-opens=java.base/jdk.internal.org.objectweb.asm.Opcodes=ALL-UNNAMED -javaagent:`"loader.jar`" -noverify -jar `"burpsuite_pro_v$v.jar`""
Set-Content -Path "burp.bat" -Value $batContent -Encoding ASCII
Write-Host "[DONE] burp.bat file has been created."

# Membuat VBS launcher untuk Burp Suite Pro
Write-Host "`n[*] Creating Burp-Suite-Pro.vbs launcher..."
$escapedPath = "`"$pwd\burp.bat`""
$vbsContent = @"
Set WshShell = CreateObject("WScript.Shell")
WshShell.Run $escapedPath, 0
Set WshShell = Nothing
"@
Set-Content -Path "Burp-Suite-Pro.vbs" -Value $vbsContent -Encoding ASCII
Write-Host "[DONE] Burp-Suite-Pro.vbs file has been created."

Write-Host "`n[*] Launching Burp Suite Pro..."
Start-Process java.exe -ArgumentList "--add-opens=java.desktop/javax.swing=ALL-UNNAMED --add-opens=java.base/java.lang=ALL-UNNAMED --add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED --add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED --add-opens=java.base/jdk.internal.org.objectweb.asm.Opcodes=ALL-UNNAMED -javaagent=`"loader.jar`" -noverify -jar `"burpsuite_pro_v$v.jar`""

Write-Host "`n[*] Cleaning up cloned repository directory (if applicable)..."
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
if ((Split-Path $scriptDir -Leaf) -eq "BurpsuitePro") {
    try {
        Remove-Item -Path $scriptDir -Recurse -Force
        Write-Host "[*] Cloned repo removed successfully."
    } catch {
        Write-Host "[!] Failed to remove the cloned directory: $scriptDir"
    }
} else {
    Write-Host "[*] Skipping folder cleanup (not a cloned repo)."
}

Read-Host "`nPress Enter to exit..."
