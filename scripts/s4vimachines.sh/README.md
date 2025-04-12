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

---

</details>


### 🔍 Uso

```bash
s4vimachines.sh [PARAMETROS] [ARGUMENTOS]
```

### Opciones disponibles:

```
-h(help): Mostrar el manual de ayuda.

Actualizaciones y dependencias
-u(update): Actualizar dependencias

-m(machine): Mostrar las propiedades de una máquina.
[Ejemplo] s4vimachines.sh -m 'Multimaster'

-i(ip_addr): Mostrar máquinas por la dirección IP.
[Ejemplo] s4vimachines.sh -i '10.10.10.179'

-d(difficulty): Mostrar máquinas por una dificultad dada.
[Ejemplo] s4vimachines.sh -d 'Insane'

-o(osSystem): Mostrar máquinas por un sistema operativo dado.
[Ejemplo] s4vimachines.sh -o 'Windows'

-w(writeup): Mostrar el enlace a la resolución de una máquina
[Ejemplo] s4vimachines.sh -w 'Multimaster'

-s(skill): Listar máquinas por skill
[Ejemplo] s4vimachines.sh -s 'SQLI'

-p(platform): Listar todas las máquinas de una plataforma
[Ejemplo] s4vimachines.sh -p 'HackTheBox'

-c(certificate): Listar todas las máquinas que dispongan de uno o mas certificados
[Ejemplo] s4vimachines.sh -c 'OSCP OSWE OSEP'

-A(Advanced Search): Realizar una busqueda avanzada.
[Ejemplo] s4vimachines.sh -A 'Unicode Sqli Insane windows oscp oswe'

-a(all): Listar todas las máquinas existentes.
[Ejemplo] s4vimachines.sh -a 
```



### Extras
```
-r(random): Modo de elección aleatorio. El script elegira una máquina al azar por ti.
[Ejemplo] s4vimachines.sh -r

-v(verbose): Activar el modo verbose
[Ejemplo] s4vimachines.sh -u -v

-y(yes): Confirmar cada acción que dependa de una confirmación de usuario (sirve también para iterar por cada máquina)
[Ejemplo] s4vimachines.sh -u -y | s4vimachines.sh -A 'CSRF' -y

-t(translate): Traducir el output a un idioma especifico.
[Ejemplo] s4vimachines.sh -m 'Tentacle' -t 'es'

-b(browser): Abrir el writeup de una máquina, en un navegador especifico.
[Ejemplo] s4vimachines.sh -w 'Tentacle' -b '' (Navegador por default: firefox)

-x(exclude banner): No mostrar el banner en el panel de ayida.
[Ejemplo] s4vimachines.sh -x 
```
