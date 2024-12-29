### **¿Cómo usar?**

```bash
git clone https://github.com/FlickGMD/AutoBSPWM.git
cd AutoBSPWM
chmod +x Install.sh
./Install.sh
```

------------------------------------------------------------------------

Único paso manual:
- **Meterse a nvim `nvim`**
- **Presionar la tecla Esc**
- **Presionar `shift` + `.`, resultado `:`**
- **Luego `MasonInstallAll`**
- **Y finalmente le damos a enter y esperamos a que se instale lo que tenga que instalarse**
![[Pasted image 20241229042703.png]]
---


##### Mensajes de Adveretencia y ayuda por parte del editor

![[Pasted image 20241229042634.png]]

![[Pasted image 20241229042651.png]]

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
