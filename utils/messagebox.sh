#!/usr/bin/env bash

# Messagebox - Utilidad para mostrar mensajes en bash 
# ---
# Parametros:
# - title: **Indica el titulo de la caja**
# - message: **Indica el mensaje** 
# - type: **Indica el tipo de mensaje**
#   - Info 
#   - Warning
#   - Hint 
#   - Error 
# - to end tty: **Parametro para indicarle que la caja ira hasta el final de la tty**
# - no prefix: **Parametro para indicar que no queremos un prefijo en el titulo del mensaje** 
# > El prefijo va a variar dependiendo de el tipo de mensaje. 
# ---
# > [!INFO] Importante
# > Este script usa actualmente la fuente de **HackNerdFont**, si no cuentas con esta fuente en tu terminal, veras menos estética.

ansi_aware_wrap() {
    local text="$1"
    local width="$2"

    echo -e "$text" | awk -v width="$width" '
    function visible_length(str,   stripped) {
        stripped = str
        
        gsub(/\033\[[0-9;]*[a-zA-Z]/, "", stripped)
        
        gsub(/\033][^\033]*\033\\/, "", stripped)
        
        return length(stripped)
    }

    {
        line = $0
        
        gsub(/\t/, "   ", line)
        
        if (length(line) == 0) {
            print ""
            next
        }

        current_line = ""
        current_len = 0
        
        while (length(line) > 0) {
            match(line, /[^[:space:]]+/)
            
            if (RSTART == 0) {
                current_line = current_line line
                break
            }
            
            gap = substr(line, 1, RSTART - 1)
            word = substr(line, RSTART, RLENGTH)
            
            chunk = gap word
            chunk_len = visible_length(chunk)
            
            if (current_len + chunk_len <= width) {
                current_line = current_line chunk
                current_len += chunk_len
            } else {
                if (current_len > 0) {
                    print current_line
                    current_line = word
                    current_len = visible_length(word)
                } else {
                    current_line = chunk
                    current_len = chunk_len
                }
            }
            line = substr(line, RSTART + RLENGTH)
        }
        
        if (length(current_line) > 0) print current_line
    }'
}

function messagebox() { 

    strip_ansi() {
        echo -e "$1" | sed -E 's/\x1b(\[[0-9;]*[A-Za-z]|\][^\x1b]*\x1b\\)//g'
    }
    printf "\e[G"


    local title_raw="Titulo"
    local content="Message"
    local type="Info"
    local term_cols=$(tput cols 2>/dev/null || echo 80)
    local max_width=$term_cols 

    local border_color="\e[32m"    
    local title_color="${border_color}"
    local reset="\e[0m"
    local no_prefix=false 
    local def_bg=""
    local to_end_tty=false

    while [[ "${1}" ]]; do 
      case "${1}" in 
        -title) title_raw="${2}"; shift 2 ;;
        -message) content="${2}"; shift 2 ;;
        -type) type="${2}"; shift 2 ;;
        -no-preffix) no_prefix=true; shift 1 ;;
        -bg) def_bg="${2}"; shift 2 ;; 
        -max-width) max_width="${2}"; shift 2 ;;
        -to-end-tty|--to-end-tty) to_end_tty=true; shift 1 ;;
        *) shift ;;
      esac 
    done 

    if [[ "$to_end_tty" == true ]]; then
        max_width=$((term_cols - 4))
    fi

    content=$(ansi_aware_wrap "$content" "$max_width")

    local preffix="󰋼 " 
    case "${type}" in 
      Info) preffix="󰋼 "; border_color="\e[32m";;
      Error) preffix=" "; border_color="\e[31m";;
      Warning) preffix=" "; border_color="\e[33m";;
      Hint) preffix="󰛩 "; border_color="\e[35m";; 
    esac 
    
    title_color="${border_color}"

    if [[ "${no_prefix}" == true ]]; then 
      preffix=""
    fi 

    if [[ -n "${def_bg}" ]]; then 
      border_color="${def_bg}"
      title_color="${border_color}"
    fi 

    local visible_title_full="$(strip_ansi "${preffix}${title_raw}")"
    local title_len=${#visible_title_full}      

    IFS=$'\n' read -rd '' -a lines <<< "$content"

    local max_content=0
    for line in "${lines[@]}"; do
        local stripped=$(strip_ansi "$line")
        (( ${#stripped} > max_content )) && max_content=${#stripped}
    done

    local max=$max_content
    (( title_len > max )) && max=$title_len

    if [[ "$to_end_tty" == true ]]; then
        (( max = term_cols - 4 ))
        if (( max < title_len )); then max=$title_len; fi
    fi

    local title="${title_color}${preffix}${title_raw}${reset}"

    echo -ne "${border_color}╭${reset}"
    echo -ne "${title}"
    printf "${border_color}"
    local line_len=$((max + 2 - title_len))
    for ((i=0; i<line_len; i++)); do printf "─"; done
    printf "╮${reset}\n"

    for line in "${lines[@]}"; do
        local stripped=$(strip_ansi "$line")
        local current_len=${#stripped}
        local diff=$((max - current_len))

        printf "${border_color}│${reset} "
        printf "%b" "$line"
        
        if [ $diff -gt 0 ]; then
            printf "%${diff}s" ""
        fi
        
        printf " ${border_color}│${reset}\n"
    done

    printf "${border_color}╰"
    for ((i=0; i<max+2; i++)); do printf "─"; done
    printf "╯${reset}\n"
}

function main(){
  types=(Hint Error Warning Info)

  
  for type in "${types[@]}"; do 
  local colored_text="\e[31mEsta\e[0m \e[32mes\e[0m \e[33muna\e[0m \e[34mprueba\e[0m \e[35mde\e[0m \e[36mtexto\e[0m \e[31mcon\e[0m \e[32mmuchos\e[0m \e[33mcódigos\e[0m \e[34mANSI\e[0m. La versión con AWK procesa esto instantáneamente sin importar la longitud.\nEste mensaje es de tipo: ${type}"

    messagebox \
        -message "$colored_text" \
        -title "Full Width" \
        -type "${type}" \
        --to-end-tty \
        # -no-preffix
  done 
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then 
 main 
fi
