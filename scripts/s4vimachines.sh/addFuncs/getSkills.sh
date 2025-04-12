#!/bin/bash

source Colors.sh

[[ -z "$1" ]] && exit 1

# Hacer las comparaciones insensibles a mayúsculas y minúsculas
shopt -s nocasematch
source ../variables/global_variables.sh 2>/dev/null || source variables/global_variables.sh 2>/dev/null

# Archivos temporales
htb_file="/tmp/skill_htb"
vuln_file="/tmp/skill_vuln"
swigger_file="/tmp/skill_swigger"

# Limpiar archivos anteriores

> "$htb_file"
> "$vuln_file"
> "$swigger_file"

# Variables para almacenar datos

machine_name=""
platform=""
skills=""
while IFS= read -r line; do
    # Detectar la plataforma
    if [[ $line =~ platform:\ (.*) ]]; then
        platform="${BASH_REMATCH[1]}"
    fi
    # Detectar nombre de la máquina
    if [[ $line =~ name:\ (.*) ]]; then
        machine_name="${BASH_REMATCH[1]}"
    fi
    # Detectar skills
    if [[ $line =~ techniques:\ (.*) ]]; then
        skills="${BASH_REMATCH[1]}"
        
        match_count=0
        for word in "$@"; do
            if [[ $skills =~ $word ]]; then
                ((match_count++))
            fi
        done

        if [[ $match_count -eq $# ]]; then
            case "$platform" in
                "HackTheBox") echo -e "$machine_name" >> "$htb_file" ;;
                "VulnHub") echo -e "$machine_name" >> "$vuln_file" ;;
                "PortSwigger") echo -e "$machine_name" >> "$swigger_file" ;;
            esac
        fi
    fi
done < $PATH_ARCHIVE
get_total(){
  # Eliminar archivos temporales
  local total_htb=$(wc -l $htb_file | awk '{print $1}')
  local total_swigger=$(wc -l $swigger_file | awk '{print $1}')
  local total_vul=$(wc -l $vuln_file | awk '{print $1}')
  echo "$total_htb + $total_vul + $total_swigger" | bc
}
total_machines=$(get_total)

if [[ $total_machines -ge 1 ]]; then
  echo -e "${bright_cyan}[+]${bright_white} Máquinas encontradas:${bright_magenta} $total_machines${end}"
fi

if [[ -s "$htb_file" ]]; then
  echo -e "${bright_cyan}[+]${bright_white} Plataforma Hack The Box:${end}"
  tput setaf 2; echo; /bin/cat $htb_file | column; tput sgr0; echo
fi

if [[ -s "$vuln_file" ]]; then
  echo -e "${bright_cyan}[+]${bright_white} Plataforma VulnHub: ${end}"
  tput setaf 3; echo; /bin/cat $vuln_file | column; tput sgr0; echo
fi

if [[ -s "$swigger_file" ]]; then
  echo -e "${bright_cyan}[+]${bright_white} PortSwigger: ${end}"
  tput setaf 1; /bin/cat $swigger_file | column; tput sgr0; echo
fi

> /tmp/all_machines.txt

for archivo in /tmp/skill_*; do
  while read line; do 
    echo "$line"  >> /tmp/all_machines.txt
  done < $archivo
done

# Mostrar los resultados en formato columnar
#for file in "$htb_file" "$vuln_file" "$swigger_file"; do
#    if [[ -s $file ]]; then
#        echo -e "${bright_green}[+]${bright_white} Máquinas en la plataforma $(basename "$file" | cut -d'_' -f2 | tr 'a-z' 'A-Z'):" 
#        echo  
#        /bin/cat "$file" | sort | column
#        echo ""
#    fi
#done
rm -f /tmp/skill_*
