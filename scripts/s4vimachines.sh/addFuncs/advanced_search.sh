#!/bin/bash
source Colors.sh
# Hacer las comparaciones insensibles a mayúsculas y minúsculas
shopt -s nocasematch

source ../variables/global_variables.sh 2>/dev/null || source variables/global_variables.sh 2>/dev/null

[[ -z "$1" ]] && echo -e "\n\n${bright_red}[!] Es necesario que introduzcas al menos un argumento${end}\n" && exit 1

# Archivo temporal para resultados
result_file="/tmp/machine_results"
> "$result_file"

# Variables para almacenar datos
machine_name=""
machine_data=""
skip_fields=0  # Bandera para saltar campos

while IFS= read -r line; do
    # Si la línea comienza con 'ip:' o 'video:', activamos el flag para saltar
    if [[ $line =~ ^(ip|video): ]]; then
        skip_fields=1
        continue
    fi
    
    # Si encontramos una línea vacía, reseteamos la flag
    if [[ -z "$line" ]]; then
        skip_fields=0
    fi
    
    if [[ $skip_fields -eq 0 ]]; then
        # Detectar nombre de la máquina
        if [[ $line =~ name:\ (.*) ]]; then
            machine_name="${BASH_REMATCH[1]}"
        fi
        
        # Acumular datos relevantes 
        machine_data+="$line"$'\n'
    fi
    
    # Cuando encontramos una línea vacía, procesamos la máquina anterior
    if [[ -z "$line" ]]; then
        match_count=0
        for word in "$@"; do
            if [[ $machine_data =~ $word ]]; then
                ((match_count++))
            fi
        done
        
        # Si todas las palabras buscadas están en los datos filtrados
        if [[ $match_count -eq $# ]]; then
            echo "$machine_name" >> "$result_file"
        fi
        
        # Resetear variables para la próxima máquina
        machine_name=""
        machine_data=""
    fi
done < $PATH_ARCHIVE

total_machines=$(wc -l "$result_file" | awk '{print $1}')

if [[ "$total_machines" -ge 1 ]]; then
  echo -e "${bright_cyan}[+]${bright_white} Máquinas encontradas:${bright_magenta} $total_machines${end}"
  echo
  tput setaf 6  # Color cian para los resultados
  cat "$result_file" | column
  tput sgr0     # Resetear color
  echo
else
  echo -e "\n${bright_red}[!] No se encontraron los siguientes matches: $*${end}\n"
  exit 1
fi

#rm -f "$result_file"
