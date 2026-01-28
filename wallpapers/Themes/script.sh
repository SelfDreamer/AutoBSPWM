#!/bin/bash
# Script de prueba que se hizo para cambiar la paleta de colores de los wallpapers.
# No ejecutar por NADA del mundo.

THEME="mocha"
THEME_CAP="${THEME^}"
# - En este caso la expansión de variable es la siguiente:
# ${THEME^} -> Ese "^" del final, es para indicarle que queremos capitalizar la palabra, en este caso, hacer la primera letra [0], a mayusculas.

[[ ! "$(which lutgen)" ]] && exit 1 
SRC="$HOME/Imágenes/wallpapers/Themes/Default"
DEST="$HOME/Imágenes/wallpapers/Themes/${THEME_CAP}"

mkdir -p "$DEST"

cd "$SRC" || exit

for img in *; do
    [ -f "$img" ] || continue
    
    echo "Convirtiendo a ${THEME_CAP}: $img"
    
    lutgen apply -p catppuccin-"${THEME}" "$img" -o "$DEST/$img"
done
