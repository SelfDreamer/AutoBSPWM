#!/bin/bash

ruta=$(realpath ${0} | rev | cut -d'/' -f2- | rev)
cd "${ruta}" || exit 1 
SELF=${0##*/}
# Colors
source Colors.sh
source ./variables/global_variables.sh

[[ ! -d "${DIRECTORY}" ]] && mkdir -p "${DIRECTORY}"

function def_handler(){ 
  exec 3>&-
  echo -e "\n${bright_red}[!] Saliendo del programa...${end}\n\n"
  [[ -f $results  ]] && rm $results
  [[ -f $TMP_ARCHIVE ]] && rm $TMP_ARCHIVE
  [[ -f $vulnhub_results ]] && rm $vulnhub_results
  [[ -f $htb_results ]] && rm $vulnhub_results
  tput cnorm
  exit 1
}
# Ctrl + C
trap def_handler INT

function banner(){
      echo -e "${bright_green}
                    .
                 %%%%%%%.
             %%%%%%.  %%%%%%.
        %%%%%%           *%%%%%%.
     %%%%%                   .%%%%%%    
     %%%%%%%%               %%%%%%%%
     %%   %%%%%%%      .%%%%%%%  %%%
     %%       #%%%%%%%%%%%#      %%%    ${bright_white}s4vimachines - (infosec) Terminal Client${bright_green}
     %%           %%%%#          %%%    ${bright_blue}\t\t        by dreamer${bright_red} <3${end}${bright_green}
     %%            %%%           %%%     
     %%            %%%           %%%
     %%%%%         %%%          %%%%
       %%%%%%%     %%%     %%%%%%.
           #%%%%%%%%%%%%%%%%%
                %%%%%%%%#
                    .${end}\n"


                    # Este banner no fue copiado jeje 
}

function getInfo(){
  echo -ne "${bright_white}Total machines: ${end}"; tput setaf 6; cat $PATH_ARCHIVE | tail -n 6 | grep -oP "\d{1,3}" | xargs | sed 's| |+|g' | bc; echo

  declare -i color=1 
  tail -n 6 "${PATH_ARCHIVE}" | grep -Pi "totalMachines.*" -A 3 | sed 's/htb/HackTheBox (htb)/' | sed 's/vuln/VulnHub (vuln)/' | sed 's/swigger/PortSwigger (swigger)/' | tail -n3  | sed 's/^ *//g' | while read line; do 
    ((color+=1)); tput setaf $color; echo "$line" 
  done

  printf "%bHTB-Challenge: Comming soon%b\n" "${bright_magenta}" "${end}"
  echo
}


function helpPanel(){
  $exclude_banner && exec 3>/dev/null || exec 3>&1 
  local total_machines=$(grep -i Total -A 4 "${PATH_ARCHIVE}" | grep -oP "\d{1,3}" | xargs | sed 's/ /+/g' | bc)
    
  banner >&3 
  getInfo >&3

  for _ in $(seq 1 80); do
    echo -ne "${bright_red}-" >&3 
  done; 

  echo -ne "${end}" 

  echo -e "\n" >&3

  HELP="""\n${bright_white}Modo de uso: [${SELF}] [PARAMETROS] [ARGUMENTOS]${end}
  \t${bright_yellow}-h${bright_magenta}(help)${bright_white}: Mostrar el manual de ayuda.${end}

  \n${bright_white}Actualizaciones y dependencias:${end}
  \t${bright_yellow}-u${bright_magenta}(update):${bright_white} Actualizar dependencias${end}

  \n${bright_white}Listar máquinas y/o propiedades:${end}
  \t${bright_yellow}-m${bright_magenta}(machine):${bright_white} Mostrar las propiedades de una máquina.${end}
  \t${bright_cyan}[Ejemplo]${bright_white} ${SELF}${bright_yellow} -m 'Multimaster'${end}\n
  \t${bright_yellow}-i${bright_magenta}(ip_addr):${bright_white} Mostrar máquinas por la dirección IP.${end}
  \t${bright_cyan}[Ejemplo]${bright_white} ${SELF}${bright_yellow} -i '10.10.10.179'${end}\n
  \t${bright_yellow}-d${bright_magenta}(difficulty):${bright_white} Mostrar máquinas por una dificultad dada.${end}
  \t${bright_cyan}[Ejemplo]${bright_white} ${SELF}${bright_yellow} -d 'Insane'${end}\n
  \t${bright_yellow}-o${bright_magenta}(osSystem):${bright_white} Mostrar máquinas por un sistema operativo dado.${end}
  \t${bright_cyan}[Ejemplo]${bright_white} ${SELF}${bright_yellow} -o 'Windows'${end}\n
  \t${bright_yellow}-w${bright_magenta}(writeup):${bright_white} Mostrar el enlace a la resolución de una máquina${end}
  \t${bright_cyan}[Ejemplo]${bright_white} ${SELF}${bright_yellow} -w 'Multimaster'${end}\n
  \t${bright_yellow}-s${bright_magenta}(skill):${bright_white} Listar máquinas por skill${end}
  \t${bright_cyan}[Ejemplo]${bright_white} ${SELF}${bright_yellow} -s 'SQLI'${end}\n
  \t${bright_yellow}-p${bright_magenta}(platform):${bright_white} Listar todas las máquinas de una plataforma${end}
  \t${bright_cyan}[Ejemplo]${bright_white} ${SELF}${bright_yellow} -p 'HackTheBox'${end}\n
  \t${bright_yellow}-c${bright_magenta}(certificate):${bright_white} Listar todas las máquinas que dispongan de uno o mas certificados${end}
  \t${bright_cyan}[Ejemplo]${bright_white} ${SELF}${bright_yellow} -c 'OSCP OSWE OSEP'${end}\n
  \t${bright_yellow}-A${bright_magenta}(Advanced Search):${bright_white} Realizar una busqueda avanzada.${end}
  \t${bright_cyan}[Ejemplo]${bright_white} ${SELF}${bright_yellow} -A 'Unicode Sqli Insane windows oscp oswe'${end}\n
  \t${bright_yellow}-a${bright_magenta}(all):${bright_white} Listar todas las máquinas existentes.${end}
  \t${bright_cyan}[Ejemplo]${bright_white} ${SELF}${bright_yellow} -a${end}\n

  ${bright_white}Extras:${end}
  \t${bright_yellow}-r${bright_magenta}(random):${bright_white} Modo de elección aleatorio. El script elegira una máquina al azar por ti.${end}
  \t${bright_cyan}[Ejemplo]${bright_white} ${SELF}${bright_yellow} -r${end}\n
  \t${bright_yellow}-v${bright_magenta}(verbose):${bright_white} Activar el modo verbose${end}
  \t${bright_cyan}[Ejemplo]${bright_white} ${SELF}${bright_yellow} -u -v${end}\n
  \t${bright_yellow}-y${bright_magenta}(yes):${bright_white} Confirmar cada acción que dependa de una confirmación de usuario (sirve también para iterar por cada máquina)${end}
  \t${bright_cyan}[Ejemplo]${bright_white} ${SELF}${bright_yellow} -u -y${end} ${bright_white}| s4vimachines.sh ${bright_yellow}-A 'CSRF'${bright_white} -y${end}\n
  \t${bright_yellow}-t${bright_magenta}(translate):${bright_white} Traducir el output a un idioma especifico.${end}
  \t${bright_cyan}[Ejemplo]${bright_white} ${SELF}${bright_yellow} -m 'Tentacle'${bright_yellow} -t${bright_white} 'es'${end}\n
  \t${bright_yellow}-b${bright_magenta}(browser):${bright_white} Abrir el writeup de una máquina, en un navegador especifico.${end}
  \t${bright_cyan}[Ejemplo]${bright_white} ${SELF}${bright_yellow} -w 'Tentacle'${bright_yellow} -b${bright_white} '' (Navegador por default: ${bright_yellow}firefox${bright_white})\n
  \t${bright_yellow}-x${bright_magenta}(exclude banner):${bright_white} No mostrar el banner en el panel de ayida.${end}
  \t${bright_cyan}[Ejemplo]${bright_white} ${SELF}${bright_yellow} -x${end}\n"""

  printf "%b\n" "${HELP}"
  
  exec 3>&-

}

function searchMachine(){


  machineName="$1"

  if ! grep -i "name: ${machineName}$" "${PATH_ARCHIVE}" &>/dev/null; then
    echo -e "${bright_red}\n[!] Error fatal: Máquina no encontrada ${end}${bg_bright_red}\"$machineName\"\n${end}"
    exit 1
  fi
 
  if [[ $show_output_translate == false ]]; then
  output=$(grep -i "name: ${machineName}$" "${PATH_ARCHIVE}" -A 6 -B 1  | sed 's/^ *//g')

    echo "$output" | while IFS= read -r line; do
      first_column=$(echo $line | awk '{print $1}')
      rest_columns=$(echo $line | cut -d' ' -f2-)
      if [[ -n "$rest_columns" ]]; then
        echo -e "${bright_yellow}${first_column}${end} ${bright_white}${rest_columns}${end}" >> $results
      fi

    done

    echo -e "\n${bright_cyan}[+]${end} ${bright_white}Maquina encontrada:${end} ${bright_magenta}$machineName${end}${bright_white}, listando sus propiedades:${end}"
    echo; /bin/cat $results | sed 's/--.*//'; rm $results
  else
    output=$(cat $PATH_ARCHIVE| grep -i "name: $machineName" -A 6 -B 1  | sed 's/^ *//g' | trans -b -t $language; echo)

    echo "$output" | while IFS= read -r line; do
      first_column=$(echo $line | awk '{print $1}')
      rest_columns=$(echo $line | cut -d' ' -f2-)
      if [[ -n "$rest_columns" ]]; then
        echo -e "${bright_yellow}${first_column}${end} ${bright_white}${rest_columns}${end}" >> $results
      fi

    done

    echo -e "\n${bright_cyan}[+]${end} ${bright_white}Maquina encontrada:${end} ${bright_magenta}$machineName${end}${bright_white}, listando sus propiedades:${end}"
    echo; /bin/cat $results | sed 's/--.*//'; rm $results
    return 0
      
  fi
}

function searchForIp() {
    ip_addr="$1"

    matches=$(grep -B 6 -A 1 "ip: $ip_addr" "$PATH_ARCHIVE")


    if [[ -z "$ip_addr" ]]; then
      echo -e "\n${bright_red}[!] Es necesario introducir tu input de usuario!${end}"
      return 1
    fi
   
    if [[ -z "$matches" ]]; then
        echo -e "\n${bright_red}[!] Dirección IP no encontrada en la base de datos: $ip_addr.\n${end}"
        return 1
    fi

    # Extraer nombres de máquinas
    machineNames=$(echo "$matches" | grep -oP 'name: \K.*')

    # Contar cuántas máquinas coinciden
    amount_machines=$(echo "$machineNames" | wc -l)

    # Si solo hay una coincidencia
    if [[ "$amount_machines" -eq 1 ]]; then
        echo -e "\n${bright_green}[+]${end} ${bright_white}La dirección IP: ${bright_yellow}$ip_addr${end} pertenece a la máquina ${bright_blue}$machineNames${end}"
        [[ "$confirm_act" == true ]] && searchMachine "$machineNames"
        return 0
    fi

    # Si hay múltiples coincidencias
    echo -e "\n${bright_green}[+]${end} ${bright_white}Matches encontrados para la IP: ${bright_yellow}$ip_addr${end}"
    echo; tput setaf 4; echo "$machineNames" | column; echo

    # Si la confirmación está activada, recorrer las máquinas
    if [[ "$confirm_act" == true ]]; then
        while IFS= read -r machine; do
            searchMachine "$machine"
        done <<< "$machineNames"
    fi
}

function showAllDifficulty(){
  echo -e "\n[+] Dificultades existentes: \n"
  echo -e "\t${bright_blue} Dificultad: easy"
  echo -e "\t${bright_yellow} Dificultad: medium"
  echo -e "\t${bright_cyan} Dificultad: hard"
  echo -e "\t${bright_red} Dificultad: insane"
}

function searchDifficulty(){
  difficulty="$1"
  difficulty=$(echo $difficulty | tr '[:upper:]' '[:lower:]')
 
  # Validar que la dificultad exista
  if ! cat $PATH_ARCHIVE | grep -i "state: $difficulty" &>/dev/null; then
    echo -e "\n${bright_red}[!] Dificultad no encontrada.${end}\n"
    showAllDifficulty
    exit 1
  fi
  
  local total_machines=$(cat $PATH_ARCHIVE | grep -i "state: $difficulty" -B 3  | grep -oP "name: .*" | sed 's/name://' | wc -l)

  [[ $help == true ]] && showAllDifficulty && exit 

  [[ $difficulty == "easy" ]] && echo -e "${bright_magenta}[+]${end} ${bright_white}Listando máquinas cuya dificultad es${end}${bright_blue} $difficulty: \n${end}"
  [[ $difficulty == "medium" ]] && echo -e "${bright_magenta}[+]${end} ${bright_white}Listando máquinas cuya dificultad es${end}${bright_yellow} $difficulty: \n${end}"
  [[ $difficulty == "hard" ]] && echo -e "${bright_magenta}[+]${end} ${bright_white}Listando máquinas cuya dificultad es${end}${bright_cyan} $difficulty: \n${end}"
  [[ $difficulty == "insane" ]] && echo -e "${bright_magenta}[+]${end} ${bright_white}Listando máquinas cuya dificultad es${end}${bright_red} $difficulty: \n${end}"
  echo -e "${bright_yellow}[+]${bright_white} Máquinas totales:${bright_green} $total_machines${end}"

    echo -e "\n${bright_yellow}[+]${bright_white} Plataforma HackTheBox:${end}"
    tput setaf 2; echo; cat $PATH_ARCHIVE | grep -i "state: $difficulty" -B 3 | grep -i "platform: HackTheBox" -A 1 | grep -oP "name: .*" | sed 's/name://' | column
    
    echo -e "\n${bright_yellow}[+]${bright_white} Plataforma VulnHub:${end}"
    tput setaf 3; echo; cat $PATH_ARCHIVE | grep -i "state: $difficulty" -B 3 | grep -i "platform: VulnHub" -A 1 | grep -oP "name: .*" | sed 's/name://' | column

}

searchOsSystem(){
  osSystem="$1"
  osSystem="$(echo "$osSystem" | tr '[:upper:]' '[:lower:]')"
  
  if [[ -z "$osSystem" ]]; then
    echo -e "\n${bright_red}[!] Es necesario introducir tu input de usuario!${end}"
    return 1
  fi

  if ! cat $PATH_ARCHIVE | grep -i "os: $osSystem$" &>/dev/null; then
    echo -e "\n${bright_red}[!] Sistema operativo no encontrado.${end}\n"
    echo -e "\t${bright_white}Sistemas operativos disponibles:${end} ${bright_cyan}Linux${end} ${bright_white}-${end} ${bright_blue}Windows${end}"
    exit 1
  fi


  echo -e "\n${bright_green}[+] Listando máquinas de Sistema Operativo: $osSystem\n${end}"
  echo -e "${bright_cyan}[+]${bright_white} Máquinas de la plataforma HackTheBox:${end}"
  tput setaf 2; echo; cat $PATH_ARCHIVE | grep -i "os: $osSystem$" -B 2 | grep -i "platform: HackTheBox" -A 1 | grep -oP "name: .*" | sed 's/name://' | column; echo
  
  echo -e "${bright_cyan}[+]${bright_white} Máquinas de la plataforma VulnHub:${end}"
  tput setaf 3; echo; cat $PATH_ARCHIVE | grep -i "os: $osSystem$" -B 2 | grep -i "platform: VulnHub" -A 1 | grep -oP "name: .*" | sed 's/name://' | column; echo

}

function showLink(){
  writeup="$1"
  writeup=$(echo "$writeup" | tr '[:upper:]' '[:lower:]')

  if ! cat $PATH_ARCHIVE | grep -i "name: $writeup" &>/dev/null; then
    echo -e "\n${bright_red}[!] Máquina no encontrada: $writeup${end}\n\n"
    exit 1
  fi
  link=$(cat $PATH_ARCHIVE | grep -i "name: $writeup" -A  6 | grep -i "video: https:" | sed 's/video://' | sed 's/^ *//')

  echo -e "\n${bright_cyan}[+]${end} ${bright_white}Writeup de la máquina${end} ${bright_green}$writeup${bright_white}: ${bright_blue}$link${end}\n" 
  
  if [[ $open_browser == true ]]; then
    if ! command -v $browser &>/dev/null; then
      echo -e "\n${bg_bright_red}[!] Navegador invalido: $browser!${end}\n"
      exit 1
    fi
    echo -e "\n${bright_cyan}[+]${bright_white} Abriendo el enlace:${bright_blue} $link en el navegador${bright_magenta} $browser${bright_white}...${end}\n"
    $browser $link &>/dev/null & disown
  fi

  path_writeup="Writeups/$writeup"
}

function log(){
  message="${1:-Este mensaje es de prueba}"

  if ! "${verbose_mode}"; then 
    return 
  fi 

  echo -e "${message}"

}

function s4vidownload(){

  dest="${1:-$PATH_ARCHIVE}" 

  printf "\n"
  
  # Download the required file 
  # Parameter -O indicates the Path (-o=output) 
  # For example 
  # wget https://downloadable.com/recurse.zip -O/path/to/file.zip 
  # ---
  #
  # Parameter -nv (--no-verbose) then, wget just show the "necesary"
  # Sorry if my english is so bad D:
  
  log "${bright_magenta}[+]${end}${bright_white} Extrayendo el archivo necesario de ${bright_blue}${url}${end}"

  wget "${url}" -O"${dest}" -nv 
  
  log "${bright_magenta}[+]${end}${bright_white} Modificando el archivo con expresiones regulares...${end}"
  
  
  # No coments here :)
   
  js-beautify "${dest}" | tr -d "'\",[]{}" \
     | sed -E 's|\\n| |g; s/^ *//' | sponge "${dest}" 2>&1 

}

function s4viupdate(){
  
  printf "\n%b[+]%b %bEstamos en busca de actualizaciones...%b\n" "${bright_magenta}" "${end}" "${bright_white}" "${end}" 
  
  s4vidownload "${TMP_ARCHIVE}"

  log "\n${bright_magenta}[+]${end} ${bright_white}Archivo ${bright_blue}${TMP_ARCHIVE##*/}${end}${bright_white} descargado y modificado con exito, se buscaran diferencias con ${bright_cyan}${PATH_ARCHIVE##*/}${end}\n"

  if cmp "${PATH_ARCHIVE}" "${TMP_ARCHIVE}" --quiet; then 

    log "\n${bright_magenta}[+]${end} ${bright_white}No se detectaron actualizaciones, estas al día!${end}"

    rm "${TMP_ARCHIVE}"

    return 0
 
  fi 
  
  # There are updates! 

  printf "%b[+]%b Actualizaciones encontradas y realizadas!%b\n" "${bright_magenta}" "${bright_white}" "${end}"
  rm "${PATH_ARCHIVE}" && mv "${TMP_ARCHIVE}" "${PATH_ARCHIVE}"
  
}

function updatefiles(){ 

  tput civis

  # File doesnt exists, then we will create an file with the necesary recourses!
  local response

  local update=false 
  local download=false 

  if [[ ! -f "${PATH_ARCHIVE}" ]]; then 
    prompt="read -n 1 -p $'${bright_white}El archivo ${bright_blue}${PATH_ARCHIVE##*/}${bright_white} no fue encontrado ¿Deseas bajarte el archivo? (Y/n)${end} ' response"
    download=true
  elif [[ -f "${PATH_ARCHIVE}" ]]; then
    prompt="read -n 1 -p $'${bright_white}El archivo ${bright_blue}${PATH_ARCHIVE##*/}${bright_white} existe ¿Deseas actualizarlo si lo requiere? (Y/n)${end} ' response"
    update=true
  fi


  # Put an option (-y) if the user entered the -y parameter 
  "${confirm_act}" && prompt="$prompt <<< 'y' "
  
  eval "${prompt}"

  response=${response,,}
  tput cnorm

  [[ -z "${response}" ]] && printf "\n%b[!] Es necesario introducir una entrada de usuario valida!%b\n\n" "${bright_red}" "${end}" && return 1  

  [[ "${response}" =~ ^[s] ]] && response="y"
  
  declare -A options=(
    ["y"]="true"
    ["n"]="echo -e \"\n${bright_red}[!] Operación cancelada por $USER\n${end}\"; exit 1"
    )


  [[ ! "${response}" =~ ^[yn] ]] && printf "\n%b[!] Opción desconocida!%b\n\n" "${bright_red}" "${end}" && return 1  


  cmd="${options["${response}"]}"

  bash -c "${cmd}" || return 1 

  printf "\n"

  if ${download}; then 
    echo -e "\n${bright_magenta}[+]${end} ${bright_white}Se procedera a descargar los recursos necesarios para hacer uso de esta herramienta.${end}"
    s4vidownload
  elif ${update}; then 
    echo -e "\n${bright_magenta}[+]${end} ${bright_white}Se procedera a actualizar los recursos necesarios para mantenerte al día.${end}"
    s4viupdate 
  fi

}

: '
Esta función funciona de la siguiente forma.
Vamos a declarar una variable local, la cual valga 0 y vamos a ir incrementando su valor.
Mientras que value, valga 0, entonces le sumaremos 1 a value y agarraremos una máquina aleatoria, de todas las que hay.
Se agarra una máquina aleatoria usando shuf -n 1. Una vez que value valga 100, se revelara nuyestra máquina para jugar.
Espero me haya dejado entender porque honestamente, a veces pienso que tengo autismo o TDAH. Me cuesta entender las cosas pero me esfuerzo.

'

function random_machine(){
  tput civis
  local value=0
    while [[ $value -le 100 ]]; do
        machineName=$(cat $PATH_ARCHIVE | grep -i 'name: .*' | sed 's/name: //' | sed 's/^ *//' | shuf -n 1)
        echo -ne "\r\033[K${bright_blue}[+]${bright_white} Tu máquina elegida es: ${bright_cyan}\"$machineName\"${end}"
        ((value++))
    done
  
    tput cnorm && searchMachine "$machineName" 
    return 0
}

function searchPlatform(){
  platform="$1"
  
  if ! cat $PATH_ARCHIVE | grep -i "platform: $platform" &>/dev/null; then
    echo -e "\n[!] Error fatal, no se enctontro la plataforma: $platform"
    exit 1
  fi

  if [[ -z "$platform" ]]; then
    echo -e "\n${bright_red}[!] Es necesario introducir tu input de usuario!${end}"
    return 1
  fi


  if [[ "$confirm_act" == false ]]; then 
    if [[ "$platform" =~ ^[Hh] ]]; then
      echo -e "\n${bright_green}[+]${bright_white} Listando máquinas de la plataforma HackTheBox: ${end}"
      tput setaf 2; echo; cat $PATH_ARCHIVE | grep -i "platform: $platform" -A 1 | grep -oP "name: .*" | sed 's/name://' | column; echo
    elif [[ "$platform" =~ ^[Pp] ]]; then
      echo -e "\n${bright_yellow}[+]${bright_white} Listando máquinas de la plataforma PortSwigger: ${end}"
      tput setaf 3 && tput bold; echo; cat $PATH_ARCHIVE | grep -i "platform: $platform" -A 1 | grep -oP "name: .*" | sed 's/name://' | column; echo
    else
      echo -e "\n${yellow}[+]${bright_white} Listando máquinas de la plataforma VulnHub: ${end}"
       tput setaf 3; echo; cat $PATH_ARCHIVE | grep -i "platform: $platform" -A 1 | grep -oP "name: .*" | sed 's/name://' | column; echo   
    fi
  fi

  if [[ "$confirm_act" == true ]]; then
    cat $PATH_ARCHIVE | grep -i "platform: $platform" -A 1 | grep -o 'name: .*' | sed 's/name: //' | while read machineName; do
          searchMachine "$machineName"
    done
  fi

}

function Get_cert(){
    certificate="$1"
    output=$(echo "./addFuncs/getCertificates.sh" "$certificate" | bash)  # Captura la salida del script

   if [[ -z "$certificate" ]]; then
    echo -e "\n${bright_red}[!] Es necesario introducir una cadena valida.${end}"
    exit 1
   fi
    

    if [[ -z "$output" ]]; then  # Verifica si la salida no está vacía
      echo -e "\n${bright_red}[!] No se encontraron matches: $certificate${end}"
      return 1
    fi
  
    
    echo -e "\n${bright_blue}[+]${end} ${bright_white}Listando máquinas que dispongan de los certificados ${bright_cyan}$certificate${bright_white}.${end}\n"
    echo "./addFuncs/getCertificates.sh ""$certificate" | bash
    if [[ "$confirm_act" == false ]]; then
      rm /tmp/all_machines.txt 2>/dev/null
    else
      while read machine; do
        searchMachine "$machine"
      done < /tmp/all_machines.txt
      rm /tmp/all_machines.txt 2>/dev/null
    fi
}

function searchSkill(){
  skill="$1"
  output=$(echo "./addFuncs/getSkills.sh" "$skill" | bash)  # Captura la salida del script
  

  if [[ -z "$skill" ]]; then
    echo -e "\n${bright_red}[!] Es necesario introducir una cadena valida.${end}"
    exit 1
  fi

  if [[ -z "$output" ]]; then  # Verifica si la salida no está vacía
    echo -e "\n${bright_red}[!] No se encontraron matches: $skill${end}"
    return 1
  fi

  echo -e "\n${bright_blue}[+]${end} ${bright_white}Listando máquinas que dispongan de skill ${bright_cyan}$skill${bright_white}.${end}\n"
  echo "./addFuncs/getSkills.sh ""$skill" | bash
  if [[ "$confirm_act" == false ]]; then
    rm /tmp/all_machines.txt 2>/dev/null
  else
      while read machine; do
        searchMachine "$machine"
      done < /tmp/all_machines.txt
      rm /tmp/all_machines.txt 2>/dev/null
  fi

}

function get_allMachines(){
  
  : '
  Una vez capturado el campo "name:", nos quedamos solo con lo que quede despues, es decir reiniciamos el punto de matching
  Esto se logra colocando un \K
  wc -l nos sirve para contar cuantas lineas hay en un output, o archivo, podemos indicar lineas, palabras, etc. 
  En este caso solo obtuve todas las máquinas, y con wc -l obtuve las lineas totales, si le aplicaba column probablemente petaba
  '
  local total_machines=$(cat $PATH_ARCHIVE | grep -oP "name:\K.*" | wc -l)
  echo -e "\n${bright_cyan}[+]${bright_white} Listando todas las máquinas disponibles (${bright_blue}$total_machines${bright_white}):${end} "

  # Para la plataforma de HackTheBox
  local total_htb=$(cat $PATH_ARCHIVE | grep -i "platform: HackTheBox" -A 3 | grep -oP "name:\K.*" | wc -l)
  echo -e "\n${bright_cyan}[+]${bright_white} Plataforma HackTheBox (${bright_green}$total_htb${bright_white}):${end} \n"
  tput setaf 2 && cat $PATH_ARCHIVE | grep -i "platform: HackTheBox" -A 3 | grep -oP "name:\K.*"  | column


  # Para la plataforma de VulnHub
  local total_vulnhub=$(cat $PATH_ARCHIVE | grep -i "platform: VulnHub" -A 3 | grep -oP "name:\K.*" | wc -l)
  echo -e "\n${bright_cyan}[+]${bright_white} Plataforma VulnHub (${bright_yellow}$total_vulnhub${bright_white}):${end} \n"
  tput setaf 3 && cat $PATH_ARCHIVE | grep -i "platform: VulnHub" -A 3 | grep -oP "name:\K.*"  | column


  # Para la plataforma de PortSwigger
  local total_swigger=$(cat $PATH_ARCHIVE | grep -i "platform: PortSwigger" -A 3 | grep -oP "name:\K.*" | wc -l)
  echo -e "\n${bright_cyan}[+]${bright_white} Plataforma PortSwigger (${bright_magenta}$total_swigger${bright_white}):${end} \n"
  tput setaf 5 && cat $PATH_ARCHIVE | grep -i "platform: PortSwigger" -A 3 | grep -oP "name:\K.*"  | column

}



function advanced_search(){
 : '
 Hi
 '
  objects="$1"

#  output=$(echo "./addFuncs/advanced_search.sh " "$objects" | bash)
  [[ -z "${objects}" ]] || echo -e "\n${bright_green}[+]${bright_white} Realizando la busqueda avanzada:${bright_cyan} \"$objects\"${end}" 

  echo "./addFuncs/advanced_search.sh" "$objects" | bash

  if [[ "$confirm_act" == true ]]; then
    while IFS= read -r machine; do
      searchMachine "$machine"
    done < /tmp/machine_results
    rm /tmp/machine_results 2>/dev/null
    return 0
  fi

  rm /tmp/machine_results 2>/dev/null
  return 0
}

function searchOsDiff(){
  osSystem="$1"
  difficulty="$2"
  
  exists_os=$(cat $PATH_ARCHIVE | grep -i "os: $osSystem")
  exists_diff=$(cat $PATH_ARCHIVE | grep -i "state: $difficulty")
  if [[ ! "$exists_os" || ! "$exists_diff"  ]]; then
    echo -e "\n${bright_red}[!] No encontramos resultados para: $osSystem - $difficulty${end}"
    echo -e "\n${bright_white}Sistemas operativos disponibles:${end} ${bright_cyan}Linux${end} ${bright_white}-${end} ${bright_blue}Windows${end}"
    showAllDifficulty
    exit 1
  fi
    
  local total_htb=$(cat $PATH_ARCHIVE | grep -i "os: $osSystem" -B 2 -A 4 | grep -i "state: $difficulty" -B 3 | grep -i "platform: HackTheBox" -A 1 | grep -oP "name:\K.*" | wc -l)
  if [[ "$total_htb" -eq 0 ]]; then
    echo -e "\n${bright_black}[*] No se encontraron máquinas para la plataforma de HackTheBox.${end}\n"
  else
    echo -e "\n${bright_cyan}[+]${bright_white} Máquinas de la plataforma: HackTheBox (${bright_green}$total_htb${bright_white}):${end}" 
    echo; tput setaf 2; cat $PATH_ARCHIVE | grep -i "os: $osSystem" -B 2 -A 4 | grep -i "state: $difficulty" -B 3 | grep -i "platform: HackTheBox" -A 1 | grep -oP "name:\K.*" | column
  fi
  
  local total_vulnhub=$(cat $PATH_ARCHIVE | grep -i "os: $osSystem" -B 2 -A 4 | grep -i "state: $difficulty" -B 3 | grep -i "platform: VulnHub" -A 1 | grep -oP "name:\K.*" | wc -l)
  if [[ "$total_vulnhub" -eq 0 ]]; then
    echo -e "\n${bright_black}[*] No se encontraron máquinas en la plataforma de VulnHub.${end}\n"
  else
    echo -e "\n${bright_cyan}[+]${bright_white} Máquinas de la plataforma: VulnHub (${bright_yellow}$total_vulnhub${bright_white}):${end}" 
    echo; tput setaf 3; cat $PATH_ARCHIVE | grep -i "os: $osSystem" -B 2 -A 4 | grep -i "state: $difficulty" -B 3 | grep -i "platform: VulnHub" -A 1 | grep -oP "name:\K.*" | column
  fi

}

searchChallengue(){
  challengue="${1}"

  return 0 

}

while getopts ':w:o:b:d:i:m:c:huvyxrp:t:s:aA:C:' arg; do
  case $arg in
    x) exclude_banner=true;;
    v) verbose_mode=true;;
    y) confirm_act=true;;
    m) machineName=$OPTARG; ((parameter_counter+=1));;
    t) language="$OPTARG"; show_output_translate=true;;
    b) browser="${OPTARG:-firefox}"; open_browser=true;[[ "$browser" == 'default' ]] && browser='firefox';;
    u) ((parameter_counter+=2));;
    i) ip_addr=$OPTARG; ((parameter_counter+=3));;
    d) difficulty=$OPTARG; ((parameter_counter+=4)); ((target_difficulty+=1));;
    o) osSystem=$OPTARG; ((parameter_counter+=5)); ((target_os+=1));;
    w) writeup=$OPTARG; ((parameter_counter+=6));;
    c) certificate="$OPTARG"; ((parameter_counter+=7));;
    p) platform="$OPTARG"; ((parameter_counter+=8));;
    s) skill="$OPTARG"; ((parameter_counter+=9));;
    a) ((parameter_counter+=10));;
    A) objects="$OPTARG"; ((parameter_counter+=11));;
    r) ((parameter_counter+=12));;
    C) challengue="${OPTARG}"; ((parameter_counter+=13));;
    h) help=true;;
    \?) echo -e "\n${bright_red}[!]${bright_white} Parametro invalido: ${bright_yellow}-$OPTARG${end}\n"; exit 1;;
  esac
