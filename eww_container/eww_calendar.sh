#!/usr/bin/env bash

# Configuración segura
export PATH="/usr/bin:/bin"
readonly DOCKER="/usr/bin/docker"
readonly GREP="/usr/bin/grep"
readonly ECHO="/usr/bin/echo"
readonly SLEEP="/usr/bin/sleep"
readonly XHOST="/usr/bin/xhost"

# Verificación de dependencias
for cmd in "$DOCKER" "$GREP" "$ECHO" "$SLEEP"; do
    if [[ ! -x "$cmd" ]]; then
        "$ECHO" "Error: Comando no encontrado o no ejecutable: $cmd" >&2
        exit 1
    fi
done

# Verifica si el contenedor está corriendo
if ! "$DOCKER" ps --no-trunc --format '{{.Names}}' | "$GREP" -q '^eww_widget$'; then
    "$ECHO" "Iniciando contenedor EWW..."
    if ! "$DOCKER" start eww_widget >/dev/null 2>&1; then
        "$ECHO" "Error: Fallo al iniciar el contenedor" >&2
        exit 1
    fi
    "$SLEEP" 2
fi

# Permisos X11 (con validación)
"$XHOST" +local:root >/dev/null 2>&1

# Ejecución segura del comando EWW
"$DOCKER" exec --user eww_user eww_widget \
    /usr/bin/eww -c /home/eww_user/.config/eww open --toggle date   
