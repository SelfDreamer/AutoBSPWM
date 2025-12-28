#!/usr/bin/env bash

function messagebox() { 

    strip_ansi() {
        echo -e "$1" | sed -E 's/\x1b(\[[0-9;]*[A-Za-z]|\][^\x1b]*\x1b\\)//g'
    }


    local title_raw="Titulo"
    local content="Message"
    local type="Info"
    local max_width=$(stty size | awk '{print $2}') 

    local border_color="\e[32m"   
    local title_color="${border_color}"
    local reset="\e[0m"
    local no_prefix=false 
    local def_bg=""

    while [[ "${1}" ]]; do 
      case "${1}" in 
        -title) title_raw="${2}"; shift 2 ;;
        -message) content="${2}"; shift 2 ;;
        -type) type="${2}"; shift 2 ;;
        -no-preffix) no_prefix=true; shift 1 ;;
        -bg) def_bg="${2}"; shift 2 ;; 
        -max-width) max_width="${2}"; shift 2 ;;
        *) shift ;;
      esac 
    done 

    content=$(echo -e "$content" | fold -s -w "$max_width")

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

   messagebox \
     -message "Este es un texto común y corriente. Y no, la caja no estara vacia" \
     -title "${type}" \
     -type "${type}" \

 done 

}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then 
 main 
fi
