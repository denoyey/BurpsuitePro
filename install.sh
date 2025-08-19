#!/bin/bash

# Update and install required dependencies
echo "[*] Installing required dependencies..."
sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove -y
sudo apt install -y git axel openjdk-21-jre openjdk-22-jre openjdk-23-jre

# Clone the GitHub repository
echo "[*] Cloning GitHub repository..."
git clone https://github.com/denoyey/BurpsuitePro.git
cd BurpsuitePro || { echo "[!] Failed to enter BurpsuitePro directory."; exit 1; }

# Fetch the latest Burp Suite Pro version number
echo "[*] Fetching the latest Burp Suite Pro version..."
latest_version=$(curl -s 'https://portswigger.net/burp/releases/professional?requestedplatform=linux' | grep -Po 'professional-community-\K[0-9]+\.[0-9]+\.[0-9]+' | head -n 1)

if [[ -z "$latest_version" ]]; then
  echo "[!] Failed to detect the latest Burp Suite version."
  exit 1
fi

echo "[*] Latest version detected: $latest_version"

# Construct download URL and download using axel
url="https://portswigger-cdn.net/burp/releases/download?product=pro&type=Jar&version=$latest_version"
echo "[*] Downloading Burp Suite Pro v$latest_version..."
axel "$url" -o "burpsuite_pro_v$latest_version.jar"

# Run the license loader
echo "[*] Starting Burp Suite Pro license loader..."
(java -jar loader.jar) &

# Create launcher script for Burp Suite Pro
echo "[*] Creating Burp Suite Pro launcher..."
cat <<EOF > burpsuitepro
#!/bin/bash
java \\
  --add-opens=java.desktop/javax.swing=ALL-UNNAMED \\
  --add-opens=java.base/java.lang=ALL-UNNAMED \\
  --add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED \\
  --add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED \\
  --add-opens=java.base/jdk.internal.org.objectweb.asm.Opcodes=ALL-UNNAMED \\
  -javaagent:$(pwd)/loader.jar \\
  -noverify \\
  -jar $(pwd)/burpsuite_pro_v$latest_version.jar &
EOF

# Make launcher executable and move it to /bin
chmod +x burpsuitepro
sudo cp burpsuitepro /bin/burpsuitepro

# Run Burp Suite Pro
echo "[*] Launching Burp Suite Pro..."
./burpsuitepro
