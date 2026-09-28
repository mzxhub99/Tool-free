#!/data/data/com.termux/files/usr/bin/bash
# ═══════════════════════════════════════════════════════════════
#  ⚡ StarPlus+ Installer v5.1.3 — สำหรับ Termux
#  ใช้งาน:  bash install_star.sh
# ═══════════════════════════════════════════════════════════════

set -e

# ========== ตั้งค่า ==========
URL="https://github.com/mzxhub99/Tool-free/releases/download/Star-tool/STARPLUS_ROOT_v5.1.3.zip"
FILE="STARPLUS_ROOT_v5.1.3.py"
DIR="$HOME/star-tool"

# สลับมา bash ถ้าเรียกผ่าน sh
[ -n "$BASH_VERSION" ] || exec bash "$0" "$@"

# ========== สี ==========
if [ -t 1 ]; then
  R=$'\033[0m'; B=$'\033[1m'
  CY=$'\033[96m'; GRN=$'\033[92m'; YLW=$'\033[93m'
  RED=$'\033[91m'; BLU=$'\033[34m'
else
  R=""; B=""; CY=""; GRN=""; YLW=""; RED=""; BLU=""
fi

spin() { local m="$1" s="◐◓◑◒"; while :; do printf "\r  %b%s%b %b%s%b  " "$CY" "${s:i++%4:1}" "$R" "$YLW" "$m" "$R"; sleep 0.08; done; }
spin_on() { spin "$1" & SPIN_PID=$!; }
spin_off() { kill "$SPIN_PID" 2>/dev/null; wait "$SPIN_PID" 2>/dev/null; printf '\r\033[K'; }
step_do() { printf '  %b▸%b %s\n' "$CY" "$R" "$1"; }
step_ok() { printf '\r\033[K  %b✔%b %s — %bOK%b\n' "$GRN" "$R" "$1" "$GRN" "$R"; }
die() { spin_off; echo -e "\n  ${RED}✘ $1${R}\n"; exit 1; }
trap 'spin_off; echo -e "\n  ${YLW}ยกเลิก${R}"; exit 130' INT

# ========== เริ่ม ==========
clear
echo -e "
  ${BLU}███████╗████████╗ █████╗ ██████╗${R}
  ${BLU}██╔════╝╚══██╔══╝██╔══██╗██╔══██╗${R}
  ${BLU}███████╗   ██║   ███████║██████╔╝${R}
  ${BLU}╚════██║   ██║   ██╔══██║██╔══██╗${R}
  ${BLU}███████║   ██║   ██║  ██║██║  ██║${R}
  ${BLU}╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝${R}

  ${B}STARPLUS+ v5.1.3${R} · ตัวติดตั้ง Termux
  ────────────────────────────────────────
"

# [1/5] ตรวจสภาพแวดล้อม
step_do "[1/5] ตรวจสอบระบบ"
[ -z "$PREFIX" ] && die "ต้องรันในแอป Termux เท่านั้น"
step_ok "Termux พร้อม"

# [2/5] ติดตั้งแพ็กเกจ
step_do "[2/5] ติดตั้งแพ็กเกจระบบ"
spin_on "กำลังติดตั้ง..."
pkg update -y >/dev/null 2>&1
pkg install -y python wget unzip openssl >/dev/null 2>&1

# สร้าง python3 ให้เรียกได้
if ! command -v python3 &>/dev/null; then
  ln -sf python "$PREFIX/bin/python3"
fi
spin_off
step_ok "แพ็กเกจครบ"

# [3/5] ติดตั้งโมดูล Python
step_do "[3/5] ติดตั้งไลบรารี"
pip install -q requests >/dev/null 2>&1
step_ok "พร้อม"

# [4/5] สิทธิ์ไฟล์
step_do "[4/5] ขอสิทธิ์เข้าถึงไฟล์"
[ ! -d "$HOME/storage" ] && termux-setup-storage >/dev/null 2>&1
step_ok "สิทธิ์ได้รับ"

# [5/5] ดาวน์โหลดและแตกไฟล์
step_do "[5/5] ดาวน์โหลดโปรแกรม"
mkdir -p "$DIR"
cd "$DIR"
spin_on "กำลังโหลด..."
wget -q -O tool.zip "$URL" || { spin_off; die "ดาวน์โหลดไม่สำเร็จ เช็คอินเทอร์เน็ต"; }
spin_off

spin_on "กำลังแตกไฟล์"
unzip -o -q tool.zip || { spin_off; rm -f tool.zip; die "แตกไฟล์ไม่สำเร็จ ไฟล์อาจเสีย"; }
rm -f tool.zip
spin_off

# จัดไฟล์ให้ตรงที่
PY_FOUND=$(find "$DIR" -maxdepth 2 -name "*.py" -type f | head -n 1)
if [ -n "$PY_FOUND" ] && [ "$(basename "$PY_FOUND")" != "$FILE" ]; then
  mv "$PY_FOUND" "$DIR/$FILE"
fi

# ตรวจสอบ
if [ ! -f "$FILE" ]; then
  ls -la "$DIR"
  die "ไม่พบไฟล์ $FILE — เช็คชื่อใน Release"
fi
step_ok "ติดตั้งเสร็จสิ้น"

# ========== เสร็จสิ้น ==========
echo -e "
  ${GRN}╔════════════════════════════════════════╗${R}
  ${GRN}║        ✅ ติดตั้งสำเร็จแล้ว!            ║${R}
  ${GRN}╚════════════════════════════════════════╝${R}

  พิมพ์เพื่อใช้งาน:
  ${CY}cd ~/star-tool && python $FILE${R}

  หรือตั้งค่าคำสั่งลัด:
  ${CY}echo \"alias star='cd ~/star-tool && python $FILE'\" >> ~/.bashrc${R}
  ${CY}source ~/.bashrc${R}
  แล้วพิมพ์: ${B}star${R}

  เปิดเลยไหม? (y/n): \c"

read -r ans
case "$ans" in
  y*|Y*) clear; exec python "$DIR/$FILE" ;;
  *) echo -e "\n  ${YLW}เรียกใช้ภายหลังด้วยคำสั่ง: star${R}" ;;
esac
