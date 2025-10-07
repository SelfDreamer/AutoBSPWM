# S4vimachines

#### ¿Qué es S4vimachines.sh?
Este es un cliente de terminal, que se encarga de extraer información acerca de las máquinas que va resolviendo [s4vitar](https://www.youtube.com/s4vitar). Este cliente de terminal, trata de tener la misma flexibilidad que se tiene al buscar en la misma página de [infosecmachines](https://infosecmachines.io). 
> [!IMPORTANT]
> Las máquinas y su información se extraen de [infosecmachines](https://infosecmachines.io/api/machines).

---
### Flexibilidad a la hora de buscar

Ejemplo desde terminal

```bash
s4vimachines.sh -A 'Insane OSCP Unicode SQLI HackTheBox Windows Kerberos OSWE'
```

![image](https://github.com/user-attachments/assets/15e5dd3e-3189-4d9f-9ad3-d5300f421f01)


Desde **infosecmachines**

![image](https://github.com/user-attachments/assets/babdc8b8-c82e-42f5-8b26-b3fe16d2b805)

Esta busqueda flexible no se limita a un solo parametro, los parametros `-c` *(certificate)* y `-s` *(skill)* también lo poseen.

---

#### ⚠️ Antes de instalar dependencias y demas importante que actualizes el sistema

> [!IMPORTANT]
> Este buscador de máquinas es unicamente compatible con sistemas **UNIX**, proximamente se hara una libreria en Python para interactuar con la API de `infosecmachines`, la cual si estara disponible en Linux, Windows y MacOS. 

---

<details>
  <summary><b>Actualización</b></summary>

  ### Debian
  
  ```bash
  sudo apt update && sudo apt upgrade -y # Para distribuciones basadas en debian
  sudo apt update && sudo parrot-upgrade -y # Para el delicado de Parrot
  ```
---

  ### Arch
  ```bash
  sudo pacman -Syu --noconfirm   # Usando pacman (gestor oficial)
  sudo paru -Syu --noconfirm     # Usando paru (AUR helper basado en pacman)
  sudo yay -Syu --noconfirm      # Usando yay (otro AUR helper basado en pacman)
  ```
---

</details>  

<details>
  <summary><b>Dependencias</b></summary>

  ### Debian
  
  ```bash
  sudo apt install coreutils util-linux npm nodejs bc moreutils translate-shell -y
  sudo apt install node-js-beautify -y 
  ```
---

  ### Arch
  
  ```bash
  sudo pacman -S coreutils npm nodejs bc moreutils translate-shell --noconfirm
  sudo npm install -g js-beautify 
  ```


```

---

</details>

### 🔍 Uso

```bash
s4vimachines.sh [PARAMETROS] [ARGUMENTOS]
```

### Opciones disponibles:


| Parámetro | Descripción                                                          | Ejemplo                                                      |
| --------: | -------------------------------------------------------------------- | ------------------------------------------------------------ |
|      `-h` | Mostrar el manual de ayuda.                                          | `s4vimachines.sh -h`                                         |
|      `-u` | Actualizar dependencias / obtener actualizaciones.                   | `s4vimachines.sh -u`                                         |
|      `-m` | Mostrar las propiedades de una máquina (por nombre).                 | `s4vimachines.sh -m 'Multimaster'`                           |
|      `-i` | Mostrar máquinas por dirección IP.                                   | `s4vimachines.sh -i '10.10.10.179'`                          |
|      `-d` | Filtrar por dificultad (difficulty).                                 | `s4vimachines.sh -d 'Insane'`                                |
|      `-o` | Filtrar por sistema operativo (os).                                  | `s4vimachines.sh -o 'Windows'`                               |
|      `-w` | Mostrar el enlace al writeup de una máquina.                         | `s4vimachines.sh -w 'Multimaster'`                           |
|      `-s` | Listar máquinas por skill (habilidad / técnica).                     | `s4vimachines.sh -s 'SQLI'`                                  |
|      `-p` | Listar máquinas de una plataforma dada (p.ej. HackTheBox).           | `s4vimachines.sh -p 'HackTheBox'`                            |
|      `-c` | Listar máquinas que tengan uno o más certificados.                   | `s4vimachines.sh -c 'OSCP OSWE OSEP'`                        |
|      `-A` | Búsqueda avanzada (varios términos combinados).                      | `s4vimachines.sh -A 'Unicode Sqli Insane windows oscp oswe'` |
|      `-a` | Listar todas las máquinas existentes (all).                          | `s4vimachines.sh -a`                                         |
|      `-r` | Modo aleatorio: el script elegirá una máquina al azar.               | `s4vimachines.sh -r`                                         |
|      `-v` | Activar modo verbose (más salida informativa).                       | `s4vimachines.sh -u -v`                                      |
|      `-y` | Confirmar automáticamente acciones que requieren confirmación (yes). | `s4vimachines.sh -u -y`<br>`s4vimachines.sh -A 'CSRF' -y`    |
|      `-t` | Traducir el output a un idioma específico (p. ej. `es`).             | `s4vimachines.sh -m 'Tentacle' -t 'es'`                      |
|      `-b` | Abrir el writeup en un navegador específico (por defecto `firefox`). | `s4vimachines.sh -w 'Tentacle' -b 'chrome'`                  |
|      `-x` | No mostrar el banner en el panel de ayuda (exclude banner).          | `s4vimachines.sh -x`                                         |
