# **Instalación**

```bash
git clone https://github.com/FlickGMD/AutoBSPWM.git
cd AutoBSPWM
./Install.sh
```
- Este script esta diseñado, para que estes en la ruta que estes, se ejecute correctamente.
- Este script es funcional tanto en Kali Linux como en Parrot OS 
- Aún hay cambios experimentales en el script, pero no duraran mucho.

---

##### Sugerencias por parte del Editor

![image](https://github.com/user-attachments/assets/3f9dd2c3-db49-41d0-ab53-b5d5bc68df7e)

#### Mensajes de advertencia 

![image](https://github.com/user-attachments/assets/fbb5de54-9bf9-4230-8a9a-539f39436009)


---

#### Neofetch 'casero' 

[Creador original](https://github.com/gh0stzk/) del 'Neofetch' casero.

![image](https://github.com/user-attachments/assets/54146710-9b44-4687-9716-ceb01954b980)

---

#### Modulo para actualizar el sistema

![image](https://github.com/user-attachments/assets/6abfaba9-3395-429c-b829-aaa77d58fa67)


---
#### Eventos clicables en todos los modulos de la Polybar
![image](https://github.com/user-attachments/assets/4a9ff273-790f-4bf1-9588-3ba7a76fbf56)


---
#### Editor de BSPWM 
<img width="800" height="450" alt="image" src="https://github.com/user-attachments/assets/bd4f60d1-9a1f-47ef-8bd0-1a257a280f84" />

Este editor esta hecho en customtkinter usando librerias como [CTkColorPicker](https://github.com/Akascape/CTkColorPicker) y [CTkFileDialog](https://github.com/FlickGMD/CTkFileDialog/). Pero, por qué usar un editor? 
El editor se hizo con el fin de hacer una personalización mas sencilla, algo mas amigable para el usuario nuevo de Linux. Puedes editar todas las configuraciones que quieras, y cuando quieras regresarlo a la normalidad ahi tendras una opción para ello, diviertete!

---

**Menu de apagado**

<img width="1859" height="334" alt="image" src="https://github.com/user-attachments/assets/21b15942-b0f2-4fbc-ba54-6e87178d425c" />

Este menú cuenta con 4 opciones. 
- Bloquear el sistema usando i3lock
- Apagar el sistema usando systemctl
- Salir de la sesión actual de bspwm
- Reiniciar el sistema 

---
### Dunst 

<img width="316" height="102" alt="image" src="https://github.com/user-attachments/assets/d3cdbda7-0920-414f-931b-851919453ab7" />

Un simple demonio para notificaciones del sistema

**Calendario**

Creador original del [calendario](https://github.com/gh0stzk/dotfiles)

![image](https://github.com/user-attachments/assets/c2170dce-c22f-420a-b641-1ebb7fdf5e03)


---

### Selector de fondos de pantalla 

<img width="1902" height="373" alt="image" src="https://github.com/user-attachments/assets/4206172b-4ba2-4dde-ad22-3379b7691319" />

Creador original del [selector](https://github.com/gh0stzk)

Si quieres meterle mas fondos de pantalla para ser mostrados en el selector debes de irte a ~/Imágenes/wallpapers y ahi meter tu fondo de pantalla.

---
### Sudo PROMPT

<img width="1850" height="117" alt="image" src="https://github.com/user-attachments/assets/e534eabf-95cc-428c-b7c4-d07ab05631fa" />

---
### Bloqueador de pantalla 

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/0c566a88-4155-4ed2-b1b0-f569a078ae13" />

Creador original del [bloqueador](https://github.com/gh0stzk)

---
# Resultado *(Kali Linux)*
![image](https://github.com/user-attachments/assets/81e5eeba-36c8-4f31-8022-4d0c569b5b8d)



# Resultado *(Parrot OS)*
![image](https://github.com/user-attachments/assets/523cfb9b-6118-4db5-8604-30d61e7cf3d0)



---
# Scripts

### WhichSystem

<img width="1863" height="636" alt="image" src="https://github.com/user-attachments/assets/5d8dff7a-dd4c-4860-b18c-814b59962fec" />

Un simple script de bash, que se metio a la **".zshrc"**.



### [S4vimachines.sh](https://github.com/FlickGMD/s4vimachines.sh) **(Buscador de máquinas)**

![image](https://github.com/user-attachments/assets/c43de338-d4bf-4bfd-9e56-fdb5976013f6)


---


# Atajos de teclado

| Atajo                        | Comando / Acción                                                        |
|-----------------------------|---------------------------------------------------------------------------|
| Win + Enter                 | `kitty` – Abre el emulador de terminal                                  |
| Win + Shift + o             | `obsidian` – Abre la aplicación de notas Obsidian                       |
| Win + Shift + x             | `i3lock-fancy` – Bloquea la pantalla                                    |
| Win + d                     | `rofi -show drun` – Abre el lanzador de aplicaciones                    |
| Win + Escape                | `pkill -USR1 -x sxhkd` – Recarga la configuración de atajos (sxhkd)     |
| Win + Shift + f             | `firefox` – Abre el navegador Firefox                                   |
| Win + Shift + q             | Cierra BSPWM                                                            |
| Win + Shift + r             | Reinicia BSPWM                                                          |
| Win + q                     | Cierra la ventana actual                                                |
| Win + m                     | Alterna entre modo en mosaico y pantalla completa                       |
| Win + y                     | Mueve una ventana marcada a otra posición                               |
| Win + g                     | Intercambia con la ventana más grande                                   |
| Win + t                     | Establece la ventana como en mosaico (`tiled`)                          |
| Win + Shift + t             | Establece modo pseudo-tiled                                             |
| Win + s                     | Cambia a modo flotante                                                  |
| Win + f                     | Cambia a pantalla completa                                              |
| Win + Ctrl + m              | Marca la ventana                                                        |
| Win + Ctrl + x              | Bloquea la ventana (impide moverla o redimensionarla)                   |
| Win + Ctrl + y              | Hace que la ventana sea visible en todos los escritorios (sticky)       |
| Win + Ctrl + z              | Marca la ventana como privada                                           |
| Win + ← / ↓ / ↑ / →         | Mueve el foco entre ventanas en esa dirección                          |
| Win + Shift + ← ↓ ↑ →       | Intercambia la posición con otra ventana en esa dirección               |
| Win + p                     | Mueve el foco al nodo padre                                             |
| Win + b                     | Mueve el foco al "hermano" (ventana paralela)                           |
| Win + ,                     | Mueve el foco al primer nodo                                            |
| Win + .                     | Mueve el foco al segundo nodo                                           |
| Win + c / Shift + c         | Mueve el foco al nodo siguiente / anterior del escritorio               |
| Win + [ / ]                 | Cambia al siguiente / anterior nodo en el escritorio actual             |
| Win + ` / Tab               | Foco al último nodo / escritorio usado                                 |
| Win + o / i                 | Foco a la ventana más antigua / más reciente                           |
| Win + {1-9,0}               | Cambia al escritorio correspondiente                                    |
| Win + Shift + {1-9,0}       | Mueve la ventana al escritorio correspondiente                          |
| Win + Ctrl + Alt + ← ↓ ↑ → | Preselecciona dirección para próxima división de ventana                |
| Win + Ctrl + {1-9}          | Establece proporción del espacio para próxima ventana                   |
| Win + Ctrl + Alt + Space    | Cancela la preselección del nodo actual                                 |
| Win + Ctrl + Shift + Space  | Cancela la preselección del escritorio                                  |
| Win + Shift + ← ↓ ↑ →       | Mueve una ventana flotante                                              |
| Win + Alt + ← ↓ ↑ →         | Redimensiona la ventana (con script `bspwm_resize`)                     |
| Win + a                     | Hace captura con `flameshot`, la guarda y copia al portapapeles         |


**Un saludo a nuestro gran amigo S4vitar :)) y a ZLCube que fue de quien me inspire para este proyecto desde un principio. Cualquier problema que tengan no duden en contactarme a discord como pwnedbyme**

---

### Problemas y errores comunes

Si por desgracia llegas a tener algún error, puedes visitar el gitbook de pylon. Ahí encontraras solución a varios de los problemas que pueden surgir en bspwm.

[![BSPWM FIXES](https://pylonet.gitbook.io/~gitbook/image?url=https%3A%2F%2F811307675-files.gitbook.io%2F%7E%2Ffiles%2Fv0%2Fb%2Fgitbook-x-prod.appspot.com%2Fo%2Forganizations%252FwquVPFoIEgRKyhYSTfGW%252Fsites%252Fsite_EXziD%252Fsocialpreview%252Ft6eN9edJEnI3S1SjEkoi%252FBSPWM%2520FIXES.png%3Falt%3Dmedia%26token%3D9bb76ed0-7c66-46d0-a3f1-43a00046e43b&width=1200&height=630&sign=15a50fe&sv=2)](https://pylonet.gitbook.io/hack4u)
