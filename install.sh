#!/bin/bash

# Installing dependencies
echo -e "\n[*] Installing dependencies..."
sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove -y
sudo apt install -y git axel
for pkg in openjdk-21-jre openjdk-17-jre; do
  if apt-cache show "$pkg" &>/dev/null; then
    echo "[*] Installing available Java package: $pkg"
    sudo apt install -y "$pkg"
    break
  fi
done

# Cloning GitHub repository
echo -e "\n[*] Cloning GitHub repository..."
git clone https://github.com/denoyey/BurpsuitePro.git
cd BurpsuitePro

# Downloading latest BurpSuitePro
echo -e "\n[*] Downloading latest BurpSuitePro..."
version=2025.7.3
url="https://portswigger-cdn.net/burp/releases/download?product=pro&type=Jar&version=$version"
axel "$url" -o "burpsuite_pro_v$version.jar"

# Starting license loader
echo -e "\n[*] Starting license loader..."
(java -jar loader.jar) &

# Creating launcher
echo -e "\n[*] Creating launcher..."
cat <<EOF > burpsuitepro
#!/bin/bash
java \\
  --add-opens=java.desktop/javax.swing=ALL-UNNAMED \\
  --add-opens=java.base/java.lang=ALL-UNNAMED \\
  --add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED \\
  --add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED \\
  --add-opens=java.base/jdk.internal.org.objectweb.asm.Opcodes=ALL-UNNAMED \\
  -javaagent:\$(pwd)/loader.jar \\
  -noverify \\
  -jar \$(pwd)/burpsuite_pro_v$version.jar &
EOF

chmod +x burpsuitepro
sudo cp burpsuitepro /bin/burpsuitepro

# Launching BurpSuitePro
echo -e "\n[*] Launching BurpSuitePro..."
./burpsuitepro
