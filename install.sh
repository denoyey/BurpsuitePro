#!/bin/bash

# Instalasi Dependencies
echo "Proses menginstall dependencies..."
sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove -y
sudo apt install git axel openjdk-21-jre openjdk-22-jre openjdk-23-jre -y

# Mengcloning repository github
git clone https://github.com/denoyey/BurpsuitePro.git
cd BurpsuitePro

# Mendownload BurpsuitePro Terbaru
echo "Proses mendownload BurpSuitePro versi terbaru..."
version=2025.7.3
url="https://portswigger-cdn.net/burp/releases/download?product=pro&type=Jar&version=$version"
axel "$url" -o "burpsuite_pro_v$version.jar"

# Menjalankan Kunci Lisensi BurpsuitePro
echo "Menjalankan loader lisensi BuprpsuitePro..."
(java -jar loader.jar) &

# Menjalankan BurpsuitePro
echo "Menjalankan BurpsuitePro..."
echo "java --add-opens=java.desktop/javax.swing=ALL-UNNAMED --add-opens=java.base/java.lang=ALL-UNNAMED --add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED --add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED --add-opens=java.base/jdk.internal.org.objectweb.asm.Opcodes=ALL-UNNAMED -javaagent:$(pwd)/loader.jar -noverify -jar $(pwd)/burpsuite_pro_v$version.jar &" > burpsuitepro
chmod +x burpsuitepro
cp burpsuitepro /bin/burpsuitepro
(./burpsuitepro)
