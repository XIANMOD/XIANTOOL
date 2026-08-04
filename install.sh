#!/data/data/com.termux/files/usr/bin/bash
# ─────────────────────────────────────────────────────────────
#  XIANTOOL INSTALLER — @XIANMOD
# ─────────────────────────────────────────────────────────────

MINT='\e[1;36m'      # bright cyan (mint-like, universal)
MINT2='\e[1;32m'     # bright green (untuk ✓)
DIM='\e[2;36m'       # dim cyan
RED='\e[1;31m'       # error
WHITE='\e[1;37m'     # white text
NC='\e[0m'           # reset

GITHUB_RAW="https://raw.githubusercontent.com/XIANMOD/XIANTOOL/main"
ENGINE_DEST="$HOME/XIAN TOOL 45/ENGINE"

# ── Engine.zip: coba lokal dulu, kalau ga ada download dari GitHub ──
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd || echo "$HOME")"
if [ -f "$SCRIPT_DIR/Engine.zip" ]; then
    ENGINE_ZIP="$SCRIPT_DIR/Engine.zip"
else
    ENGINE_ZIP="/tmp/XIANTOOL_Engine.zip"
fi

# ── Cari XIANMOD binary ──────────────────────────────────────
if [ -f "$SCRIPT_DIR/XIANMOD" ]; then
    BINARY="$SCRIPT_DIR/XIANMOD"
else
    BINARY="$HOME/XIANMOD"
fi

# ─────────────────────────────────────────────────────────────
#  SPINNER
# ─────────────────────────────────────────────────────────────
_FRAMES=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')
_FI=0

run_step() {
    local label="$1"; shift
    printf "  ${MINT}${_FRAMES[0]}${NC}  ${WHITE}%-40s${NC}" "$label"
    eval "$@" >/dev/null 2>&1 &
    local pid=$!
    while kill -0 "$pid" 2>/dev/null; do
        _FI=$(( (_FI+1) % 10 ))
        printf "\r  ${MINT}${_FRAMES[$_FI]}${NC}  ${WHITE}%-40s${NC}" "$label"
        sleep 0.08
    done
    wait "$pid"; local code=$?
    if [ $code -eq 0 ]; then
        printf "\r  ${MINT2}✓${NC}  ${WHITE}%-40s${NC}${DIM} done${NC}\n" "$label"
    else
        printf "\r  ${RED}✗${NC}  ${WHITE}%-40s${NC}${RED} failed${NC}\n" "$label"
    fi
    return $code
}

fake_step() {
    local label="$1" delay="${2:-0.4}"
    printf "  ${MINT}${_FRAMES[0]}${NC}  ${WHITE}%-40s${NC}" "$label"
    sleep "$delay" &
    local pid=$!
    while kill -0 "$pid" 2>/dev/null; do
        _FI=$(( (_FI+1) % 10 ))
        printf "\r  ${MINT}${_FRAMES[$_FI]}${NC}  ${WHITE}%-40s${NC}" "$label"
        sleep 0.08
    done
    wait "$pid"
    printf "\r  ${MINT2}✓${NC}  ${WHITE}%-40s${NC}${DIM} done${NC}\n" "$label"
}

