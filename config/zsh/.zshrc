# Fix the Java Problem
export _JAVA_AWT_WM_NONREPARENTING=1

# Enable Powerlevel10k instant prompt. Should stay at the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Set up the prompt
autoload -Uz promptinit
promptinit
setopt histignorealldups sharehistory
# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# Manual configuration

PATH=/root/.local/bin:/snap/bin:/usr/sandbox/:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/usr/share/games:/usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/opt/s4vimachines.sh/:/opt/nvim/bin/:/opt/kitty/bin/ 

# Manual aliases
alias ll='lsd -lh --group-dirs=first'
alias la='lsd -a --group-dirs=first'
alias l='lsd --group-dirs=first'
alias lla='lsd -lha --group-dirs=first'
alias ls='lsd --group-dirs=first'
alias cat='bat'
alias catn='bat --style=plain'
alias catnp='bat --style=plain --paging=never'
alias grep='grep --color=auto'
alias clt='cleartarget'
alias str='settarget'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Plugins
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh-sudo/sudo.plugin.zsh

# Functions
mkt () {
	source Colors
	dir_name="$1" 
	if [[ ! -n "$dir_name" ]]
	then
		echo -e "\n${bg_bright_red}[ERROR]${end} ${bright_white}Se debe indicar un nombre de directorio: (Ex:${end} ${bright_yellow}$0${end} ${bright_white}<Dir_Name>)${end}\n\n"
		return 1
	fi
	if [[ -d "$dir_name" ]]
	then
		echo -e "\n${bg_bright_red}[ERROR]${end}${bright_white} Error fatal: El directorio $dir_name ya existe!!\n"
		return 1
	fi
	echo
	echo -e "${bright_green}[✔]${bright_white} Directorio ${bright_blue}'$1'${bright_white} creado con subdirectorios:"
	echo -e "    ${sky} nmap${end}"
	echo -e "    ${sky} content${end}"
	echo -e "    ${sky} exploits${end}"
	echo -e "    ${sky} scripts${end}"
	echo
	mkdir -p $dir_name/{nmap,content,scripts,exploits}
}


# Extract nmap information
function extractPorts(){
	ports="$(cat $1 | grep -oP '\d{1,5}/open' | awk '{print $1}' FS='/' | xargs | tr ' ' ',')"
	ip_address="$(cat $1 | grep -oP '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}' | sort -u | head -n 1)"
	echo -e "\n[*] Extracting information...\n" > extractPorts.tmp
	echo -e "\t[*] IP Address: $ip_address"  >> extractPorts.tmp
	echo -e "\t[*] Open ports: $ports\n"  >> extractPorts.tmp
	echo $ports | tr -d '\n' | xclip -sel clip
	echo -e "[*] Ports copied to clipboard\n"  >> extractPorts.tmp
	cat extractPorts.tmp; rm extractPorts.tmp
}

# Set 'man' colors
function man() {
    env \
    LESS_TERMCAP_mb=$'\e[01;31m' \
    LESS_TERMCAP_md=$'\e[01;31m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[01;44;33m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[01;32m' \
    man "$@"
}

function settarget(){
  ip=$1
  machine=$2
  echo "$ip $2" > ~/.config/bin/target
}

function cleartarget(){
  echo '' > ~/.config/bin/target
}

function whichSystem () {
    bright_yellow="\u001b[0;93m"    bright_magenta="\u001b[0;95m"    bright_white="\u001b[0;97m"    end="\u001b[0m"

    ip_adress="$1"
    IFACE="$(ip addr show | awk '/inet .* brd/ {print $NF; exit}')"
    _ADRESS="$(ip addr show "eth0" | awk '/inet / {print $2; exit}' | cut -d/ -f1)"

    if [[ -z "$ip_adress" ]]; then
        echo -e "\n${bright_magenta}[+]${bright_white} Usage:${bright_yellow} whichSystem${bright_white} ${_ADRESS:-127.0.0.1}${end}\n\n"
        return 0
    fi

    ttl=$(/usr/bin/ping -c 1 "$ip_adress" | grep -oP "ttl=\K\d{1,3}")

    if [[ "$ttl" -ge 1 && "$ttl" -le 64 ]]; then
        system="Linux"
    elif [[ "$ttl" -ge 64 && "$ttl" -le 128 ]]; then
        system="Windows"
    else
        system="Not found"
    fi

    echo -e "\n${bright_yellow}[+]${bright_white} $ip_adress${bright_white} (${bright_magenta}$ttl${bright_white} ->${bright_yellow} $system${bright_white})${end}\n"
}


