#!/bin/bash

# \\ Creditos a Pylon por la recomendación

usuario=$USER 

if [[ $(id -u) -eq 0 ]]; then
	echo -e "\n[!] Ejecutarlo como usuario no privilegiado por favor!!"
	exit 1
fi

# Actualizamos el sistema
sudo apt-get update && command -v parrot-upgrade && parrot-upgrade || sudo apt upgrade -y

# Le otorgamos la zsh a ambos usuarios
sudo apt install zsh -y
sudo usermod --shell /usr/bin/zsh $usuario 2>/dev/null 2>&1
sudo usermod --shell /usr/bin/zsh root 2>/dev/null 2>&1
cp zshuser/.zshrc ~/.zshrc


# Instalamos algunos paquetes necesarios
sudo apt install kitty bspwm sxhkd polybar rofi xclip flameshot i3lock-fancy i3lock moreutils mesa-utils scrub coreutils -y 
sudo apt install obsidian -y 2>/dev/null || echo "[!] Problemas para instalar obsidian..."

# Cambiamos la estetica de la kitty
cp -r kitty ~/.config/

# Nos traemos la Powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k

cp p10kuser/.p10k.zsh /home/$usuario

# Instalamos lsd y bat
sudo apt install lsd -y 2>/dev/null || echo "[!] Hubo un problema al instalar lsd"
sudo dpkg -i lsdbat/*

# Instalamos las fuentes necesarias
sudo cp -r fonts /usr/local/share/fonts
mkdir -p /home/$usuario/.local/share/fonts
sudo cp -r fonts /home/$usuario/.local/share/fonts
fc-cache -v &>/dev/null || echo "[!] Error al limpiar la cache de fuente"

# Instalamos el compositor picom
sudo apt install meson libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-xinerama0-dev libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev libpcre2-dev libevdev-dev uthash-dev libev-dev libx11-xcb-dev libxcb-glx0-dev libev-dev -y
(sudo apt install picom -y) 2>/dev/null 
if [[ ! $? -eq 0 ]]; then
  [[ -d "picom" ]] && rm -rf picom
  git clone https://github.com/ibhagwan/picom.git
  cd picom
  git submodule update --init --recursive
  meson --buildtype=release . build
  ninja -C build
  sudo ninja -C build install
  cd ..
fi

# Instalamo nvim y nvchad, asi como los mensajes de advertencia
sudo cp -r nvim /opt
mkdir -p ~/.config/nvim
cp -r nvimconf/* ~/.config/nvim/
sudo apt install npm nodejs

# Instalamos fzf 
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# Instalamos el sudo zsh sudo
sudo mkdir -p /usr/share/zsh-sudo
sudo cp zsh-sudo/sudo.plugin.zsh /usr/share/zsh-sudo

# Creamos los archivos de configuración para bspwm y sxhkd, asi como picom
cp -r bspwm /home/$usuario/.config
cp -r sxhkd /home/$usuario/.config

# Archivos de configuración de picom
mkdir -p /home/$usuario/picom/
cp -r .picom/picom.conf /home/$usuario/.config/

# Archivos de configuración de la polybar
mkdir -p /home/$usuario/.config/polybar
cp -r Polybar/* /home/$usuario/.config/polybar

# Directorio de imágenes para las capturas de pantalla y fondos de pantalla
mkdir -p ~/Imágenes
cp AnimeGirl.jpg ~/Imágenes
mkdir -p ~/Imágenes/capturas

# Creamos directorios adicionales
mkdir -p ~/.config/bin/
touch ~/.config/bin/target

# Empezamos con la instalación para el usuario root

sed "s|~/.config/bin/target|/home/$usuario/.config/bin/target|" zshroot/.zshrc > root-zsh
sudo rm /root/.zshrc
sudo mv root-zsh /root
sudo mv /root/root-zsh /root/.zshrc

# Instalamos fzf para root 
sudo git clone --depth 1 https://github.com/junegunn/fzf.git /root/.fzf
sudo /root/.fzf/install

# Instalamos la powerlevel10k para el usuario root
sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /root/powerlevel10k
sudo cp p10kroot/.p10k.zsh /root/

# Instalamos neovim y nvchad para root
sudo mkdir -p /root/.config/nvim
sudo cp -r nvimconf/* /root/.config/nvim/

# Mandamos la estetica de la kitty del usuario no privilegiado, al usuario privilegiado
sudo cp -r kitty /root/.config/

# Instalamos eww y sus dependencias
sudo apt install git build-essential libgtk-3-dev libpango1.0-dev libglib2.0-dev libcairo2-dev -y
sudo apt install libdbusmenu-glib-dev -y
sudo apt install libgtk-layer-shell-dev -y
[[ -d "eww" ]] && rm -rf "eww"
git clone https://github.com/elkowar/eww.git
cd eww
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env
cargo clean
cargo build --release
sudo cp target/release/eww /usr/bin/
mkdir -p /home/$usuario/.config/eww
cp -r configeww/* /home/$usuario/.config/eww

# Movemos el script whichSystem.sh al path para que sea un comando ejecutable
sudo cp scripts/whichSystem.sh /usr/bin/

# Instalamos oh-my-tmux para ambos usuarios
cd /home/$usuario
git clone --single-branch https://github.com/gpakosz/.tmux.git
ln -s -f .tmux/.tmux.conf
cp .tmux/.tmux.conf.local .

# oh-my-tmux para root
sudo git clone --single-branch https://github.com/gpakosz/.tmux.git /root/.tmux
sudo ln -s -f /root/.tmux/.tmux.conf /root/.tmux.conf
sudo cp /root/.tmux/.tmux.conf.local /root/.

# Creditos a S4vitar 
