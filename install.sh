#!/data/data/com.termux/files/usr/bin/bash
set -e
clear
echo "════════════════════════════════════════"
echo "  STAR PLUS 5.1.2 · Auto Rejoin · installer"
echo "════════════════════════════════════════"

echo "[1/4] ติดตั้งแพ็กเกจ..."
pkg update -y >/dev/null 2>&1 || true
pkg install -y python wget unzip >/dev/null
pip install -q requests

echo "[2/4] ขอสิทธิ์เข้าถึงไฟล์..."
[ -d "$HOME/storage" ] || termux-setup-storage

echo "[3/4] ดาวน์โหลด STAR Tool..."
mkdir -p ~/star-tool && cd ~/star-tool

# ดาวน์โหลดไฟล์จาก Release
wget -O tool.zip "https://github.com/mzxhub99/Tool-free/releases/download/Star-tool/star_plus_5.1.2.zip"

unzip -o -q tool.zip
rm tool.zip

echo "[4/4] ตรวจสอบไฟล์..."
if [ -f "star_plus_5.1.2.py" ]; then
  echo "  ✔ ไฟล์สมบูรณ์"
  echo ""
  echo "[✅] ติดตั้งเสร็จ!"
  echo "พิมพ์: cd ~/star-tool && python star_v33.py"
else
  echo "  ❌ ไม่พบไฟล์ star_plus_5.1.2.py"
fi
