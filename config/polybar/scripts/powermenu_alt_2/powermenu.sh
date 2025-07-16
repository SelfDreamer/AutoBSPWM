#!/usr/bin/env bash

dir="$HOME/.config/polybar/scripts/powermenu_alt_2/"

# CMDs
uptime="`uptime -p | sed -e 's/up //g'`"

# Options

shutdown=''
reboot=''
lock=''
suspend=''
logout=''

# Rofi CMD
rofi_cmd() {
	rofi -dmenu \
		-p "Uptime: ${uptime}" \
		-mesg "Uptime: ${uptime}" \
		-theme "${dir}"/config.rasi
}

# Pass variables to rofi dmenu
run_rofi() {

	echo -e "$lock\n$suspend\n$logout\n$reboot\n$shutdown" | rofi_cmd
}

# Execute Command
run_cmd() {
		if [[ $1 == '--shutdown' ]]; then
			systemctl poweroff
		elif [[ $1 == '--reboot' ]]; then
			systemctl reboot
		elif [[ $1 == '--suspend' ]]; then
      notify-send 'go to sleep' -t 1700
		elif [[ $1 == '--logout' ]]; then
      /usr/bin/bspc quit 
    fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    $shutdown)
		run_cmd --shutdown
        ;;
    $reboot)
		run_cmd --reboot
        ;;
    $lock)
			ScreenLocker
        ;;
    $suspend)
		run_cmd --suspend
        ;;
    $logout)
		run_cmd --logout
        ;;
esac
