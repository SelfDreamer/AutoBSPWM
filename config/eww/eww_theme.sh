#!/bin/bash

FILE="$HOME/.config/eww/colors.scss"

THEME="${1}"

case "${THEME}" in
    mocha)
        bg="#1e1e2e"; bg_alt="#313244"; fg="#cdd6f4"
        black="#45475a"; lightblack="#585b70"
        red="#f38ba8"; green="#a6e3a1"; yellow="#f9e2af"
        blue="#89b4fa"; magenta="#cba6f7"; cyan="#89dceb"
        archicon="#74c7ec" # Sapphire
        ;;
    macchiato)
        bg="#24273a"; bg_alt="#363a4f"; fg="#cad3f5"
        black="#494d64"; lightblack="#5b6078"
        red="#ed8796"; green="#a6da95"; yellow="#eed49f"
        blue="#8aadf4"; magenta="#c6a0f6"; cyan="#91d7e3"
        archicon="#7dc4e4"
        ;;
    frappe)
        bg="#303446"; bg_alt="#414559"; fg="#c6d0f5"
        black="#51576d"; lightblack="#626880"
        red="#e78284"; green="#a6d189"; yellow="#e5c890"
        blue="#8caaee"; magenta="#ca9ee6"; cyan="#99d1db"
        archicon="#85c1dc"
        ;;
    latte)
        bg="#eff1f5"; bg_alt="#ccd0da"; fg="#4c4f69"
        black="#bcc0cc"; lightblack="#acb0be"
        red="#d20f39"; green="#40a02b"; yellow="#df8e1d"
        blue="#1e66f5"; magenta="#8839ef"; cyan="#04a5e5"
        archicon="#209fb5"
        ;;
    default)
        bg="#0d0c0b"; bg_alt="#354847"; fg="#b4c8da"
        black="#354847"; lightblack="#7d8c98"
        red="#f7768e"; green="#9ece6a"; yellow="#e0af68"
        blue="#7aa2f7"; magenta="#bb9af7"; cyan="#7dcfff"
        archicon="#0f94d2"
        ;;
    *)
        echo "Tema '$1' no reconocido."
        exit 1
        ;;
esac

cat > "$FILE" <<EOF
// Theme: $THEME 
\$bg: $bg;
\$bg-alt: $bg_alt;
\$fg: $fg;

\$black: $black;
\$lightblack: $lightblack;

\$red: $red;
\$green: $green;
\$yellow: $yellow;
\$blue: $blue;
\$magenta: $magenta;
\$cyan: $cyan;

\$archicon: $archicon;
EOF

echo "Tema cambiado a: $THEME"

if ! pgrep -x eww; then 
  eww daemon 
fi 


eww reload
