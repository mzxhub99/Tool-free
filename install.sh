#!/data/data/com.termux/files/usr/bin/bash
# STAR v3.3 — One-line installer for Termux
# ใช้: curl -sL https://raw.githubusercontent.com/mzxhub99/Tool-free/main/install.sh | bash
set -e

REPO="mzxhub99/Tool-free"
DIR="$HOME/star-tool"
RAW="https://raw.githubusercontent.com/$REPO/main"

echo "════════════════════════════════════════"
echo "  STAR v3.3 · Auto Rejoin · installer"
echo "════════════════════════════════════════"

# 1) ติดตั้งแพ็กเกจ
echo "[1/4] ติดตั้งแพ็กเกจ..."
pkg update -y >/dev/null 2>&1 || true
pkg install -y python git wget unzip >/dev/null
pip install -q requests

# 2) termux-api (แจ้งเตือน)
command -v termux-notification >/dev/null 2>&1 || \
  echo "[!] อยากได้แจ้งเตือน → ติดตั้ง Termux:API จาก F-Droid"

# 3) สิทธิ์เข้าถึงไฟล์
[ -d "$HOME/storage" ] || (echo "[2/4] ขอสิทธิ์เข้าถึงไฟล์..." && termux-setup-storage || true)

# 4) ดาวน์โหลดไฟล์จาก Releases (ปลอดภัย ไม่เห็นโค้ด)
echo "[3/4] ดาวน์โหลด STAR Tool..."
mkdir -p "$DIR" && cd "$DIR"
wget -q -O tool.zip "https://github.com/$REPO/releases/download/v1.0/Rejoin.star.zip"
unzip -o -q tool.zip
rm tool.zip

echo "[4/4] เช็กไฟล์..."
[ -f "star_v33.py" ] && echo "  ✔ ไฟล์สมบูรณ์"

echo
echo "[✅] ติดตั้งเสร็จ — กำลังเปิดโปรแกรม..."
echo "────────────────────────────────────────"
exec python star_v33.py
