#!/bin/bash

# Autor: Flick

# Colours

greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

function ctrl_c(){
  echo -e "\n${redColour}[!] Saliendo...${endColour}\n\n"
  tput cnorm; exit 1
}
trap ctrl_c INT

# Variables globales
IpAdress=$1

if [[ "$IpAdress" =~ [a-zA-Z] ]]; then
  echo -e "\n${redColour}[!] Las direcciones IP no contienen caracteres alfabeticos.${endColour}"
  exit 1
fi
tput civis
if [[ "$IpAdress" ]]; then
  ttl=$(/usr/bin/ping -c 1 "$IpAdress" 2>/dev/null | grep "ttl" | awk '{print $6}' | sed 's/=/ /g' | awk 'NF{print $NF}')
  if [[ -z $ttl ]]; then 
    echo -e "\n${redColour}[!] ERROR: ${endColour} ${grayColour}No hay una respuesta por parte de la IP $IpAdress${endColour}\n"
    tput cnorm; exit 1
  fi
    if [[ $ttl -le 64 ]] && [[ $ttl -ge 0 ]]; then 
        echo -e "\n${purpleColour}$IpAdress${endColour}${grayColour} (ttl -> $ttl):${endColour} ${greenColour}Linux${endColour}\n"
        tput cnorm
    elif [[ $ttl -ge 65 ]] && [[ $ttl -le 128 ]]; then
     echo -e "\n${purpleColour}$IpAdress${endColour}${grayColour} (ttl -> $ttl):${endColour} ${greenColour}Windows${endColour}\n"
     tput cnorm 
    fi 
else
tput cnorm; echo -e "\n${redColour}[!]${endColour} ${grayColour}Uso:${endColour} ${purpleColour}$0${endColour} ${grayColour}<Dirección_IP>${endColour}\n"
fi
