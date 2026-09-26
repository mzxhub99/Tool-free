#!/data/data/com.termux/files/usr/bin/bash
# ═══════════════════════════════════════════════════════════════
#  ⚡ StarPlus+ Installer v5.1.2 — HACK UI EDITION
#  ติดตั้ง STAR Tool ลง Termux 
#  ใช้งาน:  bash install_star.sh
# ═══════════════════════════════════════════════════════════════

set -e

URL="https://github.com/mzxhub99/Tool-free/releases/download/Star-tool/star_plus_5.1.2.zip"
FILE="star_plus_5.1.2.py"
DIR="$HOME/star-tool"

# ถ้าถูกเรียกด้วย sh ให้สลับมา bash
[ -n "$BASH_VERSION" ] || exec bash "$0" "$@"

# ───────────────── สี / เอฟเฟกต์ ─────────────────
if [ -t 1 ]; then
  R=$'\033[0m'; B=$'\033[1m'
  CY=$'\033[96m'; GRN=$'\033[92m'; YLW=$'\033[93m'
  RED=$'\033[91m'; GRY=$'\033[90m'; BLU=$'\033[38;2;45;110;255m'
else
  R=""; B=""; CY=""; GRN=""; YLW=""; RED=""; GRY=""; BLU=""
fi

# ไล่สีฟ้าคราม (น้ำเงินเข้ม → ไซแอน) — ใช้กับ ASCII art เท่านั้น
grad() {
  [ -t 1 ] || { printf '%s' "$1"; return; }
  local s="$1" n=${#1} i t r g b
  for ((i=0; i<n; i++)); do
    t=$(( i * 100 / (n>1 ? n-1 : 1) ))
    r=0
    g=$(( 86  + (229-86)  * t / 100 ))
    b=$(( 214 + (255-214) * t / 100 ))
    printf '\033[38;2;%d;%d;%dm%s' "$r" "$g" "$b" "${s:$i:1}"
  done
  printf '%s' "$R"
}

SPIN_PID=""
spin() {                       # ใช้แบบ background: spin "ข้อความ" &
  local msg="$1" sp="◐◓◑◒" i=0
  while :; do
    printf "\r  %b%s%b %b%s%b   " "$CY" "${sp:$((i%4)):1}" "$R" "$GRY" "$msg" "$R"
    i=$((i+1))
    sleep 0.08
  done
}
spin_on()  { spin "$1" & SPIN_PID=$!; }
spin_off() {
  if [ -n "$SPIN_PID" ]; then
    kill "$SPIN_PID" 2>/dev/null || true
    wait "$SPIN_PID" 2>/dev/null || true
    SPIN_PID=""
  fi
  printf '\r\033[K'
}

# แถบ progress ไล่สี แบบเร็ว ๆ (แค่ตกแต่ง)
bar() {
  [ -t 1 ] || { sleep "${1:-1}"; return; }
  local secs="${1:-1.2}" W=42 i j t r g b fill line steps ms
  ms="${secs//./}0"; steps=$(( ms / 3 )); [ $steps -gt 0 ] || steps=10
  for ((i=0; i<=steps; i++)); do
    fill=$(( i * W / steps ))
    line=""
    for ((j=0; j<W; j++)); do
      if (( j < fill )); then
        t=$(( j * 100 / (W-1) ))
        r=0; g=$(( 86 + (229-86)*t/100 )); b=$(( 214 + (255-214)*t/100 ))
        line+="\033[38;2;${r};${g};${b}m█"
      else
        line+="\033[90m░"
      fi
    done
    printf '\r  %b\033[0m' "$line"
    sleep 0.03
  done
  printf '\r\033[K'
}

step_do() { printf '  %b%s%b %b\n' "$CY" "▸" "$R" "$1"; }
step_ok() { printf '\r\033[K  %b✔%b %b%b%b %bOK%b\n' "$GRN" "$R" "$GRY" "$1" "$R" "$GRN" "$R"; }

die() {
  spin_off 2>/dev/null || true
  printf '\r\033[K'
  echo
  echo "  ${RED}✘ $1${R}"
  echo
  printf '  %b\n' "${RED}╔══════════════════════════════════════════╗${R}"
  printf '  %b\n' "${RED}║        ✘ INSTALL FAILED — ยกเลิก         ║${R}"
  printf '  %b\n' "${RED}╚══════════════════════════════════════════╝${R}"
  exit 1
}

trap 'spin_off 2>/dev/null; echo; echo "  ${YLW}ยกเลิกการติดตั้ง${R}"; exit 130' INT

# ───────────────── BANNER ─────────────────
BANNER=(
"  ███████╗████████╗ █████╗ ██████╗"
"  ██╔════╝╚══██╔══╝██╔══██╗██╔══██╗"
"  ███████╗   ██║   ███████║██████╔╝"
"  ╚════██║   ██║   ██╔══██║██╔══██╗"
"  ███████║   ██║   ██║  ██║██║  ██║"
"  ╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝"
)

clear
echo
for ln in "${BANNER[@]}"; do
  grad "$ln"; echo
  sleep 0.05
done
printf '  %b\n' "${GRY}──────────────────────────────────────────────${R}"
printf '  %b %b%s%b %b· AUTO REJOIN INSTALLER · TERMUX%b\n' \
  "$CY" "⚡" "$B" "STARPLUS+ v5.1.2" "$GRY" "$R"
printf '  %b\n' "${GRY}──────────────────────────────────────────────${R}"
echo

# boot animation
for s in "detect environment" "load ui engine" "arm installer"; do
  printf '  %b▸%b %b%-26s%b' "$CY" "$R" "$GRY" "$s" "$R"
  sleep 0.15
  printf ' %bOK%b\n' "$GRN" "$R"
done
echo

# ═══════════════════ ติดตั้งจริง ═══════════════════

# [1/5] เช็คว่าอยู่ใน Termux
step_do "[1/5] ตรวจสอบสภาพแวดล้อม"
if [ -z "$PREFIX" ] || [ ! -d "/data/data/com.termux" ]; then
  die "สคริปต์นี้ต้องรันในแอป Termux เท่านั้น"
fi
step_ok "Termux พร้อม"

# [2/5] แพ็กเกจระบบ
step_do "[2/5] ติดตั้งแพ็กเกจระบบ (python · wget · unzip)"
spin_on "apt กำลังทำงาน — ใช้เวลา 1-3 นาที อย่าปิดแอป"
pkg update -y >/dev/null 2>&1 || { spin_off; die "pkg update ไม่สำเร็จ — เช็คอินเทอร์เน็ตแล้วลองใหม่"; }
pkg install -y python wget unzip >/dev/null 2>&1 || { spin_off; die "pkg install ไม่สำเร็จ — ลองรัน pkg update ก่อนแล้วรันใหม่"; }
spin_off
step_ok "แพ็กเกจครบ"

# [3/5] โมดูล requests
step_do "[3/5] ติดตั้งโมดูล requests"
spin_on "pip install requests"
pip install -q requests >/dev/null 2>&1 || { spin_off; die "pip install requests ไม่สำเร็จ — เช็คอินเทอร์เน็ตแล้วลองใหม่"; }
spin_off
step_ok "requests พร้อม"

# [4/5] สิทธิ์ไฟล์
step_do "[4/5] ขอสิทธิ์เข้าถึงไฟล์"
if [ ! -d "$HOME/storage" ]; then
  echo
  printf '     %b⚠%b %bAndroid จะเด้งหน้าขอสิทธิ์ — กด [อนุญาต]%b\n' "$YLW" "$R" "$YLW" "$R"
  termux-setup-storage || true
  sleep 1
fi
step_ok "สิทธิ์เข้าถึงไฟล์พร้อม"

# [5/5] ดาวน์โหลด + แตกไฟล์
step_do "[5/5] ดาวน์โหลด STAR Tool จาก GitHub"
mkdir -p "$DIR"
cd "$DIR"
spin_on "กำลังโหลด star_plus_5.1.2.zip"
if ! wget -q -O tool.zip "$URL"; then
  spin_off; rm -f tool.zip
  die "ดาวน์โหลดไม่สำเร็จ — เช็คอินเทอร์เน็ต / ลิงก์ Release แล้วลองใหม่"
fi
spin_off
spin_on "กำลังแตกไฟล์"
unzip -o -q tool.zip || { spin_off; rm -f tool.zip; die "แตกไฟล์ zip ไม่สำเร็จ — ไฟล์ที่โหลดมาอาจเสีย ลองใหม่"; }
spin_off
rm -f tool.zip
step_ok "ไฟล์อยู่ที่ $DIR"

# ───────────────── ตรวจผลลัพธ์ ─────────────────
if [ -f "$FILE" ]; then
  bar 0.9
  echo
  printf '  %b\n' "${BLU}╔══════════════════════════════════════════╗${R}"
  printf '  %b  %b✔  INSTALL COMPLETE%b\n' "${BLU}" "${GRN}${B}" "${R}"
  printf '  %b  %bStarPlus+ v5.1.2 พร้อมใช้งาน%b\n' "${BLU}" "${GRN}" "${R}"
  printf '  %b\n' "${BLU}╚══════════════════════════════════════════╝${R}"
  echo
  # สร้างคำสั่งย่อ `star` (ถ้ายังไม่มี)
  if ! grep -q "alias star=" "$HOME/.bashrc" 2>/dev/null; then
    echo "alias star='cd ~/star-tool && python star_plus_5.1.2.py'" >> "$HOME/.bashrc"
  fi
  printf '  %bเปิดครั้งหน้า:%b พิมพ์ %bstar%b  (หรือ: cd ~/star-tool && python %s)\n' \
    "$GRN" "$R" "$CY${B}" "$R" "$FILE"
  echo
  bar 0.5
  printf '  %b▶%b เปิดโปรแกรมเลยไหม? (y/n): ' "$CY" "$R"
  read -r yn
  case "$yn" in
    y*|Y*) clear; exec python "$DIR/$FILE" ;;
    *) echo "  ${GRY}เสร็จสิ้น — เปิดภายหลังด้วยคำสั่ง star${R}" ;;
  esac
else
  die "ไม่พบไฟล์ $FILE หลังแตก zip — เช็คว่าไฟล์ใน Release ตั้งชื่อถูกต้อง"
fi
