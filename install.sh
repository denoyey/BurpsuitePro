#!/bin/bash 

# Instalasi Dependencies 
echo "\n[*] Installing required dependencies..."
sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove -y sudo apt install git axel openjdk-21-jre openjdk-22-jre openjdk-23-jre -y 

# Mengcloning repository github
echo "\n[*] Cloning GitHub repository..."
git clone https://github.com/denoyey/BurpsuitePro.git
cd BurpsuitePro || { echo "[!] Directory not found."; exit 1; }

# Mendownload BurpsuitePro Terbaru. 
echo "\n[*] Detecting latest Burp Suite Pro version..."
version=$(curl -s 'https://portswigger.net/burp/releases/professional?requestedplatform=linux' | grep -Po 'download\?product=pro&type=Jar&version=\K[0-9]+\.[0-9]+\.[0-9]+' | head -n1)
if [[ -z "$version" ]]; then
  echo "[!] Gagal mendeteksi versi terbaru BurpSuite."
  exit 1
fi
echo "\n[*] Latest version detected: $latest_version"
url="https://portswigger-cdn.net/burp/releases/download?product=pro&type=Jar&version=$version"
axel "$url" -o "burpsuite_pro_v$version.jar"

# Menjalankan Kunci Lisensi BurpsuitePro
echo "\n[*] Starting license loader..."
(java -jar loader.jar) & 

# Menjalankan BurpsuitePro 
echo "\n[*] Creating launcher script..."
echo "java 
--add-opens=java.desktop/javax.swing=ALL-UNNAMED 
--add-opens=java.base/java.lang=ALL-UNNAMED 
--add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED 
--add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED 
--add-opens=java.base/jdk.internal.org.objectweb.asm.Opcodes=ALL-UNNAMED 
-javaagent:$(pwd)/loader.jar -noverify -jar $(pwd)/burpsuite_pro_v$version.jar &" > burpsuitepro chmod +x burpsuitepro cp burpsuitepro /bin/burpsuitepro (./burpsuitepro)
