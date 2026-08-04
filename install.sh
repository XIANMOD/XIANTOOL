#!/data/data/com.termux/files/usr/bin/bash

# ============================================================================
# XIANMOD TOOL INSTALLER
# MOD BY @XIANMOD
# ============================================================================

R='\033[1;31m'
G='\033[1;32m'
Y='\033[1;33m'
B='\033[1;34m'
C='\033[1;36m'
M='\033[1;35m'
W='\033[1;37m'
NC='\033[0m'

clear
echo -e "${C}"
echo " ╔══════════════════════════════════════════════════════════════╗"
echo " ║  ██╗  ██╗██╗ █████╗ ███╗   ██╗███╗   ███╗ ██████╗ ██████╗  ║"
echo " ║  ╚██╗██╔╝██║██╔══██╗████╗  ██║████╗ ████║██╔═══██╗██╔══██╗ ║"
echo " ║   ╚███╔╝ ██║███████║██╔██╗ ██║██╔████╔██║██║   ██║██║  ██║ ║"
echo " ║   ██╔██╗ ██║██╔══██║██║╚██╗██║██║╚██╔╝██║██║   ██║██║  ██║ ║"
echo " ║  ██╔╝ ██╗██║██║  ██║██║ ╚████║██║ ╚═╝ ██║╚██████╔╝██████╔╝ ║"
echo " ║  ╚═╝  ╚═╝╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝     ╚═╝ ╚═════╝ ╚═════╝  ║"
echo " ╚══════════════════════════════════════════════════════════════╝"
echo -e "${Y}               INSTALLER - BY @XIANMOD${NC}"
echo

# ============================================================================
# CHECK TERMUX
# ============================================================================

if [ -z "$PREFIX" ]; then
    echo -e "${R}[!] This script is for Termux only!${NC}"
    exit 1
fi

echo -e "${B}[✓] Termux detected${NC}"
echo

# ============================================================================
# GITHUB REPO
# ============================================================================

REPO_USER="XIANMOD"
REPO_NAME="XIANTOOL"
RAW_URL="https://raw.githubusercontent.com/$REPO_USER/$REPO_NAME/main"

# ============================================================================
# INSTALL SYSTEM PACKAGES
# ============================================================================

echo -e "${B}[1/6] Installing system packages...${NC}"
echo

packages=("python" "clang" "binutils" "zip" "git" "wget" "curl" "python-dev" "openjdk-17" "lua5.3")

for pkg in "${packages[@]}"; do
    if ! command -v $pkg &> /dev/null 2>&1; then
        echo -e "${Y}  > Installing $pkg...${NC}"
        pkg install $pkg -y 2>/dev/null || true
    else
        echo -e "${G}  ✓ $pkg already installed${NC}"
    fi
done

echo -e "${G}✅ System packages installed!${NC}"

# ============================================================================
# INSTALL PYTHON PACKAGES
# ============================================================================

echo
echo -e "${B}[2/6] Installing Python packages...${NC}"
echo

# Upgrade pip
echo -e "${Y}  > Upgrading pip...${NC}"
pip install --upgrade pip 2>/dev/null || true

# Install required packages
python_packages=(
    "rich"
    "pycryptodome"
    "zstandard"
    "gmalg"
    "requests"
    "colorama"
    "pytz"
    "cython"
)

for pkg in "${python_packages[@]}"; do
    echo -e "${Y}  > Installing $pkg...${NC}"
    pip install $pkg 2>/dev/null || {
        echo -e "${R}  ✗ Failed to install $pkg${NC}"
    }
done

echo -e "${G}✅ Python packages installed!${NC}"

# ============================================================================
# DOWNLOAD MAIN BINARY
# ============================================================================

echo
echo -e "${B}[3/6] Downloading XIANMOD binary...${NC}"

# Create folder
mkdir -p "$HOME/XIANMOD"
cd "$HOME/XIANMOD"

# Download binary XIANMOD
echo -e "${Y}  > Downloading XIANMOD...${NC}"
wget -q "$RAW_URL/XIANMOD" -O XIANMOD 2>/dev/null || {
    curl -sSL "$RAW_URL/XIANMOD" -o XIANMOD 2>/dev/null || {
        echo -e "${R}[!] Binary download failed!${NC}"
        exit 1
    }
}

chmod +x XIANMOD

if [ ! -f "XIANMOD" ]; then
    echo -e "${R}[!] XIANMOD binary not found!${NC}"
    exit 1
fi

echo -e "${G}✅ XIANMOD binary downloaded!${NC}"

# ============================================================================
# DOWNLOAD ENGINE.ZIP
# ============================================================================

echo
echo -e "${B}[4/6] Downloading Engine.zip...${NC}"