# ─────────────────────────────────────────────────────────────
#  BANNER (shadow art sama seperti di dalam main.py)
# ─────────────────────────────────────────────────────────────
clear
printf "\n"
printf "${MINT}  ██╗  ██╗██╗  █████╗ ███╗   ██╗${NC}\n"
printf "${MINT}  ╚██╗██╔╝██║ ██╔══██╗████╗  ██║${NC}\n"
printf "${MINT}   ╚███╔╝ ██║ ███████║██╔██╗ ██║${NC}\n"
printf "${MINT}   ██╔██╗ ██║ ██╔══██║██║╚██╗██║${NC}\n"
printf "${MINT}  ██╔╝ ██╗██║ ██║  ██║██║ ╚████║${NC}\n"
printf "${MINT}  ╚═╝  ╚═╝╚═╝ ╚═╝  ╚═╝╚═╝  ╚═══╝${NC}\n"
printf "${MINT}  ████████╗ ██████╗  ██████╗ ██╗${NC}\n"
printf "${MINT}  ╚══██╔══╝██╔═══██╗██╔═══██╗██║${NC}\n"
printf "${MINT}     ██║   ██║   ██║██║   ██║██║${NC}\n"
printf "${MINT}     ██║   ██║   ██║██║   ██║██║${NC}\n"
printf "${MINT}     ██║   ╚██████╔╝╚██████╔╝███████╗${NC}\n"
printf "${MINT}     ╚═╝    ╚═════╝  ╚═════╝ ╚══════╝${NC}\n"
printf "\n"
printf "${MINT}  ┌──────────────────────────────────────────┐${NC}\n"
printf "${MINT}  │${NC}${WHITE}       Installer  —  @XIANMOD             ${NC}${MINT}│${NC}\n"
printf "${MINT}  └──────────────────────────────────────────┘${NC}\n"
printf "\n"
printf "  ${DIM}Engine → ~/XIAN TOOL 45/ENGINE/${NC}\n"
printf "\n"
printf "  ${MINT}──────────────────────────────────────────${NC}\n"
printf "\n"

# ─────────────────────────────────────────────────────────────
#  SYSTEM PACKAGES
# ─────────────────────────────────────────────────────────────
run_step "Updating package list"         "pkg update -y"
run_step "Installing Python"             "pkg install -y python"
run_step "Installing pip / setuptools"   "pip install --upgrade pip setuptools wheel --quiet"
run_step "Installing OpenSSL libs"       "pkg install -y openssl libcrypt"
printf "\n"

# ─────────────────────────────────────────────────────────────
#  PYTHON PACKAGES
# ─────────────────────────────────────────────────────────────
run_step "Installing rich"               "pip install rich --quiet"
run_step "Installing pycryptodome"       "pip install pycryptodome --quiet"
run_step "Installing zstandard"          "pip install zstandard --quiet"
run_step "Installing gmalg"              "pip install gmalg --quiet"
run_step "Installing pytz"              "pip install pytz --quiet"
run_step "Installing requests"           "pip install requests --quiet"
printf "\n"

# ─────────────────────────────────────────────────────────────
#  ENGINE FILES
# ─────────────────────────────────────────────────────────────
fake_step "Creating directory structure" 0.3
mkdir -p "$ENGINE_DEST"

# Download Engine.zip kalau tidak ada lokal
if [ ! -f "$ENGINE_ZIP" ]; then
    run_step "Downloading Engine.zip" \
        "curl -sL \"$GITHUB_RAW/Engine.zip\" -o \"$ENGINE_ZIP\""
fi

if [ -f "$ENGINE_ZIP" ]; then
    run_step "Extracting Engine.zip" \
        "unzip -o \"$ENGINE_ZIP\" -d \"$ENGINE_DEST\""
else
    printf "  ${RED}✗${NC}  ${WHITE}%-40s${NC}${RED} not found after download${NC}\n" "Engine.zip"
fi

# ─────────────────────────────────────────────────────────────
#  BINARY
# ─────────────────────────────────────────────────────────────
if [ ! -f "$BINARY" ]; then
    run_step "Downloading XIANMOD binary" \
        "curl -sL \"$GITHUB_RAW/XIANMOD\" -o \"$HOME/XIANMOD\""
    BINARY="$HOME/XIANMOD"
fi

run_step "Setting XIANMOD permissions"   "chmod +x \"$BINARY\""
fake_step "Finalizing setup"             0.5

# ─────────────────────────────────────────────────────────────
#  DONE
# ─────────────────────────────────────────────────────────────
printf "\n"
printf "  ${MINT}──────────────────────────────────────────${NC}\n"
printf "\n"
printf "  ${MINT2}✅  ${WHITE}Installation complete!${NC}\n"
printf "\n"
printf "  ${DIM}Run :${NC}  ${WHITE}$BINARY${NC}\n"
printf "\n"
printf "${MINT}  ┌──────────────────────────────────────────┐${NC}\n"
printf "${MINT}  │${NC}${DIM}    Telegram : t.me/XIANMOD  |  @XIANMOD  ${NC}${MINT}│${NC}\n"
printf "${MINT}  └──────────────────────────────────────────┘${NC}\n"
printf "\n"
