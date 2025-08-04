#!/usr/bin/env bash

ruta=$(realpath "$0" | rev | cut -d'/' -f2- | rev)
cd "${ruta}" || exit 1 

if [[ ! -d ".venv" ]]; then 
    python3 -m venv .venv 
fi 

source .venv/bin/activate 

if ./Editor.py; then 
  exit 
fi 

function check_package() {
    package="$1"
    python3 -c "import $package" &>/dev/null 
}

faltan_paquetes=0
for paquete in customtkinter CTkMessageBox pillow opencv-python CTkColorPicker CTkFileDialog tkfontchooser CTkToolTip; do
    if ! check_package "$paquete"; then
        faltan_paquetes=1
        break
    fi
done
if [[ $faltan_paquetes -eq 1 ]]; then
    pip install customtkinter CTkMessageBox pillow opencv-python CTkColorPicker CTkFileDialog tkfontchooser CTkToolTip 
fi
# Ejecutar el script principal
./Editor.py || /bin/python3 Editor.py
