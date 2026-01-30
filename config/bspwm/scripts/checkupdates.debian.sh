#!/bin/bash

clear 

yellow=$(echo -e "\u001b[1;33m")
blue=$(echo -e "\u001b[1;34m")
green=$(echo -e "\u001b[1;32m")
white=$(echo -e "\u001b[1;37m")
end=$(echo -e "\u001b[0m")

pkgs=$(apt list --upgradable 2>/dev/null | grep -E '^[^ ]+/')
total=$(printf "%s\n" "$pkgs" | wc -l)
readonly PATH_ARCHIVE="$HOME/.config/bin/updates.txt"

[[ "$total" -eq 1 ]] && word="update" || word="updates"

if [[ "${total}" -eq 0 ]]; then 
  printf "\n[*] No updates available\n"
  printf "\n\n[+] Program finished, press any key to exit." && read -n1 key; echo 
fi 

echo -e "${pkgs}" > "${PATH_ARCHIVE}"
echo -e "Total: ${total}" >> "${PATH_ARCHIVE}"


printf "%sThere are %d %s available:%s\n\n" "${yellow}" "${total}" "${word}" "${end}"
printf "%sRegular %s:%s\n\n" "${blue}" "${word}" "${end}"

sleep 1.4

printf "%s\n" "$pkgs" | awk -v white="${white}" -v blue="${blue}" -v green="${green}" -v yellow="${yellow}" -v end="${end}" '
{
    split($1, a, "/")      # nombre del paquete
    newver=$2              # versión nueva

    match($0, /\[.*\]/)    # agarramos lo que está entre [ ]
    old=$0
    gsub(/^.*\[|\]$/, "", old)   # quitamos los corchetes
    gsub(/.*: /, "", old)        # quitamos "actualizable desde:" o "upgradable from:"

    printf "%s%s%s %s >> %s%s\n", white, a[1], green, old, newver, end
}
'

printf "\n\n%s[+]%s Program finished, press any key to exit.%s" "${green}" "${white}" "${end}" && read -n1 key; echo 
