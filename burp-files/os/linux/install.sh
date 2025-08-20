#!/bin/bash
# Github: github.com/denoyey/BurpsuitePro.git
# Script ini untuk menginstall Burp Suite Pro di Linux

clear

ascii_art="
░█░░░█▀█░▀█▀░█▀▀░█▀▀░▀█▀░░░█▀▄░█░█░█▀▄░█▀█░█▀█░█▀▄░█▀█
░█░░░█▀█░░█░░█▀▀░▀▀█░░█░░░░█▀▄░█░█░█▀▄░█▀▀░█▀▀░█▀▄░█░█
░▀▀▀░▀░▀░░▀░░▀▀▀░▀▀▀░░▀░░░░▀▀░░▀▀▀░▀░▀░▀░░░▀░░░▀░▀░▀▀▀                                                                                                                 
    Github: github.com/denoyey/BurpsuitePro.git
"
echo -e "$ascii_art"

# Menghapus file lama di /bin/
echo -e "\n[*] Checking for existing launcher in /bin/..."
if [[ -f /bin/burpsuitepro ]]; then
  echo -e "\n[*] Old launcher found. Removing..."
  sudo rm -f /bin/burpsuitepro
else
  echo -e "    [No existing launcher found in /bin/]"
fi

# Meminta versi BurpSuitePro dari user
echo -e "\n[*] Check the latest STABLE version at:"
echo -e "    https://portswigger.net/burp/releases/professional/latest"
echo -e "[!] Please use only a STABLE version (not Early Adopter or Beta)\n"
while true; do
  read -p "    >> Enter version (e.g., 2025.7.3): " version_input
  version="${version_input//./-}"
  latest_stable="https://portswigger.net/burp/releases/professional-community-$version?requestededition=professional"
  echo -e "\n[*] Checking URL: $latest_stable"
  status_code=$(curl -s -o /dev/null -w "%{http_code}" "$latest_stable")
  if [[ "$status_code" == "200" ]]; then
    echo -e "\n[*] Version $version_input is valid."
    break
  else
    echo -e "\n[!] Version $version_input is NOT valid. Please try again.\n"
  fi
done
echo -e "\n[*] Using version: $version_input"

# Nama folder instalasi
version="$version_input"
RUNTIME_DIR="$HOME/BurpsuitePro_v$version"
if [[ -d "$RUNTIME_DIR" ]]; then
  echo -e "\n[!] Directory already exists: $RUNTIME_DIR"
  read -p "    >> Do you want to delete and recreate it? (y/n): " confirm
  if [[ "$confirm" =~ ^[Yy]$ ]]; then
    rm -rf "$RUNTIME_DIR"
    echo -e "\n[*] Deleted existing directory."
  else
    echo -e "\n[!] Please remove or rename the existing folder before continuing."
    exit 1
  fi
fi

# Membuat folder runtime
echo -e "\n[*] Creating runtime directory at $RUNTIME_DIR..."
mkdir -p "$RUNTIME_DIR" && cd "$RUNTIME_DIR" || {
  echo "[!] Failed to create or enter directory."; exit 1;
}

# Instalasi dependencies
echo -e "\n[*] Installing dependencies..."
sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove -y
sudo apt install -y git axel

# Instalasi Java versi yang tersedia
for pkg in openjdk-21-jre openjdk-17-jre; do
  if apt-cache show "$pkg" &>/dev/null; then
    echo "[*] Installing available Java package: $pkg"
    sudo apt install -y "$pkg"
    break
  fi
done

# Download BurpSuitePro
echo -e "\n[*] Downloading latest BurpSuitePro..."
jar_name="burpsuite_pro_v$version.jar"
url="https://portswigger-cdn.net/burp/releases/download?product=pro&type=Jar&version=$version"

if axel "$url" -o "$jar_name"; then
  echo -e "\n[*] Download complete: $jar_name"
else
  echo -e "\n[!] Download failed!";
fi

# Download loader.jar jika belum ada
echo -e "\n[*] Checking license loader..."
if [[ ! -f loader.jar ]]; then
  echo "[*] loader.jar not found. Downloading from GitHub..."
  curl -L -o loader.jar "https://github.com/denoyey/BurpsuitePro/raw/refs/heads/main/loader.jar"
  curl -L -o loader.jar "https://github.com/denoyey/BurpsuitePro/raw/refs/heads/main/burp-files/loader/loader.jar"
  if [[ ! -f loader.jar ]]; then
    echo -e "\n[!] Failed to download loader.jar. Please check the URL or your connection."
    exit 1
  fi
fi

# Download logo.png jika belum ada
echo -e "\n[*] Checking BurpSuitePro logo..."
if [[ ! -f logo.png ]]; then
  echo "[*] logo.png not found. Downloading from GitHub..."
  curl -L -o logo.png "https://github.com/denoyey/BurpsuitePro/raw/main/logo.png"
  curl -L -o logo.png "https://github.com/denoyey/BurpsuitePro/blob/main/burp-files/img/logo.png"
  if [[ ! -f logo.png ]]; then
    echo -e "\n[!] Failed to download logo.png. Please check the URL or your connection."
    exit 1
  fi
fi

# Buat launcher script di folder instalasi
echo -e "\n[*] Creating launcher script..."
cat <<EOF > burpsuitepro
#!/bin/bash
# Github: https://github.com/denoyey/BurpsuitePro.git

DIR="\$(cd "\$(dirname "\${BASH_SOURCE[0]}")" && pwd)"

java \\
  --add-opens=java.desktop/javax.swing=ALL-UNNAMED \\
  --add-opens=java.base/java.lang=ALL-UNNAMED \\
  --add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED \\
  --add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED \\
  --add-opens=java.base/jdk.internal.org.objectweb.asm.Opcodes=ALL-UNNAMED \\
  -javaagent:"\$DIR/loader.jar" \\
  -noverify \\
  -jar "\$DIR/$jar_name" &
EOF

chmod +x burpsuitepro
sudo cp burpsuitepro /bin/burpsuitepro
echo "[*] CLI launcher installed: /bin/burpsuitepro"

# Buat launcher .desktop agar tampil di menu linux
echo -e "\n[*] Would you like to create a desktop menu shortcut?"
read -p "    >> Create desktop launcher? (y/n): " create_desktop

if [[ "$create_desktop" =~ ^[Yy]$ ]]; then
  echo "[*] Creating desktop launcher..."
  cat <<EOF > ~/.local/share/applications/burpsuitepro.desktop
[Desktop Entry]
Name=BurpSuitePro
Comment=Burp Suite Professional Launcher
Exec=$RUNTIME_DIR/burpsuitepro
Icon=$RUNTIME_DIR/logo.png
Terminal=false
Type=Application
Categories=Development;Security;
StartupNotify=true
EOF

  chmod +x ~/.local/share/applications/burpsuitepro.desktop
  echo -e "\n[*] Desktop launcher created at ~/.local/share/applications/burpsuitepro.desktop"
  echo -e "\n[*] You can now launch BurpSuitePro from your application menu."
else
  echo -e "\n[*] Skipping desktop launcher creation."
fi

# Jalankan loader
echo -e "\n[*] Starting license loader..."
(java -jar loader.jar) &

# Jalankan BurpSuitePro
echo -e "\n[*] Launching BurpSuitePro..."
./burpsuitepro
