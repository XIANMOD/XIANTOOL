#!/data/data/com.termux/files/usr/bin/bash
# ============================================================================
# XIANMOD TOOL INSTALLER — @XIANMOD
# ============================================================================

MINT='\e[1;36m'
MINT2='\e[1;32m'
DIM='\e[2;36m'
RED='\e[1;31m'
WHITE='\e[1;37m'
NC='\e[0m'

GITHUB_RAW="https://raw.githubusercontent.com/XIANMOD/XIANTOOL/main"
HOME_DIR="$HOME"
ENGINE_DEST="$HOME_DIR/@XIAN TOOL 45/ENGINE"
BIN_DEST="$HOME_DIR/XIANMOD"
LAUNCHER_NAME="xianmod"

# ── Spinner ──────────────────────────────────────────────
FRAMES=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')
FI=0

run_step() {
    local label="$1"; shift
    printf "  ${MINT}${FRAMES[0]}${NC}  ${WHITE}%-40s${NC}" "$label"
    eval "$@" >/dev/null 2>&1 &
    local pid=$!
    while kill -0 "$pid" 2>/dev/null; do
        FI=$(( (FI+1) % 10 ))
        printf "\r  ${MINT}${FRAMES[$FI]}${NC}  ${WHITE}%-40s${NC}" "$label"
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
    local label="$1" delay="${2:-0.3}"
    printf "  ${MINT}${FRAMES[0]}${NC}  ${WHITE}%-40s${NC}" "$label"
    sleep "$delay" &
    local pid=$!
    while kill -0 "$pid" 2>/dev/null; do
        FI=$(( (FI+1) % 10 ))
        printf "\r  ${MINT}${FRAMES[$FI]}${NC}  ${WHITE}%-40s${NC}" "$label"
        sleep 0.08
    done
    wait "$pid"
    printf "\r  ${MINT2}✓${NC}  ${WHITE}%-40s${NC}${DIM} done${NC}\n" "$label"
}

# ── Banner ────────────────────────────────────────────────
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
printf "  ${DIM}Engine → ~/@XIAN TOOL 45/ENGINE/${NC}\n"
printf "\n"
printf "  ${MINT}──────────────────────────────────────────${NC}\n"
printf "\n"

# ──────────────────────────────────────────────────────────
#  STEP 1 — System packages
# ──────────────────────────────────────────────────────────
run_step "Updating package list"         "pkg update -y"
run_step "Installing Python"             "pkg install -y python"
run_step "Installing pip / setuptools"   "pip install --upgrade pip setuptools wheel --quiet"
run_step "Installing OpenSSL libs"       "pkg install -y openssl libcrypt"
printf "\n"

# ──────────────────────────────────────────────────────────
#  STEP 2 — Python packages
# ──────────────────────────────────────────────────────────
run_step "Installing rich"               "pip install rich --quiet"
run_step "Installing pycryptodome"       "pip install pycryptodome --quiet"
run_step "Installing zstandard"          "pip install zstandard --quiet"
run_step "Installing gmalg"              "pip install gmalg --quiet"
run_step "Installing pytz"               "pip install pytz --quiet"
run_step "Installing requests"           "pip install requests --quiet"
printf "\n"

# ──────────────────────────────────────────────────────────
#  STEP 3 — Directory & Engine
# ──────────────────────────────────────────────────────────
fake_step "Creating directory structure" 0.3
mkdir -p "$ENGINE_DEST"

# Download Engine.zip
run_step "Downloading Engine.zip" \
    "curl -sL \"$GITHUB_RAW/Engine.zip\" -o /tmp/Engine.zip"

if [ -f "/tmp/Engine.zip" ]; then
    run_step "Extracting Engine.zip" \
        "unzip -o /tmp/Engine.zip -d \"$ENGINE_DEST\" && rm -f /tmp/Engine.zip"
else
    printf "  ${RED}✗${NC}  ${WHITE}%-40s${NC}${RED} failed — file not found on GitHub${NC}\n" "Engine.zip"
    printf "  ${DIM}  → Tool tetap bisa jalan, tapi fitur Lua mungkin terbatas.${NC}\n"
fi
printf "\n"

# ──────────────────────────────────────────────────────────
#  STEP 4 — Binary & Launcher
# ──────────────────────────────────────────────────────────
run_step "Downloading XIANMOD binary" \
    "curl -sL \"$GITHUB_RAW/XIANMOD\" -o \"$BIN_DEST\""

if [ -f "$BIN_DEST" ]; then
    run_step "Setting XIANMOD permissions"   "chmod +x \"$BIN_DEST\""
else
    printf "  ${RED}✗${NC}  ${WHITE}%-40s${NC}${RED} failed to download binary${NC}\n" "XIANMOD binary"
    exit 1
fi

# Create launcher
fake_step "Creating launcher: $LAUNCHER_NAME" 0.3
cat > "$PREFIX/bin/$LAUNCHER_NAME" << EOF
#!/data/data/com.termux/files/usr/bin/bash
cd "$HOME_DIR"
./XIANMOD
EOF
chmod +x "$PREFIX/bin/$LAUNCHER_NAME"

# ──────────────────────────────────────────────────────────
#  DONE
# ──────────────────────────────────────────────────────────
printf "\n"
printf "  ${MINT}──────────────────────────────────────────${NC}\n"
printf "\n"
printf "  ${MINT2}✅  ${WHITE}Installation complete!${NC}\n"
printf "\n"
printf "  ${DIM}Run :${NC}  ${WHITE}$LAUNCHER_NAME${NC}\n"
printf "  ${DIM}Or  :${NC}  ${WHITE}cd ~ && ./XIANMOD${NC}\n"
printf "\n"
printf "${MINT}  ┌──────────────────────────────────────────┐${NC}\n"
printf "${MINT}  │${NC}${DIM}    Telegram : t.me/XIANMOD  |  @XIANMOD  ${NC}${MINT}│${NC}\n"
printf "${MINT}  └──────────────────────────────────────────┘${NC}\n"
printf "\n"run_step "Installing pytz"              "pip install pytz --quiet"
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
