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
W='\033[1;37m'
NC='\033[0m'

# Animasi loading
spinner() {
    local pid=$1
    local spin='◐◓◑◒'
    while kill -0 $pid 2>/dev/null; do
        for i in $(seq 0 3); do
            printf "\r[%c] " "${spin:$i:1}"
            sleep 0.1
        done
    done
    printf "\r[✓] "
}

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

# Cek Termux
if [ -z "$PREFIX" ]; then
    echo -e "${R}[✗] Script ini khusus Termux!${NC}"
    exit 1
fi

# ============================================================================
# INSTALL
# ============================================================================

echo -e "${B}[1/4] Menginstall dependencies...${NC}"

# System packages
{
    pkg update -y >/dev/null 2>&1
    pkg install -y python clang binutils zip git wget curl openjdk-17 lua5.3 >/dev/null 2>&1
} &
spinner $!
echo -e "${G}System packages ✓${NC}"

# Python packages
{
    pip install --upgrade pip >/dev/null 2>&1
    pip install rich pycryptodome zstandard gmalg requests colorama pytz cython >/dev/null 2>&1
} &
spinner $!
echo -e "${G}Python packages ✓${NC}"

# ============================================================================
# DOWNLOAD BINARY
# ============================================================================

echo -e "${B}[2/4] Downloading XIANMOD...${NC}"
mkdir -p "$HOME/XIANMOD"
cd "$HOME/XIANMOD"

{
    curl -sSL "https://raw.githubusercontent.com/XIANMOD/XIANTOOL/main/XIANMOD" -o XIANMOD
} &
spinner $!

if [ -f "XIANMOD" ]; then
    chmod +x XIANMOD
    echo -e "${G}XIANMOD binary ✓${NC}"
else
    echo -e "${R}[✗] Gagal download XIANMOD!${NC}"
    exit 1
fi

# ============================================================================
# DOWNLOAD & EXTRACT ENGINE.ZIP
# ============================================================================

echo -e "${B}[3/4] Downloading Engine.zip...${NC}"

ENGINE_DIR="$HOME/XIANMOD/@XIAN TOOL 45/ENGINE"
mkdir -p "$ENGINE_DIR"

{
    curl -sSL "https://raw.githubusercontent.com/XIANMOD/XIANTOOL/main/Engine.zip" -o /tmp/Engine.zip
} &
spinner $!

if [ -f "/tmp/Engine.zip" ]; then
    echo -e "${B}  Extracting Engine.zip...${NC}"
    {
        unzip -o /tmp/Engine.zip -d "$ENGINE_DIR" >/dev/null 2>&1
        rm -f /tmp/Engine.zip
    } &
    spinner $!
    echo -e "${G}Engine.zip extracted ✓${NC}"
else
    echo -e "${Y}[!] Engine.zip tidak ditemukan di GitHub!${NC}"
    echo -e "${Y}    Pastikan file Engine.zip sudah diupload.${NC}"
    echo -e "${Y}    Installasi tetap lanjut tanpa Engine.${NC}"
fi

# ============================================================================
# CREATE DIRECTORIES
# ============================================================================

echo -e "${B}[4/4] Membuat folder...${NC}"
{
    mkdir -p PAK UNPACK REPACK RESULT
    mkdir -p "@XIAN TOOL 45"/{EDIT,UNPACK,RESULT,PAK,ENGINE}
    mkdir -p "@XIAN TOOL 45"/LUA\ TOOL/{INPUT\ PAK,EXTRACT,LUA\ ORI,SOURCE,COMPILED,EDIT,RESULT}
} &
spinner $!
echo -e "${G}Folder structure ✓${NC}"

# ============================================================================
# LAUNCHER
# ============================================================================

cat > "$PREFIX/bin/xianmod" << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
cd ~/XIANMOD
./XIANMOD
EOF
chmod +x "$PREFIX/bin/xianmod"

# ============================================================================
# FINAL
# ============================================================================

echo
echo -e "${G}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${G}║               INSTALLASI SELESAI! 🎉                      ║${NC}"
echo -e "${G}╚═════════════════════════════════════════════════════════════╝${NC}"
echo
echo -e "${C}🚀 Jalankan:${NC}"
echo -e "${W}  xianmod${NC}"
echo
echo -e "${C}📁 Lokasi:${NC}"
echo -e "${W}  ~/XIANMOD/XIANMOD${NC}"
echo
echo -e "${G}=============================================================${NC}"
echo -e "${G}  MOD BY @XIANMOD${NC}"
echo -e "${G}=============================================================${NC}"
