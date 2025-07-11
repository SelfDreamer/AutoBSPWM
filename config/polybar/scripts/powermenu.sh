#!/usr/bin/env bash
# =============================================================
# ░█▀▄░█▀█░█▀▀░▀█▀
# ░█▀▄░█░█░█▀▀░░█░
# ░▀░▀░▀▀▀░▀░░░▀▀▀
# Author: FlickGMD 
# Repo: https://github.com/FlickGMD/AutoBSPWM
# Date: 2025-06-22 21:16:36
# Copyright (©)
# =============================================================

# ░█▀█░█▀▀░▀█▀░▀█▀░█▀█░█▀█░█▀▀
# ░█▀█░█░░░░█░░░█░░█░█░█░█░▀▀█
# ░▀░▀░▀▀▀░░▀░░▀▀▀░▀▀▀░▀░▀░▀▀▀
: '
Con declare y el parametro -A creamos un diccionario. 
Un diccionario contempla una clave y un valor. Y gracias a ello podemos almacenar algo tal que asi:
- (Icono) (Comando)
Aunque Bash los llama "Arrays asociativos".
'
declare -A actions=(
  [""]="/usr/bin/ScreenLocker"
  [""]="/usr/bin/bspc quit"
  [""]="/usr/bin/systemctl poweroff"
  [""]="/usr/bin/systemctl reboot"
#  [""]="/usr/bin/notify-send -t 1500 'Go to sleep' && systemctl suspend"
)

# ░▀█▀░█░█░█▀▀░█▄█░█▀▀
# ░░█░░█▀█░█▀▀░█░█░█▀▀
# ░░▀░░▀░▀░▀▀▀░▀░▀░▀▀▀
: '
Aqui creamos una variable temporal de solo lectura que valdra nuestro tema. 
"${HOME}" almacenara lo que valga nuestro /home/usuario. El directorio de trabajo del usuario actual, es una variable que siempre esta en bash. 
'
readonly THEME="${HOME}/.config/polybar/scripts/powermenu.rasi"

# ░█▀▀░█▀▀░█░░░█▀▀░█▀▀░▀█▀░█▀▀░█▀▄░░░█▀█░█▀█░▀█▀░▀█▀░█▀█░█▀█
# ░▀▀█░█▀▀░█░░░█▀▀░█░░░░█░░█▀▀░█░█░░░█░█░█▀▀░░█░░░█░░█░█░█░█
# ░▀▀▀░▀▀▀░▀▀▀░▀▀▀░▀▀▀░░▀░░▀▀▀░▀▀░░░░▀▀▀░▀░░░░▀░░▀▀▀░▀▀▀░▀░▀
: '
Creamos una variable que sera llamada "selected_option" que valdra la opcion seleccionada. 
Esta variable sera el resultado de un comando ejecutado a nivel de sistema en el cual tendra los siguientes comandos 
- printf: Nos sirve para imprimir valores por pantalla
- "%s\n"  Le indicamos a printf que en ese indice habra una cadena de texto seguido de un salto de linea \n  
- "${!actions[@]}" sirve para mostrar SOLO las claves de el diccionario
- El parámetro -dmenu en rofi sirve para activar el modo lista interactiva (inspirado en dmenu), donde puedes elegir una opción de una lista textual que se pasa por stdin.
- El parametro `-i` sirve para volver al menu insensible a minusculas y mayusculas, lo que se conoce como "key insensitive".
- `-theme` Para indicar el tema que usaremos, el cual valdra un archivo que es el que se declaro anteriormente como una variable de solo lectura.
'
selected_option=$(printf "%s\n" "${!actions[@]}" | rofi -dmenu -i -theme "${THEME}")

# ░█▀▀░█░█░█▀▀░█▀▀░█░█░▀█▀░█▀▀░░░█▀▀░█▀█░█▄█░█▄█░█▀█░█▀█░█▀▄
# ░█▀▀░▄▀▄░█▀▀░█░░░█░█░░█░░█▀▀░░░█░░░█░█░█░█░█░█░█▀█░█░█░█░█
# ░▀▀▀░▀░▀░▀▀▀░▀▀▀░▀▀▀░░▀░░▀▀▀░░░▀▀▀░▀▀▀░▀░▀░▀░▀░▀░▀░▀░▀░▀▀░

[[ -n "$selected_option" && -n "${actions["${selected_option}"]}" ]] && eval "${actions[$selected_option]}"