done


if [[ ! -f "$PATH_ARCHIVE" && ! "$parameter_counter" -eq 2 ]]; then
  echo -e "\n${bright_red}[!]${bright_white} Necesitas actualizar las dependencias antes de usar este script!${end}"
  echo -e "\n${bright_white}Solución: ${SELF}${bright_yellow} -u${end}"
  exit 1
elif [[ $parameter_counter -eq 2 ]]; then
  updatefiles
  exit 0
fi

shopt -s nocasematch

if [[ $parameter_counter -eq 1 ]]; then
  searchMachine "$machineName"
elif [[ "$target_difficulty" -eq 1 && $target_os -eq 1 ]]; then
  searchOsDiff "$osSystem" "$difficulty"

elif [[ $parameter_counter -eq 3 ]]; then
  searchForIp "$ip_addr"
elif [[ $parameter_counter -eq 4 ]]; then
  searchDifficulty "$difficulty"
elif [[ $parameter_counter -eq 5 ]]; then
  searchOsSystem "$osSystem"
elif [[ $parameter_counter -eq 6 ]]; then
  showLink "$writeup"
elif [[ "$parameter_counter" -eq 7 ]]; then
  Get_cert "$certificate"
elif [[ "$parameter_counter" -eq 8 ]]; then
  searchPlatform "$platform"
elif [[ "$parameter_counter" -eq 9 ]]; then
  searchSkill "$skill"
elif [[ "$parameter_counter" -eq 10 ]]; then
  get_allMachines
elif [[ "$parameter_counter" -eq 11 ]]; then
  advanced_search "$objects"
elif [[ "$parameter_counter" -eq 12 ]]; then
  random_machine
elif [[ "$parameter_counter" -eq 13 ]]; then 
  searchChallengue "${challengue}"
else
  helpPanel
fi


