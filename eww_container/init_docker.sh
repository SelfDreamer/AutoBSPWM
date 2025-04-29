#!/bin/bash

# Verifica si Docker está corriendo
if ! /usr/bin/systemctl is-active --quiet docker; then
    /usr/bin/echo "Iniciando Docker..."
    /usr/bin/systemctl start docker
else
    /usr/bin/echo "Docker ya está en ejecución."
fi
