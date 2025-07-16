#!/usr/bin/env bash
DIRECTORY="$(realpath $0 | rev | cut -d'/' -f2- | rev)"
readonly CONFIG_PATH="$HOME/.config/polybar/current.ini"
cd "${DIRECTORY}" || return 1 

function launch() {

  if pidof -q polybar; then 
    pkill polybar 

  fi 

  { ~/.config/polybar/launch.sh & } > /dev/null
}

function get_theme(){
  grep -i "click-left = .*powermenu.sh" ${CONFIG_PATH} | awk '{ print $NF }'
}

ask_question(){
  yes=''
  no=''

  choosen="$(echo -e "$yes\n$no" | rofi -dmenu \
  -p 'Confirmation' \
  -mesg 'Are you Sure?' \
  -theme $DIRECTORY/confirm/config.rasi)"
  
  if [[  -z "${choosen}" ]]; then 
    return 1 
  fi 

  [[ "${choosen}" == "${no}" ]] && return 1 || return 0
} 

choose_launcher_style() {
    themeDir="$HOME/.config/polybar/scripts/ThemeSelector"
    themes=$(ls "$themeDir"/Theme*.png | sed 's|.*/Theme\([0-9]*\)\.png|\1|' | sort -n)

    selected=$(
    IFS=$'\n'
    for theme in $themes; do
        printf "%s\000icon\037%s/Theme%s.png\n" "$theme" "$themeDir" "$theme"
    done | rofi -dmenu \
                -theme "$HOME/.config/polybar/scripts/ThemeSelector/selector.rasi"
    )
    readonly THEME1_PATH="~/.config/polybar/scripts/powermenu.sh"
    readonly THEME2_PATH="~/.config/polybar/scripts/powermenu_alt/powermenu.sh"
    readonly THEME3_PATH="~/.config/polybar/scripts/powermenu_alt_2/powermenu.sh"
    OPT=""

    if [[ -n "${selected}" ]]; then 
      OPT="THEME${selected}_PATH"
      TARGET_PATH="${!OPT}"
      CURRENT_THEME=$(get_theme)

      if [[ "$CURRENT_THEME" == "$TARGET_PATH" ]]; then
        return 0 
      fi

      if ask_question; then 

        case "${selected}" in 
          1) sed -i "s|click-left = .*powermenu.sh|click-left = $THEME1_PATH|" $CONFIG_PATH; launch ;; 
          2) sed -i "s|click-left = .*powermenu.sh|click-left = $THEME2_PATH|" $CONFIG_PATH; launch ;; 
          3) sed -i "s|click-left = .*powermenu.sh|click-left = $THEME3_PATH|" $CONFIG_PATH; launch ;; 
        esac 
      fi 
    fi
}

choose_launcher_style
