#!/bin/bash

# Inicia Docker (por si acaso)
/usr/bin/init_docker.sh

# Arranca el contenedor EWW si no está corriendo
if ! /usr/bin/docker ps --format '{{.Names}}' | /usr/bin/grep -q 'eww_widget'; then
    /usr/bin/echo "Iniciando contenedor EWW..."
    /usr/bin/docker start eww_widget > /dev/null
fi

# Permite conexiones X11 desde el contenedor (como usuario normal)
/usr/bin/xhost +local:root > /dev/null
