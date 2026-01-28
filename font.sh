#!/bin/bash

# 1. Definir ruta y cargar colores AL PRINCIPIO
readonly path="$(realpath "$0" | rev | cut -d'/' -f2- | rev)"
cd "${path}" || exit 1
[[ -f ./Colors ]] && source ./Colors

function ctrl_c(){
  echo -e "\n\n${bright_red:-}[!] Deteniendo script...${end:-}\n"
  exit 1
}

trap ctrl_c INT

# 2. Definir VALORES POR DEFECTO (fuera de funciones para que sean accesibles)
INPUT_IMAGE="./wallpapers/Themes/Latte/HTB.jpg"
FONT_PATH="/usr/share/fonts/truetype/HackNerdFont-Regular.ttf"
OUTPUT_IMAGE="./wallpapers/Wallpaper.jpg"
FILL="white"
NICKNAME="${NICKNAME}" # Vacío por defecto para detectar si se pasó por argumento o no

# 3. Bucle de argumentos CORREGIDO
# Usamos $# -gt 0 (mientras el número de argumentos sea mayor a 0)
while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    --input-image)
      INPUT_IMAGE="$2"
      shift 2 # Desplaza 2 posiciones (el flag y el valor)
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
      # Captura argumentos desconocidos para evitar bucles infinitos o errores
      echo "Opción desconocida: $1"
      exit 1
      ;;
  esac
done

# 4. Lógica interactiva (Si no se pasó nickname por argumento)
if [[ -z "${NICKNAME}" ]]; then
    echo -ne "\r${bright_cyan:-}[+]${bright_white:-} Introduce el nick que se vera reflejado en el fondo de pantalla: "
    read -r NICK_INPUT
    NICKNAME="${NICK_INPUT}"
fi

# Formatear el nick final (Si está vacío usa el usuario del sistema)
FINAL_NICK="@${NICKNAME:-$USER}"

# 5. Generar la imagen (Ya no necesita estar en una función aparte si es lineal)
convert "$INPUT_IMAGE" \
      -font "$FONT_PATH" \
      -pointsize 48 \
      -fill "${FILL}" \
      -gravity center \
      -annotate +0+140 "$FINAL_NICK" \
      "$OUTPUT_IMAGE" &>/dev/null

echo -e "\n${bright_green:-}[✓]${bright_white:-} Imagen generada, nombre de usuario:${bright_magenta:-} $FINAL_NICK${end:-}\n"
