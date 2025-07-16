#!/usr/bin/env bash

readonly THEME="${HOME}/.config/polybar/scripts/powermenu_alt/powermenu.rasi"

declare -A actions=(
  [""]="/usr/bin/ScreenLocker"
  [""]="/usr/bin/bspc quit"
  [""]="/usr/bin/systemctl poweroff"
  [""]="/usr/bin/systemctl reboot"
)

selected_option=$(printf "%s\n" "${!actions[@]}" | rofi -dmenu -i -theme "${THEME}")

[[ -n "$selected_option" && -n "${actions["${selected_option}"]}" ]] && eval "${actions[${selected_option}]}"
