#!/usr/bin/env bash
readonly ruta=$(realpath $0 | rev | cut -d'/' -f2- | rev)
readonly distro=$(lsb_release -d | grep -oP "Parrot|Kali")
readonly usuario="${USER}"
readonly LOGS="${HOME}/autobspwm.log"

spinner_log() {
  tput civis 
  local msg="${1:-This is a message!}"
  local delay="${2:-0.2}"
  local pid="${3}"
  local values=('|' '/' '-' '\')
  local points=('.' '..' '...' '') 
  local len="${#values[@]}"
  (( ${#points[@]} < len )) && len="${#points[@]}" 

  local i=0
  while true; do 
    local value="${values[i]}"
    local point="${points[i]}"
    echo -ne "\r\033[K${bright_green}[${value}]${end} $msg${point}"
    sleep "${delay}"
    ((i=(i+1)%len))
    kill -0 $pid 2>/dev/null || break
  done

  printf "\b \n"
}

welcome(){
  clear
  user="${1:-$USER}"
  printf "${bright_magenta}"
  printf """
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⢀⣤⡴⢲⣀⡀⢀⣀⣀⣤⣤⣤⣄⣀⠠⣞⢿⣀⣟⣿⣀⠀⠀⠀⠀
⠀⠀⠀⠀⢀⠼⠧⡷⢼⠥⠿⡉⠉⠀⠀⠀⠀⠀⠉⢹⣉⡹⡭⡯⢤⡜⠀⠀⠀⠀
⠀⠀⠀⢀⡠⢷⣊⡟⢺⠳⡖⠁⠀⠀⠀⠀⠀⠀⠀⠀⠺⠽⣇⣹⠒⠛⠦⣄⠀⠀
⠀⣠⠔⠋⠀⠈⢩⠧⠞⢉⣅⠀⠀⠀⠀⠀⠀⠀⠀⠀⣶⣦⠘⡘⡆⠀⠀⠀⠙⠢
⠞⠁⠀⠀⠀⠀⢸⠀⠀⢿⣿⠆⠀⠀⠀⠀⠀⣀⠀⠀⠻⠟⠀⠇⡇⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠘⣧⠀⠈⠁⠀⠀⠀⠹⣍⣹⠃⠀⠀⠀⠀⣔⣼⡁⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⢀⡼⠉⠛⠦⢤⣀⣀⣰⠒⢦⠴⢶⡋⠙⡴⠚⠉⠀⠙⢦⡀⠀⠀⠀
⠀⠀⠀⢀⣠⠞⠁⠀⠀⠀⠀⠀⣼⣽⠞⠻⠞⠉⢻⡍⠙⢦⡀⠀⠀⠀⠙⠲⢤⣤
⠶⠖⠚⠋⠀⠀⠀⠀⠀⠀⠀⣰⡟⡛⣄⠀⠀⢀⠼⠡⣠⠬⢿⠶⣄⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡼⢯⣀⣀⠀⠭⠱⠵⠀⠀⢇⡀⠀⠀⢈⢷⣄⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⣴⢏⠀⠀⠁⠈⡷⡿⠒⠲⡶⠒⢆⣭⣒⠖⠏⠁⢹⡆⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⢿⣬⠳⠤⡔⠊⢒⣻⣄⠀⠀⢀⣜⠂⠀⠀⣀⣶⠟⠁⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠓⠶⠶⠤⠤⣴⠾⠷⠶⠿⡷⠖⠛⠛⠉⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡏⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀  
  """
  printf "${end}"
  msg="""
  
${bright_green}[+]${end} ${bright_white}Este script no tiene el potencial de modificar tu sistema a bajo nivel y ni de romperlo.${end}
${bright_green}[+]${end} ${bright_white}Instalara un entorno bspwm minimalista utilizando eww, polybar y sxhkd para los atajos de teclado.${end}
${bright_green}[+]${end} ${bright_white}Estes en la ruta que estes, el script encargara de moverte a la ruta donde este el ejecutable.${end}
${bright_green}[+]${end} ${bright_white}Cambiara tu shell a una zsh e instalara kitty como terminal por defecto${end}
  """

  echo -e "${msg}"

  echo -en "\n${bright_green}[$user]${end} ${bright_white}Deseas continuar?${end} ${bright_magenta}[${bright_white}Y${bright_magenta}/${bright_white}n${bright_magenta}]${end} " && read -r confirm 
  
  if [[ ! "${confirm}" =~ ^[YySs] ]]; then 
    echo -e "\n${bright_red}[!] Operation canelled by ${usuario}${end}" >&2
    exit 1 
  fi 
}

show_timestamp() {
  local secs=$1
  local msg=$2

  if (( secs < 60 )); then
    echo -e "${bright_green}[+]${bright_white} ${msg} en ${bright_magenta}${secs}${bright_white} segundos.${end}"; echo 
  else
    local mins=$(awk -v s="$secs" 'BEGIN { printf "%.2f\n", s / 60 }')
    echo -e "${bright_green}[+]${end}${bright_white} ${msg}${bright_white} en aproximadamente${end}${bright_magenta} ${mins}${bright_white} minutos.${end}"; echo 
  fi
}

update_system(){
  cd "${ruta}" || exit 1 
  SECONDS=0
  (
  sudo dpkg --configure -a &>/dev/null
  sudo apt --fix-broken install -y &>/dev/null
  if [[ $distro == 'Parrot' ]]; then
    sudo apt update &>/dev/null 
    sudo parrot-upgrade -y &>/dev/null
    if [[ $? -ne 0  ]]; then
      wget https://deb.parrot.sh/parrot/pool/main/p/parrot-archive-keyring/parrot-archive-keyring_2024.12_all.deb &>/dev/null
      sudo dpkg -i parrot-archive-keyring_2024.12_all.deb || sudo dpkg -i *.deb &>/dev/null # .deb 
    fi
  elif [[ $distro == 'Kali' ]]; then
    if ! sudo apt update &>/dev/null; then
      sudo wget https://archive.kali.org/archive-keyring.gpg -O /usr/share/keyrings/kali-archive-keyring.gpg &>/dev/null
    fi
    sudo apt upgrade -y &>/dev/null
  fi
  ) & 

  PID=$!

  spinner_log "${bright_white}Actualizando sistema${bright_magenta} ${distro}${bright_white}, esto podria tomar un tiempo${end}" "0.2" "${PID}"
  
  wait "${PID}"

  show_timestamp "${SECONDS}" "Sistema ${distro} actualizado de forma exitosa"
}

function install_fetch(){
  [[ -d "fastfetch" ]] && rm -rf fastfetch
  cd "${ruta}" || return 1 
  sudo apt install git cmake build-essential -y &>/dev/null  
  git clone https://github.com/fastfetch-cli/fastfetch &>/dev/null 
  cd fastfetch || return 1
  cmake -B build -DCMAKE_BUILD_TYPE=Release &>/dev/null 
  cmake --build build --target fastfetch -j$(nproc) &>/dev/null
  sudo cp build/fastfetch /usr/local/bin/ &>/dev/null
  cd "${ruta}" || return 1 
  rm -rf fastfetch &>/dev/null

}

install_bspwm(){
  SECONDS=0
  (
  cd "${ruta}" || exit 1 
  declare -a programs=("bspwm" "feh" "imagemagick", "libroman-perl" "xxhash")
  rm -rf ~/.config/bspwm/ 2>"${LOGS}"
  cp -r ./config/bspwm/ ~/.config/  

  for program in "${programs[@]}"; do 
    sudo apt install "${program}" -y &>/dev/null 
  done 

  [[ ! -d "${HOME}/Imágenes/" ]] && mkdir -p ~/Imágenes
  cp -r ./wallpapers/ ~/Imágenes &>/dev/null
  [[ ! -d "${HOME}/Imágenes/capturas" ]] && mkdir -p ~/Imágenes/capturas
  
  # Buscador de máquinas 
  sudo apt install coreutils util-linux npm nodejs bc moreutils translate-shell -y &>/dev/null
  sudo apt install node-js-beautify -y &>/dev/null 
  sudo cp -r scripts/s4vimachines.sh/ /opt &>/dev/null
  sudo chown -R $usuario:$usuario /opt/s4vimachines.sh &>/dev/null
  sudo apt install wmname -y &>/dev/null
  cd "${ruta}" || return 1 
  cp ./Icons/Editor.desktop /tmp/ 
  sed -i "s|user_replace|${usuario}|" /tmp/Editor.desktop &>/dev/null
  sudo cp ./Icons/neovim.desktop /usr/share/applications/ &>/dev/null
  sudo cp /tmp/Editor.desktop /usr/share/applications/ &>/dev/null
  if ! sudo apt install fastfetch -y &>/dev/null; then 
    install_fetch &>/dev/null
  fi 
  ) & 

  PID=$!

  spinner_log "${bright_white}Instalando${bright_magenta} bspwm ${bright_white}, esto podria tomar un tiempo${end}" "0.2" "${PID}"
  
  wait "${PID}"

  show_timestamp "${SECONDS}" "Bspwm instalado de forma exitosa"


}

install_sxhkd(){
  SECONDS=0
  ( 
  cd "${ruta}"
  rm -rf ~/.config/sxhkd/ 2>"${LOGS}"
  cp -r ./config/sxhkd/ ~/.config/
  sudo apt install flameshot xclip moreutils mesa-utils scrub coreutils -y &>/dev/null
  sudo apt install libgif-dev -y &>/dev/null 
  sudo apt install \
  git build-essential autoconf automake libxcb-xkb-dev libpam0g-dev \
  libcairo2-dev libev-dev libx11-xcb-dev libxkbcommon-dev libxkbcommon-x11-dev \
  libxcb-util0-dev libxcb-randr0-dev libxcb-image0-dev libxcb-composite0-dev \
  libxcb-xinerama0-dev libjpeg-dev libx11-dev libgif-dev -y  &>/dev/null 
  sudo apt install maim -y &>/dev/null
  
  sudo apt install autoconf gcc make pkg-config libpam0g-dev libcairo2-dev libfontconfig1-dev libxcb-composite0-dev libev-dev libx11-xcb-dev libxcb-xkb-dev libxcb-xinerama0-dev libxcb-randr0-dev libxcb-image0-dev libxcb-util0-dev libxcb-xrm-dev libxkbcommon-dev libxkbcommon-x11-dev libjpeg-dev libgif-dev -y  &>/dev/null
  
  cd /tmp 
  git clone https://github.com/Raymo111/i3lock-color.git &>/dev/null
  cd i3lock-color
  ./install-i3lock-color.sh &>/dev/null 
  cd "${ruta}"  
  rm -rf /tmp/i3lock-color/  2>"${LOGS}"
  sudo cp ./scripts/ScreenLocker /usr/bin/
    
  [[ ! -d "${HOME}/.config/bin/" ]] && mkdir -p ~/.config/bin/
  [[ ! -f "${HOME}/.config/bin/target" ]]  && touch ~/.config/bin/target
  
  cd /tmp/ 
  readonly xqp_url="https://github.com/baskerville/xqp.git"

  git clone "${xqp_url}" &>/dev/null
  cd xqp  &>/dev/null
  make &>/dev/null 
  sudo mv xqp /usr/bin/ &>/dev/null 
  cd ..
  rm -rf xqp  2>"${LOGS}"
  cd "${ruta}"
  
  cp -r ./config/jgmenu/ ~/.config/  
  sudo apt install jgmenu -y &>/dev/null
# /home/kali/.local/share/icons/Qogir-Dark
  ICON_DIR="$HOME/.local/share/icons/"
  [[ ! -d "${ICON_DIR}" ]] && mkdir -p "${ICON_DIR}"
  cd /tmp/
  git clone https://github.com/vinceliuice/Qogir-icon-theme.git &>/dev/null 
  cd Qogir-icon-theme
  ./install.sh --theme &>/dev/null 
  [[ ! -d "${HOME}/.icons" ]] && mkdir -p ~/.icons &>/dev/null
  ./install.sh -c -d ~/.icons &>/dev/null
  cd "${ruta}" || return 1 
  cp ./home/.Xresources ~/.Xresources &>/dev/null

  cd "${ruta}"
  rm -rf /tmp/Qogir-icon-theme/ &>/dev/null 
  [[ ! -d  "${HOME}/.config/gtk-3.0" ]] && mkdir -p  ~/.config/gtk-3.0/ 
  cp ./config/gtk-3.0/settings.ini ~/.config/gtk-3.0/ &>/dev/null
  ) &

  PID=$!

  spinner_log "${bright_white}Instalando${bright_magenta} sxhkd${bright_white}, esto podria tomar un tiempo${end}" "0.2" "${PID}"
  
  wait "${PID}"

  show_timestamp "${SECONDS}" "Sxhkd instalado de forma correcta"

}

install_p10k(){
  SECONDS=0 
  (
  cd "${ruta}" || exit 1
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k &>/dev/null
  cp ./config/PowerLevel10k/.p10k.zsh /home/$usuario
  sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /root/powerlevel10k &>/dev/null
  sudo cp ./config/PowerLevel10k/.p10k.zsh /root/ 
  ) & 

  PID=$!
  spinner_log "${bright_white}Instalando la${bright_magenta} PowerLevel10k${bright_white}, esto podria tomar un tiempo${end}" "0.2" "${PID}"
  
  wait "${PID}"

  show_timestamp "${SECONDS}" "La PowerLevel10k se instalo de forma correcta"


}

install_kitty(){
  SECONDS=0 
  (
  cd "${ruta}" || exit 1 
  sudo apt install kitty -y &>/dev/null
  rm -rf ~/.config/kitty/ 2>"${LOGS}"
  sudo rm -rf /root/.config/kitty/ 2>"${LOGS}"

  cp -r ./config/kitty/ ~/.config/
  sudo cp -r ./config/kitty/ /root/.config/
  ) & 

  PID=$!
  spinner_log "${bright_white}Instalando${bright_magenta} Kitty${bright_white}, esto podria tomar un tiempo${end}" "0.2" "${PID}"
  
  wait "${PID}"

  show_timestamp "${SECONDS}" "La kitty se instalo de forma correcta"

}

install_zsh(){
  SECONDS=0
  (
  sudo apt install zsh zsh-syntax-highlighting zsh-autosuggestions -y &>/dev/null
  sudo usermod --shell /usr/bin/zsh $usuario &>/dev/null
  sudo usermod --shell /usr/bin/zsh root &>/dev/null 
  cp ./config/zsh/.zshrc ~/.zshrc 
  sed "s|~/.config/bin/target|/home/$usuario/.config/bin/target|" ./config/zsh/.zshrc > root-zsh
  sudo rm /root/.zshrc 2>/dev/null
  sudo mv root-zsh /root
  sudo mv /root/root-zsh /root/.zshrc
  sudo cp -r ./config/zsh-sudo /usr/share/
  ) & 

  PID=$!

  spinner_log "${bright_white}Instalando la${bright_magenta} zsh${bright_white}, esto podria tomar un tiempo${end}" "0.2" "${PID}"
  
  wait "${PID}"

  show_timestamp "${SECONDS}" "La zsh se instalo de forma correcta"

}

install_fzf(){
  SECONDS=0
  (
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf &>/dev/null 
  ~/.fzf/install --all &>/dev/null

  sudo git clone --depth 1 https://github.com/junegunn/fzf.git /root/.fzf &>/dev/null 
  sudo /root/.fzf/install --all &>/dev/null

  ) & 

  PID=$!

  spinner_log "${bright_white}Instalando ${bright_magenta}fzf${bright_white}, esto podria tomar un tiempo${end}" "0.2" "${PID}"

  wait "${PID}"
  
  show_timestamp "${SECONDS}" "Fzf se instalo de forma correcta"
} 

install_polybar(){
  SECONDS=0
  cd "${ruta}" || exit 1 

  (
  sudo apt install polybar -y &>/dev/null
  rm -rf ~/.config/polybar/ 2>"${LOGS}"
  cp -r ./config/polybar/ ~/.config/
  
  sudo apt install libnotify-bin -y &>/dev/null 
  sudo apt install dunst -y &>/dev/null

  cp -r ./config/dunst ~/.config/ &>/dev/null
  ) & 

  PID=$!

  spinner_log "${bright_white}Instalando${bright_magenta} Polybar${bright_white}, esto podria tomar un tiempo${end}" "0.2" "${PID}"

  wait "${PID}"
  
  show_timestamp "${SECONDS}" "La Polybar se instalo de forma correcta"

}

install_picom(){
  SECONDS=0
  cd "${ruta}" || exit 1 

  (
  sudo apt install meson libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-xinerama0-dev libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev libpcre2-dev libevdev-dev uthash-dev libev-dev libx11-xcb-dev libxcb-glx0-dev libev-dev libpcre3-dev -y &>/dev/null
  sudo apt install libconfig-dev libdbus-1-dev libegl-dev libev-dev libgl-dev libepoxy-dev libpcre2-dev libpixman-1-dev libx11-xcb-dev libxcb1-dev libxcb-composite0-dev libxcb-damage0-dev libxcb-glx0-dev libxcb-image0-dev libxcb-present-dev libxcb-randr0-dev libxcb-render0-dev libxcb-render-util0-dev libxcb-shape0-dev libxcb-util-dev libxcb-xfixes0-dev meson ninja-build uthash-dev -y &>/dev/null
  sudo apt install cmake -y &>/dev/null 

  [[ -d "picom" ]] && rm -rf picom
  if ! sudo apt install picom -y &>/dev/null; then
    # Instalamos picom desde los repositorios de git 
    git clone https://github.com/yshui/picom &>/dev/null 
    cd picom || return  
    meson setup --buildtype=release build &>/dev/null
    ninja -C build &>/dev/null
    sudo cp  build/src/picom /usr/local/bin  &>/dev/null
    sudo cp build/src/picom /usr/bin/ &>/dev/null
    cd ..
    rm -rf picom
  fi

  cp -r ./config/picom/ ~/.config/ 2>"${LOGS}"

  ) &

  PID=$!

  spinner_log "${bright_white}Instalando${bright_magenta} Picom${bright_white}, esto podria tomar un tiempo${end}" "0.2" "${PID}"

  wait "${PID}"
  
  show_timestamp "${SECONDS}" "Picom se instalo de forma correcta"

}

install_bat_and_lsd(){
  SECONDS=0
  (
  cd "${ruta}" || exit 1 
  bat_url=$(curl -s https://api.github.com/repos/sharkdp/bat/releases/latest | jq -r '.assets[] | select(.name | endswith("x86_64-unknown-linux-gnu.tar.gz")) | .browser_download_url')
  wget "$bat_url" -O bat.tar.gz &>/dev/null
  tar -xzf bat.tar.gz &>/dev/null 
  sudo mv bat-*/bat /usr/bin/ &>/dev/null
  rm -rf bat-* &>/dev/null
  rm -rf bat.tar.gz &>/dev/null
  
  # Instalación de lsd
  lsd_url=$(curl -s https://api.github.com/repos/lsd-rs/lsd/releases/latest | jq -r '.assets[] | select(.name | endswith("x86_64-unknown-linux-gnu.tar.gz")) | .browser_download_url')
  wget "$lsd_url" -O lsd.tar.gz &>/dev/null
  tar -xzf lsd.tar.gz &>/dev/null
  sudo mv lsd-*/lsd /usr/bin/  &>/dev/null
  rm -rf lsd.tar.gz  &>/dev/null
  rm -rf lsd-* &>/dev/null

  ) &

  PID=$!

  spinner_log "${bright_white}Instalando${bright_magenta} bat/lsd${bright_white}, esto podria tomar un tiempo${end}" "0.2" "${PID}"

  wait "${PID}"
  
  show_timestamp "${SECONDS}" "Bat y lsd se instalaron de forma correcta"

}

install_fonts(){
  SECONDS=0
  cd "${ruta}" || exit 1 
  [[ ! -d "${HOME}/.local/share/fonts/" ]] && mkdir -p ~/.local/share/fonts &>/dev/null
  (
  sudo cp -r fonts/* /usr/local/share/fonts &>/dev/null
  sudo cp -r fonts/* ~/.local/share/fonts &>/dev/null 
  sudo cp -r fonts/* /usr/share/fonts/truetype/ &>/dev/null 
  sudo cp ./config/polybar/fonts/* /usr/share/fonts/truetype &>/dev/null 
  sudo apt install -y papirus-icon-theme &>/dev/null
  fc-cache -vf &>/dev/null 
  ) & 

  PID=$! 

  spinner_log "${bright_white}Instalando las fuentes necesarias${end}" "0.2" "${PID}"
  
  wait "${PID}"

  show_timestamp "${SECONDS}" "${bright_white}Las fuentes se instalaron de forma correcta"

}

install_nvim(){
  SECONDS=0
  cd "${ruta}" || exit 1
  (
  sudo apt autoremove neovim -y &>/dev/null
  sudo apt autoremove nvim -y &>/dev/null
  rm -rf ~/.config/nvim/ &>/dev/null
  sudo mkdir -p /root/.config/ &>/dev/null 
  sudo cp -r ./config/nvim/ /root/.config/ &>/dev/null

  rm -rf ~/.config/nvim/ &>/dev/null
  rm -rf ~/.local/share/nvim/ &>/dev/null
  sudo rm -rf /root/.config/nvim/ &>/dev/null 
  sudo rm -rf /root/.local/share/nvim/ &>/dev/null 

  cp -r ./config/nvim/ ~/.config/ &>/dev/null 
  sudo cp -r ./config/nvim/ /root/.config/
  sudo apt install jq npm nodejs -y &>/dev/null
  sudo apt install shellcheck -y &>/dev/null 
  sudo ./nvim_upload.sh &>/dev/null 
  ./InstallUserServersNvim.sh &>/dev/null 
  sudo ./InstallUserServersNvim.sh &>/dev/null 
  sudo cp ./nvim_upload.sh /usr/bin/ &>/dev/null 
  ) & 

  PID="$!"

  spinner_log "${bright_white}Instalando Nvim${end}" "0.2" "${PID}"
  
  wait "${PID}"

  show_timestamp "${SECONDS}" "${bright_white}Nvim y NvChad fueron instalados de forma correcta"

}

install_eww_for_docker(){
    cd "$ruta" || exit 1
    echo -e "\n${bright_cyan}[+]${bright_white} Empezando con el Dockerfile${end}"
    
    cd ./eww_container/ 

    xhost +local:root >/dev/null 2>&1

    # Construcción de la imagen
    echo -e "${bright_yellow}[*]${bright_white} Construyendo imagen Docker...${end}"
    sudo docker build -t eww_img . || { echo "Error en docker build"; exit 1; }

    # Ejecución del contenedor
    echo -e "${bright_yellow}[*]${bright_white} Iniciando contenedor...${end}"
    sudo docker run -dit \
      --name eww_widget \
      -e DISPLAY=$DISPLAY \
      -v /tmp/.X11-unix:/tmp/.X11-unix \
      -v ~/.config/eww:/root/.config/eww \
      -v /etc/localtime:/etc/localtime:ro \
      --device /dev/dri \
      eww_img

    # Configuración de sudoers
    echo -e "${bright_yellow}[*]${bright_white} Configurando sudoers...${end}"
    sudo tee /etc/sudoers.d/init_docker <<<'%sudo ALL=(root) NOPASSWD: /usr/bin/init_docker.sh' >/dev/null
    sudo chmod 440 /etc/sudoers.d/init_docker

    sudo tee /etc/sudoers.d/eww <<<'%sudo ALL=(root) NOPASSWD: /usr/bin/eww_calendar.sh' >/dev/null
    sudo chmod 440 /etc/sudoers.d/eww

    sudo tee /etc/sudoers.d/init_eww <<<'%sudo ALL=(root) NOPASSWD: /usr/bin/init_eww.sh' >/dev/null
    sudo chmod 440 /etc/sudoers.d/init_eww
   
    # Copia de scripts
    echo -e "${bright_yellow}[*]${bright_white} Instalando scripts...${end}"
    sudo cp -v ./init_docker.sh ./init_eww.sh ./eww_calendar.sh /usr/bin/
    sudo chmod 755 /usr/bin/{init_docker.sh,init_eww.sh,eww_calendar.sh}
    sudo chown root:root /usr/bin/{init_docker.sh,init_eww.sh,eww_calendar.sh}

    # Borramos imagenes de tipo none 
    sudo docker rmi $(docker images -f "dangling=true" -q) --force 2>/dev/null 

    echo -e "${bright_green}[✓]${bright_white} Instalación completada${end}"
    cd .. 
}

install_eww(){
  SECONDS=0
  cd $ruta
  if [[ $distro == 'Kali' ]]; then 
    (
      # Instalamos eww y sus dependencias
      sudo apt install -y \
          git build-essential pkg-config \
          libgtk-3-dev libpango1.0-dev libglib2.0-dev libcairo2-dev \
          libdbusmenu-glib-dev libdbusmenu-gtk3-dev \
          libgtk-layer-shell-dev \
          libx11-dev libxft-dev libxrandr-dev libxtst-dev &>/dev/null

      # Si hay un directorio eww lo borramos entero
      [[ -d "eww" ]] && rm -rf "eww"

      git clone https://github.com/elkowar/eww.git &>/dev/null
      cd eww
      
      curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y &>/dev/null
      source ${HOME}/.cargo/env &>/dev/null
      cargo clean &>/dev/null
      cargo build --release &>/dev/null

      if [[ $? -eq 0 ]]; then
          sudo cp target/release/eww /usr/bin/
          mkdir -p ~/.config/eww
          cd ..
          [[ -d "eww" ]] && rm -rf eww
          # Traemos la configuración de eww
          cp -r ./config/eww/ ~/.config/
      fi
    ) &
  
    PID=$! 

    spinner_log "${bright_white}Instalando eww${end}" "0.2" "${PID}"
  
    wait "${PID}"

    show_timestamp "${SECONDS}" "${bright_white}Eww se instalo de forma correcta"
  fi 

  
  if [[ ${distro} == 'Parrot' ]]; then 
    echo -e "${bright_cyan}[!]${bright_white} Esta instalación puede tomar un tiempo, asi que se paciente...${end}"
    sudo apt install -y docker.io &>/dev/null
    install_eww_for_docker
  fi

}

install_tmux(){
  SECONDS=0
  # Instalamos oh-my-tmux para ambos usuarios
  (
  cd /home/$usuario
  git clone --single-branch https://github.com/gpakosz/.tmux.git &>/dev/null
  ln -s -f .tmux/.tmux.conf &>/dev/null
  cp .tmux/.tmux.conf.local . 

  # oh-my-tmux para root
  sudo git clone --single-branch https://github.com/gpakosz/.tmux.git /root/.tmux &>/dev/null
  sudo ln -s -f /root/.tmux/.tmux.conf /root/.tmux.conf &>/dev/null
  sudo cp /root/.tmux/.tmux.conf.local /root/. 
  ) &

  PID=$! 

  spinner_log "${bright_white}Instalando tmux${end}" "0.2" "${PID}"
  
  wait "${PID}"

  show_timestamp "${SECONDS}" "${bright_white}Tmux se instalo de forma correcta"

}

install_rofi(){
  SECONDS=0
  (
  sudo apt install -y rofi &>/dev/null
  cp -r ./config/rofi/ ~/.config/
  sleep 10 
  ) &

  PID=$! 

  spinner_log "${bright_white}Instalando rofi${end}" "0.2" "${PID}"
  
  wait "${PID}"

  show_timestamp "${SECONDS}" "${bright_white}Rofi se instalo de forma correcta"

  cd "${ruta}" || return 
  ./font.sh
  cp ./wallpapers/Wallpaper.jpg ~/Imágenes/wallpapers/

  echo -ne "${bright_yellow}[+]${bright_white} La instalación del entorno ha finalizado, deseas reiniciar?${end}${bright_magneta} (Y/n)${end} " && read -r confirm 

  if [[ "${confirm}" =~ ^[YySs] ]]; then 
    sudo systemctl reboot
  fi

}

install_obsidian(){
  SECONDS=0 
  (
  obsidian_url=$(curl -s https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest | jq -r '.assets[] | select(.name | endswith(".AppImage")) | .browser_download_url' | grep -vi 'arm' )
  wget "$obsidian_url" -O Obsidian.AppImage &>/dev/null
  chmod +x Obsidian.AppImage 
  mv Obsidian.AppImage obsidian 
  sudo mv obsidian /usr/bin/
  ) & 

  PID=$! 

  spinner_log "${bright_white}Instalando obsidian${end}" "0.2" "${PID}"
  
  wait "${PID}"

  show_timestamp "${SECONDS}" "${bright_white}Obsidian se instalo de forma correcta"

}


install_editor(){
  SECONDS=0
  cd "${ruta}" || exit 1
  ( 
  cp -r ./config/ctk/ ~/.config/ &>/dev/null
  cd ~/.config/ctk/  || return 1 
  sudo apt install python3-tk -y &>/dev/null
  python3 -m venv .venv &>/dev/null 
  source .venv/bin/activate &>/dev/null 
  pip install customtkinter CTkMessageBox pillow opencv-python CTkColorPicker CTkFileDialog tkfontchooser &>/dev/null
  cd $ruta || return 1 

  sudo cp ./config/ctk/AnimatedWall /usr/bin/ 
  sudo cp ./config/ctk/kitter /usr/bin/ 

  sudo apt install -y git g++ libx11-dev libxext-dev libxrender-dev libxcomposite-dev libxdamage-dev
  cd ~
  [[ -d "xwinwrap" ]] && rm -rf xwinwrap

  git clone https://github.com/ujjwal96/xwinwrap.git &>/dev/null
  cd xwinwrap
  make &>/dev/null
  sudo make install &>/dev/null 
  sudo apt install mpv -y &>/dev/null
  cd .. 
  rm -rf xwinwrap &>/dev/null
  cd "${ruta}"

  ) & 

  PID=$! 

  spinner_log "${bright_white}Instalando el editor de bspwm, esto podria tomar un tiempo${end}" "0.2" "${PID}"
  
  wait "${PID}"

  show_timestamp "${SECONDS}" "${bright_white}El editor de bspwm se instalo de forma exitosa"

}

main(){
  cd "${ruta}" || exit 1
  source ./Colors
  [[ -z $distro ]] && exit 1
  [[ ! -d "$HOME/.config/" ]] && mkdir -p ~/.config/
  welcome 
  export SUDO_PROMPT="$(tput setaf 3)[${USER}]$(tput setaf 15) Enter your password for root: $(tput sgr0)"
  sudo -v
  ( while true; do sudo -n true >/dev/null 2>&1; sleep 60; done ) &
  KEEP_ALIVE_PID=$!
  trap 'kill "$KEEP_ALIVE_PID"' EXIT
  tput civis
  update_system 
  install_fonts  
  install_nvim  
  install_bspwm
  install_sxhkd
  install_kitty 
  install_zsh
  install_fzf
  install_bat_and_lsd
  install_p10k
  install_picom
  install_obsidian
  install_tmux 
  install_eww
  install_polybar
  sudo cp ./Colors /usr/bin/
  install_editor
  install_rofi
}

if [[ "$EUID" -eq 0 ]]; then 
  cd "${ruta}" || exit 1 
  source ./Colors
  echo -e "\n${bright_red}[!] Este script no puede ser ejecutado como usuario root!${end}"
  exit 1 
fi

main