ENGINE_DIR="$HOME/XIANMOD/@XIAN TOOL 45/ENGINE"
mkdir -p "$ENGINE_DIR"

echo -e "${Y}  > Downloading Engine.zip...${NC}"
wget -q "$RAW_URL/Engine.zip" -O /tmp/Engine.zip 2>/dev/null || {
    curl -sSL "$RAW_URL/Engine.zip" -o /tmp/Engine.zip 2>/dev/null || {
        echo -e "${R}[!] Engine.zip download failed!${NC}"
        exit 1
    }
}

if [ -f "/tmp/Engine.zip" ]; then
    echo -e "${Y}  > Extracting Engine.zip...${NC}"
    unzip -o /tmp/Engine.zip -d "$ENGINE_DIR" 2>/dev/null || {
        echo -e "${R}[!] Failed to extract Engine.zip${NC}"
        exit 1
    }
    rm -f /tmp/Engine.zip
    echo -e "${G}✅ Engine.zip extracted to $ENGINE_DIR${NC}"
    
    # Show contents
    echo -e "${Y}  > Engine contents:${NC}"
    ls -la "$ENGINE_DIR" | grep -v "^d" | awk '{print "    " $9}' | head -10
else
    echo -e "${R}[!] Engine.zip not found!${NC}"
    exit 1
fi

# ============================================================================
# CREATE DIRECTORY STRUCTURE
# ============================================================================

echo
echo -e "${B}[5/6] Creating directory structure...${NC}"

cd "$HOME/XIANMOD"

# Main directories
mkdir -p PAK UNPACK REPACK RESULT

# @XIAN TOOL 45 directories
mkdir -p "@XIAN TOOL 45"/{EDIT,UNPACK,RESULT,PAK,ENGINE}

# LUA TOOL directories
mkdir -p "@XIAN TOOL 45"/LUA\ TOOL/{INPUT\ PAK,EXTRACT,LUA\ ORI,SOURCE,COMPILED,EDIT,RESULT}

echo -e "${G}✅ Directory structure created!${NC}"

# ============================================================================
# CREATE LAUNCHER
# ============================================================================

echo
echo -e "${B}[6/6] Creating launcher...${NC}"

# Launcher untuk binary
cat > "$PREFIX/bin/xianmod" << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
cd ~/XIANMOD
./XIANMOD
EOF

chmod +x "$PREFIX/bin/xianmod"

# Launcher alternatif di folder
cat > "$HOME/XIANMOD/run.sh" << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
cd ~/XIANMOD
./XIANMOD
EOF

chmod +x "$HOME/XIANMOD/run.sh"

echo -e "${G}✅ Launcher created: 'xianmod'${NC}"

# ============================================================================
# FINAL
# ============================================================================

echo
echo -e "${G}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${G}║               INSTALLATION COMPLETE!                       ║${NC}"
echo -e "${G}╚═════════════════════════════════════════════════════════════╝${NC}"
echo
echo -e "${C}🚀 Cara menjalankan:${NC}"
echo -e "${W}  xianmod${NC}"
echo -e "${W}  atau cd ~/XIANMOD && ./XIANMOD${NC}"
echo
echo -e "${C}📁 Lokasi:${NC}"
echo -e "${W}  ~/XIANMOD/XIANMOD  (Binary)${NC}"
echo -e "${W}  ~/XIANMOD/@XIAN TOOL 45/ENGINE/  (Engine tools)${NC}"
echo
echo -e "${C}📦 Isi Engine:${NC}"
if [ -d "$ENGINE_DIR" ]; then
    for file in "$ENGINE_DIR"/*; do
        if [ -f "$file" ]; then
            echo -e "${W}  • $(basename "$file")${NC}"
        fi
    done
fi
echo
echo -e "${C}📁 Struktur Folder:${NC}"
echo -e "${W}  ~/XIANMOD/${NC}"
echo -e "${W}    ├── XIANMOD        (Binary utama)${NC}"
echo -e "${W}    ├── PAK/           (Input PAK)${NC}"
echo -e "${W}    ├── UNPACK/        (Hasil unpack)${NC}"
echo -e "${W}    ├── REPACK/        (File repack)${NC}"
echo -e "${W}    ├── RESULT/        (Hasil repack)${NC}"
echo -e "${W}    └── @XIAN TOOL 45/${NC}"
echo -e "${W}         ├── ENGINE/   (unluac, luac, lua5.3)${NC}"
echo -e "${W}         └── LUA TOOL/ (Lua decompile/recompile)${NC}"
echo
echo -e "${G}=============================================================${NC}"
echo -e "${G}  MOD BY @XIANMOD${NC}"
echo -e "${G}=============================================================${NC}"
echo
