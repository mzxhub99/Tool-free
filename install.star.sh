bash -c 'set -e
URL="https://github.com/mzxhub99/Tool-free/releases/download/Star-tool/Star_v4.zip"
FILE="Star_v4.py"
DIR="$HOME/star-tool"
GRN="\033[92m"; CY="\033[96m"; RED="\033[91m"; R="\033[0m"
clear
echo -e "\n  ${CY}════════════════════════════════════${R}"
echo -e "  ${CY}  STARPLUS+ v4 — INSTALLER${R}"
echo -e "  ${CY}════════════════════════════════════${R}\n"
echo -e "  ${CY}▸${R} [1/5] ตรวจสอบระบบ..."
[ -z "$PREFIX" ] && { echo -e "  ${RED}✘ ต้องรันใน Termux${R}"; exit 1; }
echo -e "  ${GRN}✔${R} พร้อม"
echo -e "  ${CY}▸${R} [2/5] ติดตั้งแพ็กเกจ..."
pkg update -y >/dev/null 2>&1
pkg install -y python wget unzip openssl >/dev/null 2>&1
command -v python3 &>/dev/null || ln -sf python "$PREFIX/bin/python3"
echo -e "  ${GRN}✔${R} ครบ"
echo -e "  ${CY}▸${R} [3/5] ติดตั้งไลบรารี..."
pip install -q requests >/dev/null 2>&1
echo -e "  ${GRN}✔${R} พร้อม"
echo -e "  ${CY}▸${R} [4/5] ขอสิทธิ์..."
[ -d "$HOME/storage" ] || termux-setup-storage >/dev/null 2>&1
echo -e "  ${GRN}✔${R} ได้รับ"
echo -e "  ${CY}▸${R} [5/5] ดาวน์โหลด..."
mkdir -p "$DIR"; cd "$DIR"
wget -q -O tool.zip "$URL" || { echo -e "  ${RED}✘ ดาวน์โหลดไม่ได้${R}"; exit 1; }
unzip -o -q tool.zip; rm -f tool.zip
PY=$(find "$DIR" -maxdepth 2 -name "*.py" -type f | head -n 1)
[ -n "$PY" ] && [ "$(basename "$PY")" != "$FILE" ] && mv "$PY" "$DIR/$FILE"
[ ! -f "$FILE" ] && { echo -e "  ${RED}✘ ไม่พบไฟล์ $FILE${R}"; exit 1; }
echo -e "  ${GRN}✔${R} เสร็จ\n"
echo -e "  ${GRN}✅ ติดตั้งสำเร็จ!${R}"
echo -e "  พิมพ์: ${CY}cd ~/star-tool && python $FILE${R}\n"'
