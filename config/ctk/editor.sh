#!/usr/bin/env bash

# Obtener ruta del script y cambiar a ese directorio
ruta=$(realpath "$0" | rev | cut -d'/' -f2- | rev)
cd "$ruta"

# Crear entorno virtual si no existe
if [[ ! -d ".venv" ]]; then 
    python3 -m venv .venv 
fi 

# Activar entorno virtual
source .venv/bin/activate 

# Función para verificar si un paquete está instalado
function check_package() {
    echo $1
    python3 -c "import $1" &> /dev/null
}

# Instalar dependencias si no están instaladas
faltan_paquetes=0

for paquete in customtkinter CTkMessageBox PIL cv2; do
    if ! check_package "$paquete"; then
        faltan_paquetes=1
        break
    fi
done

if [[ $faltan_paquetes -eq 1 ]]; then
    pip install customtkinter CTkMessageBox pillow opencv-python
fi

# Ejecutar el script principal
./Editor.py || /bin/python3 Editor.py

