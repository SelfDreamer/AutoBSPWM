#!/bin/bash

readonly path="$(realpath "$0" | rev | cut -d'/' -f2- | rev)"
cd "${path}" || exit 1
[[ -f ./Colors ]] && source ./Colors

function ctrl_c(){
  echo -e "\n\n${bright_red:-}[!] Deteniendo script...${end:-}\n"
  exit 1
}

trap ctrl_c INT

INPUT_IMAGE="./wallpapers/Themes/Default/HTB.jpg"
FONT_PATH="/usr/share/fonts/truetype/HackNerdFont-Regular.ttf"
OUTPUT_IMAGE="./wallpapers/Themes/Default/wallpaper.jpg"
FILL="white"
NICKNAME="${NICKNAME}" 

while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    --input-image)
      INPUT_IMAGE="$2"
      shift 2 
      ;;
    --font-path)
      FONT_PATH="$2"
      shift 2
      ;;
    --output-image)
      OUTPUT_IMAGE="$2"
      shift 2
      ;;
    --nickname)
      NICKNAME="${2}"
      shift 2
      ;;
    --fill)
      FILL="$2"
      shift 2
      ;;
    *)
      echo "Opción desconocida: $1"
      exit 1
      ;;
  esac
done

if [[ -z "${NICKNAME}" ]]; then
    echo -ne "\r${bright_cyan:-}[+]${bright_white:-} Introduce el nick que se vera reflejado en el fondo de pantalla: "
    read -r NICK_INPUT
    NICKNAME="${NICK_INPUT}"
fi

FINAL_NICK="@${NICKNAME:-$USER}"

convert "$INPUT_IMAGE" \
      -font "$FONT_PATH" \
      -pointsize 48 \
      -fill "${FILL}" \
      -gravity center \
      -annotate +0+140 "$FINAL_NICK" \
      "$OUTPUT_IMAGE" &>/dev/null

echo -e "\n${bright_green:-}[✓]${bright_white:-} Imagen generada, nombre de usuario:${bright_magenta:-} $FINAL_NICK${end:-}\n"
