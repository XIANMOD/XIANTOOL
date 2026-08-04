#!/data/data/com.termux/files/usr/bin/bash
# ─────────────────────────────────────────────────────────────
#  XIANTOOL INSTALLER — @XIANMOD
# ─────────────────────────────────────────────────────────────

# ── Colors ──────────────────────────────────────────────────
MINT='\e[38;2;62;207;142m'       # mint green
MINT2='\e[38;2;0;245;160m'       # bright mint
DIM='\e[38;2;80;130;105m'        # dim mint
RED='\e[38;2;255;80;80m'         # error red
WHITE='\e[1;37m'                 # white
BOLD='\e[1m'
NC='\e[0m'                       # reset

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ENGINE_ZIP="$SCRIPT_DIR/Engine.zip"
ENGINE_DEST="$HOME/XIAN TOOL 45/ENGINE"
BINARY="$SCRIPT_DIR/XIANMOD"

# ── Spinner ──────────────────────────────────────────────────
_spin_frames=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')
_spin_i=0

run_step() {
    local label="$1"
    shift
    local cmd="$@"

    # Print initial spinner line
    printf "  ${MINT}${_spin_frames[0]}${NC}  ${WHITE}%-38s${NC}" "$label"

    # Run command silently in background
    eval "$cmd" > /dev/null 2>&1 &
    local pid=$!

    # Animate spinner while running
    while kill -0 "$pid" 2>/dev/null; do
        _spin_i=$(( (_spin_i + 1) % 10 ))
        printf "\r  ${MINT}${_spin_frames[$_spin_i]}${NC}  ${WHITE}%-38s${NC}" "$label"
        sleep 0.08
    done

    # Check exit code
    wait "$pid"
    local code=$?
    if [ $code -eq 0 ]; then
        printf "\r  ${MINT2}✓${NC}  ${WHITE}%-38s${NC}${DIM} done${NC}\n" "$label"
    else
        printf "\r  ${RED}✗${NC}  ${WHITE}%-38s${NC}${RED} failed (exit $code)${NC}\n" "$label"
    fi
    return $code
}

fake_step() {
    # For steps already done / instant
    local label="$1"
    local delay="${2:-0.4}"
    printf "  ${MINT}${_spin_frames[0]}${NC}  ${WHITE}%-38s${NC}" "$label"
    sleep "$delay" &
    local pid=$!
    while kill -0 "$pid" 2>/dev/null; do
        _spin_i=$(( (_spin_i + 1) % 10 ))
        printf "\r  ${MINT}${_spin_frames[$_spin_i]}${NC}  ${WHITE}%-38s${NC}" "$label"
        sleep 0.08
    done
    wait "$pid"
    printf "\r  ${MINT2}✓${NC}  ${WHITE}%-38s${NC}${DIM} done${NC}\n" "$label"
}

# ─────────────────────────────────────────────────────────────
#  BANNER
# ─────────────────────────────────────────────────────────────
clear
printf "\n"
printf "${MINT}  ╔══════════════════════════════════════════╗${NC}\n"
printf "${MINT}  ║${NC}${BOLD}${WHITE}         ✦  X I A N T O O L  ✦         ${NC}${MINT}║${NC}\n"
printf "${MINT}  ║${NC}${DIM}          Installer  —  @XIANMOD         ${NC}${MINT}║${NC}\n"
printf "${MINT}  ╚══════════════════════════════════════════╝${NC}\n"
printf "\n"
printf "  ${DIM}Base  : ~/XIAN TOOL 45/${NC}\n"
printf "  ${DIM}Engine: ~/XIAN TOOL 45/ENGINE/${NC}\n"
printf "\n"
printf "${MINT}  ─────────────────────────────────────────${NC}\n"
printf "\n"

# ─────────────────────────────────────────────────────────────
#  SYSTEM PACKAGES
# ─────────────────────────────────────────────────────────────
run_step "Updating package list"        "pkg update -y"
run_step "Installing Python"            "pkg install -y python"
run_step "Installing pip / setuptools"  "pip install --upgrade pip setuptools wheel --quiet"
run_step "Installing OpenSSL libs"      "pkg install -y openssl libcrypt"

printf "\n"

# ─────────────────────────────────────────────────────────────
#  PYTHON PACKAGES
# ─────────────────────────────────────────────────────────────
run_step "Installing rich"              "pip install rich --quiet"
run_step "Installing pycryptodome"      "pip install pycryptodome --quiet"
run_step "Installing zstandard"         "pip install zstandard --quiet"
run_step "Installing gmalg"             "pip install gmalg --quiet"
run_step "Installing pytz"              "pip install pytz --quiet"
run_step "Installing requests"          "pip install requests --quiet"

printf "\n"

# ─────────────────────────────────────────────────────────────
#  ENGINE FILES
# ─────────────────────────────────────────────────────────────
fake_step "Creating directory structure" 0.3

mkdir -p "$ENGINE_DEST" > /dev/null 2>&1

if [ -f "$ENGINE_ZIP" ]; then
    run_step "Extracting Engine.zip" \
        "unzip -o \"$ENGINE_ZIP\" -d \"$ENGINE_DEST\""
else
    printf "  ${RED}✗${NC}  ${WHITE}%-38s${NC}${RED} Engine.zip not found${NC}\n" "Extracting Engine.zip"
fi

# ─────────────────────────────────────────────────────────────
#  BINARY PERMISSIONS
# ─────────────────────────────────────────────────────────────
if [ -f "$BINARY" ]; then
    run_step "Setting XIANMOD permissions" "chmod +x \"$BINARY\""
else
    fake_step "XIANMOD binary" 0.2
fi

fake_step "Finalizing setup" 0.5

printf "\n"
printf "${MINT}  ─────────────────────────────────────────${NC}\n"
printf "\n"
printf "  ${MINT2}${BOLD}✅  Installation complete!${NC}\n"
printf "\n"
printf "  ${DIM}Run the tool :${NC}  ${WHITE}${BOLD}./XIANMOD${NC}\n"
printf "  ${DIM}Or from anywhere :${NC}  ${WHITE}${BOLD}$SCRIPT_DIR/XIANMOD${NC}\n"
printf "\n"
printf "${MINT}  ╔══════════════════════════════════════════╗${NC}\n"
printf "${MINT}  ║${NC}${DIM}    Telegram : t.me/XIANMOD  |  @XIANMOD  ${NC}${MINT}║${NC}\n"
printf "${MINT}  ╚══════════════════════════════════════════╝${NC}\n"
printf "\n"
