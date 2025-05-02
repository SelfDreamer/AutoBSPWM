#!/bin/bash
source ./Colors
function ctrl_c(){
  echo -e "\n\n${bright_red}[!] Deteniendo script...${end}\n"
  exit 1
}

trap ctrl_c INT

echo -ne "\r${bright_cyan}[+]${bright_white} Introduce el nick que se vera reflejado en el fondo de pantalla: " && read -r -t 50 NICK 

if [[ ! $NICK ]]; then
  NICK="@${USER}"
else
  NICK="@$NICK"
fi

# Ruta de la imagen original
INPUT_IMAGE="./wallpapers/HTB.jpg"

# Ruta de la fuente personalizada
FONT_PATH="/usr/share/fonts/truetype/HackNerdFont-Regular.ttf"

# Imagen de salida
OUTPUT_IMAGE="./wallpapers/Wallpaper.jpg"

# Agregar el texto en la imagen
convert "$INPUT_IMAGE" \
    -font "$FONT_PATH" \
    -pointsize 48 \
    -fill white \
    -gravity center \
    -annotate +0+140 "$NICK" \
    "$OUTPUT_IMAGE"

echo -e "\n${bright_green}[✓]${bright_white} Imagen generada, nombre de usuario:${bright_magenta} $NICK${end}\n"
