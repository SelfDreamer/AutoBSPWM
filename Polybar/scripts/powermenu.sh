#!/usr/bin/env bash

options=(
    ""
    ""
    ""
    ""
    ""
)

rofi_cmd() {
	rofi -dmenu \
		-p "Goodbye ${USER}" \
		-mesg "Uptime: $(uptime -p | sed -e 's/up //g')" \
		-theme "$HOME"/.config/polybar/scripts/powermenu.rasi
}

chosen=$(printf "%s\n" "${options[@]}" | rofi_cmd)

case $chosen in
    "")
        systemctl poweroff
        ;;
    "")
        systemctl reboot
        ;;
    "")
	betterlockscreen -u ~/Imágenes/WindowsFont.jpg -l
        ;;
    "")
        mpc -q pause
        amixer set Master mute
        systemctl suspend
        ;;
    "")
        bspc quit
        ;;
esac
