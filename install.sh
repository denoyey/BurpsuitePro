#!/bin/bash

set -e

echo "[*] Installing required dependencies..."
sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove -y

# Choose a valid OpenJDK version
JAVA_PKG="openjdk-17-jre-headless"  # or openjdk-21-jre
echo "[*] Installing Java package: $JAVA_PKG"
sudo apt install -y git axel "$JAVA_PKG"

echo "[*] Cloning GitHub repository..."
git clone https://github.com/denoyey/BurpsuitePro.git
cd BurpsuitePro || { echo "[!] Directory not found."; exit 1; }

echo "[*] Detecting latest Burp Suite Pro version..."
latest_version=$(curl -s 'https://portswigger.net/burp/releases/professional?requestedplatform=linux' \
    | grep -Po '(?<=professional-community-)[0-9]+\.[0-9]+\.[0-9]+' \
    | head -n 1)

if [[ -z "$latest_version" ]]; then
  echo "[!] Could not detect the latest version."
  exit 1
fi
echo "[*] Latest version detected: $latest_version"

download_url="https://portswigger-cdn.net/burp/releases/download?product=pro&type=Jar&version=$latest_version"
echo "[*] Downloading Burp Suite Pro v$latest_version..."
axel -q -o "burpsuite_pro_v$latest_version.jar" "$download_url"

echo "[*] Starting license loader..."
(java -jar loader.jar) &

echo "[*] Creating launcher script..."
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
  -jar \$(pwd)/burpsuite_pro_v$latest_version.jar &
EOF

chmod +x burpsuitepro
sudo mv burpsuitepro /usr/local/bin/burpsuitepro

echo "[*] Launching Burp Suite Pro..."
burpsuitepro
