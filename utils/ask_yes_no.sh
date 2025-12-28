#!/usr/bin/env bash

ask_yes_no() {
    local message="Are you sure?"
    local options=("Yes" "No")
    
    tput civis >&2

    # Valores por defecto 
    local SELECTED_BG="\e[45m"      
    local UNSELECTED_BG="\e[100m"   
    local FG="\e[97m"               

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -message|--message)
                message="$2"; shift 2;;
            -options|--options)
                IFS=',' read -ra options <<< "$2"; shift 2;;
            -selected-bg|--selected-bg) SELECTED_BG="${2}"; shift 2;;
            -unselected-bg|--unselected-bg) UNSELECTED_BG="${2}"; shift 2;; 
            -fg|--fg) FG="${2}"; shift 2;; 
            *) shift;;
        esac
    done

    local RESET="\e[0m"

    local index=0

    local msg_lines=$(grep -c "^" <<< "$message")
    local BLOCK_LINES=$((msg_lines + 2))

    build_buttons_line() {
        local line=""
        local PAD="    "
        for i in "${!options[@]}"; do
            local text="${PAD}${options[$i]}${PAD}"   
            if [ "$i" -eq "$index" ]; then
                line+="${SELECTED_BG}${FG}${text}${RESET}  "
            else
                line+="${UNSELECTED_BG}${FG}${text}${RESET}  "
            fi
        done
        printf "%b" "$line"
    }

    draw() {
        printf "\e[%dA" "$BLOCK_LINES" >&2

        while IFS= read -r line; do
            printf "\e[2K\r  %b\n" "$line" >&2
        done <<< "$message"

        printf "\e[2K\r  " >&2
        local btns=$(build_buttons_line)
        printf "%s\n" "$btns" >&2

        printf "\e[2K\r  ←→ mover • Enter seleccionar\n" >&2
    }

    while IFS= read -r line; do
        printf "  %s\n" "$line" >&2
    done <<< "$message"

    printf "  " >&2
    local btns=$(build_buttons_line)
    printf "%s\n" "$btns" >&2
    printf "  ←→ mover • Enter seleccionar\n" >&2
    
    draw

    while true; do
        IFS= read -rsn1 key 2>/dev/null
        case "$key" in
            $'\x1b')   
                IFS= read -rsn2 -t 0.01 rest 2>/dev/null || rest=""
                case "$rest" in
                    "[C") 
                        ((index=(index+1)%${#options[@]})); draw;;
                    "[D") 
                        ((index=(index-1+${#options[@]})%${#options[@]})); draw;;
                esac
                ;;
            "") 
                printf "\n" >&2
                tput cnorm >&2 
                
                printf "%s" "${options[$index]}"
                
                return 0
                ;;
        esac
    done
}

function main() {
  options="Si,No"
  resp=$( \
    ask_yes_no \
    -options "${options}" \
    -message "¿Deseas continuar?" \
    -selected-bg "\e[45m" \
    -unselected-bg "\e[100m" \
    -fg "\e[97m" \
  )
  
  case "${resp}" in 
    Si) 
      printf "[+] Vamos a continuar...\n"
      return 0 
      ;;
    No)
      printf "[!] No vamos a continuar...\n"
      return 1
      ;;

  esac 
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then # if __name__ == '__main__'
  main 
fi 