# fzf improvement
function fzf-lovely(){

	if [ "$1" = "h" ]; then
		fzf -m --reverse --preview-window down:20 --preview '[[ $(file --mime {}) =~ binary ]] &&
 	               echo {} is a binary file ||
	                (bat --style=numbers --color=always {} ||
	                 highlight -O ansi -l {} ||
	                 coderay {} ||
	                 rougify {} ||
	                 cat {}) 2> /dev/null | head -500'

	else
	       fzf -m --preview '[[ $(file --mime {}) =~ binary ]] &&
	                        echo {} is a binary file ||
	                        (bat --style=numbers --color=always {} ||
	                         highlight -O ansi -l {} ||
	                         coderay {} ||
	                         rougify {} ||
	                         cat {}) 2> /dev/null | head -500'
	fi
}

alias fzf-lovely='FZF_DEFAULT_OPTS="--height=40% --layout=reverse --border" fzf-lovely'

function rmk(){
	scrub -p dod $1
	shred -zun 10 -v $1
}

# Finalize Powerlevel10k instant prompt. Should stay at the bottom of ~/.zshrc.
(( ! ${+functions[p10k-instant-prompt-finalize]} )) || p10k-instant-prompt-finalize
source ~/powerlevel10k/powerlevel10k.zsh-theme

export SUDO_PROMPT="$(tput setaf 3)[${USER}]$(tput setaf 15) Enter your password for root: $(tput sgr0)"
export LS_COLORS="rs=0:di=34:ln=36:mh=00:pi=40;33:so=35:do=35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;4
3:ca=00:tw=30;42:ow=34;42:st=37;44:ex=32:*.tar=31:*.tgz=31:*.arc=31:*.arj=31:*.taz=31:*.lha=31:*.lz4=31:*.lzh=31:*.lzma=
31:*.tlz=31:*.txz=31:*.tzo=31:*.t7z=31:*.zip=31:*.z=31:*.dz=31:*.gz=31:*.lrz=31:*.lz=31:*.lzo=31:*.xz=31:*.zst=31:*.tzst
=31:*.bz2=31:*.bz=31:*.tbz=31:*.tbz2=31:*.tz=31:*.deb=31:*.rpm=31:*.jar=31:*.war=31:*.ear=31:*.sar=31:*.rar=31:*.alz=31:*.ace=31:*.zoo=31:*.cpio=31:*.7z=31:*.rz=31:*.cab=31:*.wim=31:*.swm=31:*.dwm=31:*.esd=31:*.avif=35:*.jpg=35:*.jpeg=35:*.mjpg=35:*.mjpeg=35:*.gif=35:*.bmp=35:*.pbm=35:*.pgm=35:*.ppm=35:*.tga=35:*.xbm=35:*.xpm=35:*.tif=35:*.tiff=35:*.png=35:*.svg=35:*.svgz=35:*.mng=35:*.pcx=35:*.mov=35:*.mpg=35:*.mpeg=35:*.m2v=35:*.mkv=35:*.webm=35:*.webp=35:*.ogm=35:*.mp4=35:*.m4v=35:*.mp4v=35:*.vob=35:*.qt=35:*.nuv=35:*.wmv=35:*.asf=35:*.rm=35:*.rmvb=35:*.flc=35:*.avi=35:*.fli=35:*.flv=35:*.gl=35:*.dl=35:*.xcf=35:*.xwd=35:*.yuv=35:*.cgm=35:*.emf=35:*.ogv=35:*.ogx=35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:*~=00;90:*#=00;90:*.bak=00;90:*.old=00;90:*.orig=00;90:*.part=00;90:*.rej=00;90:*.swp=00;90:*.tmp=00;90:*.dpkg-dist=00;90:*.dpkg-old=00;90:*.ucf-dist=00;90:*.ucf-new=00;90:*.ucf-old=00;90:*.rpmnew=00;90:*.rpmorig=00;90:*.rpmsave=00;90::ow=30;44:"
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line
bindkey "\e[3~" delete-char
setxkbmap latam
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
export EDITOR='nvim'
# Esto lo que hace es que nunca creara directorios __pycache__ al hacer scripts de python que sabemos que es molesto.
# Si realmente quieres esos directorios, comenta esa linea y ya 
export PYTHONDONTWRITEBYTECODE=1
