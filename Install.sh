#!/bin/bash

# \\ Creditos a Pylon por la recomendación

usuario=$USER 
ruta=$(realpath $0)
# Si eres root sales del programa
if [[ $(id -u) -eq 0 ]]; then
	echo -e "\n[!] No ejecutes el script como usuario privilegiado!"
	exit 1
fi

# Si no tienes internet sales del programa
ping -c 1 google.es &>/dev/null || exit 1

# Actualizamos el sistema 
if command -v parrot-upgrade &>/dev/null; then
	if ! sudo apt update &>/dev/null; then 
    wget https://deb.parrot.sh/parrot/pool/main/p/parrot-archive-keyring/parrot-archive-keyring_2024.12_all.deb 
    sudo dpkg -i parrot-archive-keyring_2024.12_all.deb || sudo dpkg -i *.deb # .deb 
    rm *.deb
    sudo parrot-upgrade -y
  else
    sudo parrot-upgrade -y 
  fi
else
	sudo apt update && sudo apt upgrade -y 
fi

# Le otorgamos la zsh a ambos usuarios y sus plugins
sudo apt install zsh -y
sudo usermod --shell /usr/bin/zsh $usuario 2>/dev/null 2>&1
sudo usermod --shell /usr/bin/zsh root 2>/dev/null 2>&1
cp zshuser/.zshrc ~/.zshrc
sudo apt install zsh-syntax-highlighting zsh-autosuggestions


# Instalamos algunos paquetes necesarios
sudo apt install kitty bspwm sxhkd polybar rofi xclip flameshot i3lock-fancy i3lock moreutils mesa-utils scrub coreutils feh cmake -y 
if ! sudo apt install obsidian -y &>/dev/null; then
  sudo dpkg -i obsidian.test/*
fi

# Cambiamos la estetica de la kitty
cp -r kitty ~/.config/

# Nos traemos la Powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k

cp p10kuser/.p10k.zsh /home/$usuario

# Instalamos lsd y bat
sudo apt install lsd -y 2>/dev/null || echo "[!] Hubo un problema al instalar lsd"
sudo dpkg -i lsdbat/*

# Instalamos las fuentes necesarias
sudo cp -r fonts/* /usr/local/share/fonts
mkdir -p ~/.local/share/fonts
sudo cp -r fonts/* ~/.local/share/fonts
sudo cp -r fonts/* /usr/share/fonts/truetype/
sudo cp Polybar/fonts/* /usr/share/fonts/truetype/
fc-cache -v &>/dev/null || echo "[!] Error al limpiar la cache de fuente"

# Instalamos el compositor picom
sudo apt install meson libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-xinerama0-dev libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev libpcre2-dev libevdev-dev uthash-dev libev-dev libx11-xcb-dev libxcb-glx0-dev libev-dev libpcre3-dev -y

[[ -d "picom" ]] && rm -rf picom
if ! sudo apt install picom -y &>/dev/null; then
  # Instalamos picom desde los repositorios de git 
  git clone https://github.com/ibhagwan/picom.git
  cd picom
  git submodule update --init --recursive
  meson setup --buildtype=release . build
  ninja -C build
  sudo ninja -C build install
  cd ..
  rm -rf picom
fi

# Borramos un archivo de configuración antiguo de nvim, si es que existe
if [[ -f "~/.config/nvim/init.vim" ]]; then
  sudo rm ~/.config/nvim/init.vim
fi

# Borramos neovim old
test -x /usr/bin/nvim && sudo apt remove neovim || sudo apt remove nvim 

sudo cp -r nvim /opt
mkdir -p ~/.config/nvim
cp -r nvimconf/* ~/.config/nvim/
sudo apt install npm nodejs

# Instalamos fzf 
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all

# Instalamos el sudo zsh sudo
sudo mkdir -p /usr/share/zsh-sudo
sudo cp zsh-sudo/sudo.plugin.zsh /usr/share/zsh-sudo

# Creamos los archivos de configuración para bspwm y sxhkd, asi como picom
cp -r bspwm /home/$usuario/.config
cp -r sxhkd /home/$usuario/.config

# Archivos de configuración de picom
mkdir -p ~/.config/picom
cp .picom/picom.conf ~/.config/picom/picom.conf

# Archivos de configuración de la polybar
mkdir -p /home/$usuario/.config/polybar
cp -r Polybar/* /home/$usuario/.config/polybar

# Directorio de imágenes para las capturas de pantalla y fondos de pantalla
mkdir -p ~/Imágenes
cp wallpapers/*.jpg ~/Imágenes
mkdir -p ~/Imágenes/capturas

# Creamos directorios adicionales
mkdir -p ~/.config/bin/
touch ~/.config/bin/target

# Empezamos con la instalación para el usuario root

sed "s|~/.config/bin/target|/home/$usuario/.config/bin/target|" zshroot/.zshrc > root-zsh
sudo rm /root/.zshrc 2>/dev/null
sudo mv root-zsh /root
sudo mv /root/root-zsh /root/.zshrc

# Instalamos fzf para root 
sudo git clone --depth 1 https://github.com/junegunn/fzf.git /root/.fzf
sudo /root/.fzf/install --all

# Instalamos la powerlevel10k para el usuario root
sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /root/powerlevel10k
sudo cp p10kroot/.p10k.zsh /root/

# Instalamos neovim y nvchad para root
sudo mkdir -p /root/.config/nvim
sudo cp -r nvimconf/* /root/.config/nvim/

# Mandamos la estetica de la kitty del usuario no privilegiado, al usuario privilegiado
sudo cp -r kitty /root/.config/

# Instalamos eww y sus dependencias
sudo apt install -y \
    git build-essential pkg-config \
    libgtk-3-dev libpango1.0-dev libglib2.0-dev libcairo2-dev \
    libdbusmenu-glib-dev libdbusmenu-gtk3-dev \
    libgtk-layer-shell-dev \
    libx11-dev libxft-dev libxrandr-dev libxtst-dev
# Si hay un directorio eww lo borramos entero
[[ -d "eww" ]] && rm -rf "eww"
git clone https://github.com/elkowar/eww.git
cd eww
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env
cargo clean
cargo build --release
if [[ $? -eq 0 ]]; then

  sudo cp target/release/eww /usr/bin/
  mkdir -p ~/.config/eww
  cd ..
  # Traemos la configuración de eww
  cp -r configeww/* ~/.config/eww
else
  echo -e "\n[!] No se pudo instlar eww..."
  cd ..
fi

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

# Habilitamos mensajes de advertencia de nvchad
cd $ruta
./InstallUserServersNvim.sh &>/dev/null & disown
sudo ./InstallUserServersNvim.sh &>/dev/null & disown
./nvim_upload.sh 
sudo cp nvim_upload.sh /usr/bin/

echo -e "\n[+] Instalación casi finalizada, espera 30 segundos por favor..."
sleep 30
reboot
# Creditos a S4vitar 
