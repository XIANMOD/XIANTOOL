#!/data/data/com.termux/files/usr/bin/bash

# ============================================================================
# XIANTOOL INSTALLER
# MOD BY @XIANMOD
# ============================================================================

R='\033[1;31m'
G='\033[1;32m'
Y='\033[1;33m'
B='\033[1;34m'
C='\033[1;36m'
W='\033[1;37m'
NC='\033[0m'

clear
echo -e "${C}"
echo " ╔══════════════════════════════════════════════════════════════╗"
echo " ║  ██╗  ██╗██╗ █████╗ ███╗   ██╗████████╗ ██████╗  ██████╗ ██╗     ║"
echo " ║  ╚██╗██╔╝██║██╔══██╗████╗  ██║╚══██╔══╝██╔═══██╗██╔═══██╗██║     ║"
echo " ║   ╚███╔╝ ██║███████║██╔██╗ ██║   ██║   ██║   ██║██║   ██║██║     ║"
echo " ║   ██╔██╗ ██║██╔══██║██║╚██╗██║   ██║   ██║   ██║██║   ██║██║     ║"
echo " ║  ██╔╝ ██╗██║██║  ██║██║ ╚████║   ██║   ╚██████╔╝╚██████╔╝███████╗║"
echo " ║  ╚═╝  ╚═╝╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝    ╚═════╝  ╚═════╝ ╚══════╝║"
echo " ╚══════════════════════════════════════════════════════════════╝"
echo -e "${Y}               INSTALLER - BY @XIANMOD${NC}"
echo

# ============================================================================
# GITHUB REPO
# ============================================================================

REPO_USER="XIANMOD"
REPO_NAME="XIANTOOL"
RAW_URL="https://raw.githubusercontent.com/$REPO_USER/$REPO_NAME/main"

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
# INSTALL DEPENDENCIES
# ============================================================================

echo -e "${B}[1/3] Installing dependencies...${NC}"
echo

if ! command -v python &> /dev/null; then
    echo -e "${Y}  > Installing Python...${NC}"
    pkg install python -y 2>/dev/null || true
fi

if ! command -v pip &> /dev/null; then
    echo -e "${Y}  > Installing pip...${NC}"
    pkg install python-pip -y 2>/dev/null || true
fi

echo -e "${Y}  > Installing Python packages...${NC}"
pip install rich pycryptodome zstandard gmalg requests colorama 2>/dev/null || true

echo -e "${G}✅ Dependencies installed!${NC}"

# ============================================================================
# DOWNLOAD BINARY
# ============================================================================

echo
echo -e "${B}[2/3] Downloading XIANTOOL binary...${NC}"

mkdir -p "$HOME/XIANTOOL"
cd "$HOME/XIANTOOL"

echo -e "${Y}  > Downloading XIANTOOL...${NC}"
wget -q "$RAW_URL/XIANTOOL" -O XIANTOOL 2>/dev/null || {
    curl -sSL "$RAW_URL/XIANTOOL" -o XIANTOOL 2>/dev/null || {
        echo -e "${R}[!] Download failed!${NC}"
        exit 1
    }
}

chmod +x XIANTOOL

if [ ! -f "XIANTOOL" ]; then
    echo -e "${R}[!] Binary not found!${NC}"
    exit 1
fi

echo -e "${G}✅ Binary downloaded!${NC}"

# ============================================================================
# CREATE LAUNCHER
# ============================================================================

echo
echo -e "${B}[3/3] Creating launcher...${NC}"

cat > "$PREFIX/bin/XIANTOOL" << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
cd ~/XIANTOOL
./XIANTOOL
EOF

chmod +x "$PREFIX/bin/XIANTOOL"

echo -e "${G}✅ Launcher created: 'XIANTOOL'${NC}"

# ============================================================================
# FINAL
# ============================================================================

echo
echo -e "${G}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${G}║               INSTALLATION COMPLETE!                       ║${NC}"
echo -e "${G}╚═════════════════════════════════════════════════════════════╝${NC}"
echo
echo -e "${C}🚀 Cara menjalankan:${NC}"
echo -e "${W}  XIANTOOL${NC}"
echo -e "${W}  atau cd ~/XIANTOOL && ./XIANTOOL${NC}"
echo
echo -e "${C}📁 Lokasi:${NC}"
echo -e "${W}  ~/XIANTOOL/XIANTOOL${NC}"
echo
echo -e "${G}=============================================================${NC}"
echo -e "${G}  MOD BY @XIANMOD${NC}"
echo -e "${G}=============================================================${NC}"
echo