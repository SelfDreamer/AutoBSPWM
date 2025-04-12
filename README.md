# **Instalación**

```bash
git clone https://github.com/FlickGMD/AutoBSPWM.git
cd AutoBSPWM
./Install.sh
```
- Este script esta diseñado, para que estes en la ruta que estes, se ejecute correctamente.

---

##### Mensajes de Adveretencia y ayuda por parte del editor

![image](https://github.com/user-attachments/assets/7d0d1686-ca0f-44ac-905b-7b86d744e98e)

![image](https://github.com/user-attachments/assets/7b6f6282-f8ea-4440-b403-55cae7c43bef)


---

**Menu**

Creador original del [menú](https://github.com/zelaya420/bspwm)

![image](https://github.com/user-attachments/assets/c3f5bb36-9684-4e2e-860f-80dc2b0da901)


**Calendario**

Creador original del [calendario](https://github.com/gh0stzk/dotfiles)

![image](https://github.com/user-attachments/assets/47376f6d-3b5e-4ef1-af53-982dfc361235)


- Se activara al presionar el icono de arch con click izquierdo, mataremos el proceso con click derecho.

> [!NOTE]
> Si estas usando **Parrot OS** no podras instalar *eww*.

---
# Resultado *(Kali Linux)*
![image](https://github.com/user-attachments/assets/518474eb-5f5a-4af0-b047-e0048bef4f32)


# Resultado *(Parrot OS)*
![image](https://github.com/user-attachments/assets/1791fe97-b9be-4315-b17b-32c84eb7ee01)


---


# Atajos de teclado

## Hotkeys independientes del gestor de ventanas (WM Independent Hotkeys)

- **Windows + Enter**  
  Abre el emulador de terminal `kitty`.

- **Windows + Shift + o**  
  Abre la aplicación `Obsidian`.

- **Windows + Shift + x**  
  Bloquea la pantalla con `i3lock-fancy`.

- **Windows + d**  
  Abre el lanzador de aplicaciones `rofi` con la opción `drun`.

- **Windows + Escape**  
  Recarga la configuración de `sxhkd`.

- **Windows + Shift + f**  
  Abre el navegador `Firefox`.

## Hotkeys específicos de BSPWM (BSPWM Hotkeys)

- **Windows + Shift + {q,r}**  
  Cierra o reinicia BSPWM.

- **Windows + {_,Shift + }q**  
  Cierra o mata la ventana o nodo actual.

- **Windows + m**  
  Alterna entre los modos de disposición en BSPWM: **tiled** (cuadrícula) y **monocle** (pantalla completa).

- **Windows + y**  
  Mueve el nodo marcado más reciente a la posición del nodo preseleccionado más reciente.

- **Windows + g**  
  Intercambia el nodo actual con la ventana más grande.

## Estado y banderas (State/Flags)

- **Windows + {t, Shift + t, s, f}**  
  Cambia el estado de la ventana actual a: **tiled** (cuadrícula), **pseudo_tiled**, **floating** (flotante), o **fullscreen** (pantalla completa).

- **Windows + Ctrl + {m,x,y,z}**  
  Activa las banderas del nodo: **marked**, **locked**, **sticky**, o **private**.

## Foco e intercambio (Focus/Swap)

- **Windows + {_, Shift + }{Left, Down, Up, Right}**  
  Focaliza el nodo en la dirección indicada: **west** (izquierda), **south** (abajo), **north** (arriba), **east** (derecha).

- **Windows + {p, b, comma, period}**  
  Focaliza un nodo relacionado según el tipo de salto de ruta: **parent**, **brother**, **first**, **second**.

- **Windows + {_, Shift + }c**  
  Focaliza el siguiente o el nodo anterior de la ventana en el escritorio actual.

- **Windows + bracket{left, right}**  
  Focaliza el siguiente o el nodo anterior en el escritorio del monitor actual.

- **Windows + {grave, Tab}**  
  Focaliza el último nodo o escritorio utilizado.

- **Windows + {o,i}**  
  Focaliza el nodo más antiguo o más reciente en el historial de enfoque.

- **Windows + {_, Shift + }{1-9,0}**  
  Focaliza o mueve el nodo al escritorio correspondiente.

## Preselección (Preselect)

- **Windows + Ctrl + Alt + {Left, Down, Up, Right}**  
  Preselecciona la dirección: **west**, **south**, **north**, **east**.

- **Windows + Ctrl + {1-9}**  
  Preselecciona la relación de tamaño (ratio) del nodo: 0.1 a 0.9.

- **Windows + Ctrl + Alt + space**  
  Cancela la preselección del nodo actual.

- **Windows + Ctrl + Shift + space**  
  Cancela la preselección del escritorio actual.

## Mover/Redimensionar (Move/Resize)

- **Windows + Shift + {Left, Down, Up, Right}**  
  Mueve una ventana flotante en la dirección indicada.

- **Windows + Alt + {Left, Down, Up, Right}**  
  Redimensiona la ventana en la dirección indicada con un script personalizado `bspwm_resize`.

## Captura de pantalla

- **Windows + a**  
  Realiza una captura de pantalla con `flameshot`, la guarda en el directorio `~/Imágenes/capturas/` y la copia al portapapeles con `xclip`.

**Un saludo a nuestro gran amigo S4vitar :)) y a ZLCube que fue de quien me inspire para este proyecto desde un principio. Cualquier problema que tengan no duden en contactarme a discord como pwnedbyme**

---

### Problemas y errores comunes

Si por desgracia llegas a tener algún error, puedes visitar el gitbook de pylon. Ahí encontraras solución a varios de los problemas que pueden surgir en bspwm.

[![BSPWM FIXES](https://pylonet.gitbook.io/~gitbook/image?url=https%3A%2F%2F811307675-files.gitbook.io%2F%7E%2Ffiles%2Fv0%2Fb%2Fgitbook-x-prod.appspot.com%2Fo%2Forganizations%252FwquVPFoIEgRKyhYSTfGW%252Fsites%252Fsite_EXziD%252Fsocialpreview%252Ft6eN9edJEnI3S1SjEkoi%252FBSPWM%2520FIXES.png%3Falt%3Dmedia%26token%3D9bb76ed0-7c66-46d0-a3f1-43a00046e43b&width=1200&height=630&sign=15a50fe&sv=2)](https://pylonet.gitbook.io/hack4u)
