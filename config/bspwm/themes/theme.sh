#!/bin/bash
readonly ruta="$(realpath "${0}" | rev | cut -d'/' -f2- | rev)"
cd "${ruta}" || exit 1 

# ==============================================================================
# Script: change_theme.sh (v10 - System Wide Final - Updated Colors)
# ==============================================================================

# --- CONFIGURACIÓN DE RUTAS ---
THEME=$1
JSON_FILE="$HOME/.config/bspwm/themes/polybar.json"
WORKSPACE_FILE="$HOME/.config/polybar/workspace.ini"
CURRENT_FILE="$HOME/.config/polybar/current.ini"
SCRIPTS_DIR="$HOME/.config/bspwm/scripts"
BSPWM_FILE="$HOME/.config/bspwm/bspwmrc"
LSD_THEMES_DIR="$HOME/.config/lsd/themes"
LSD_CONFIG_FILE="$HOME/.config/lsd/colors.yaml"
BAT_CONFIG_FILE="$HOME/.config/bat/config"

# --- VALIDACIONES ---
if [ -z "$THEME" ]; then
    echo "❌ Uso: $0 [latte | frappe | macchiato | mocha | default]"
    exit 1
fi

# Actualizado para aceptar 'default'
if [[ ! "$THEME" =~ ^(latte|frappe|macchiato|mocha|default)$ ]]; then
    echo "❌ Error: Tema no válido."
    exit 1
fi

if ! command -v jq &> /dev/null; then
    echo "❌ Error: Se requiere 'jq'. Instálalo con: sudo pacman -S jq"
    exit 1
fi

echo "🎨 Aplicando tema: $THEME..."

# ==============================================================================
# 1. POLYBAR (Lectura desde JSON)
# ==============================================================================

# 1.1 Módulos en workspace.ini
KEYS=$(jq -r ".$THEME.\"workspaces.ini\".modules.workspaces | keys[]" "$JSON_FILE" 2>/dev/null)
if [ -n "$KEYS" ]; then
    for KEY in $KEYS; do
        VALUE=$(jq -r ".$THEME.\"workspaces.ini\".modules.workspaces.\"$KEY\".hexadecimal" "$JSON_FILE")
        if [ "$VALUE" != "null" ]; then
            sed -i -E "/^\[module\/workspaces\]/,/^\[/ s/^($KEY\s*=\s*).*/\1$VALUE/" "$WORKSPACE_FILE"
        fi
    done
fi

# 1.2 Barras en workspace.ini
BARS_WS=$(jq -r ".$THEME.\"workspaces.ini\".bar | keys[]" "$JSON_FILE" 2>/dev/null)
if [ -n "$BARS_WS" ]; then
    for BAR_NAME in $BARS_WS; do
        PROPS=$(jq -r ".$THEME.\"workspaces.ini\".bar.\"$BAR_NAME\" | keys[]" "$JSON_FILE")
        for PROP in $PROPS; do
            VALUE=$(jq -r ".$THEME.\"workspaces.ini\".bar.\"$BAR_NAME\".\"$PROP\".hexadecimal" "$JSON_FILE")
            if [ "$VALUE" != "null" ]; then
                sed -i -E "/^\[bar\/$BAR_NAME\]/,/^\[/ s/^($PROP\s*=\s*).*/\1$VALUE/" "$WORKSPACE_FILE"
            fi
        done
    done
fi

# 1.3 Barras en current.ini
BARS_CUR=$(jq -r ".$THEME.\"current.ini\".bar | keys[]" "$JSON_FILE" 2>/dev/null)
if [ -n "$BARS_CUR" ]; then
    for BAR_NAME in $BARS_CUR; do
        PROPS=$(jq -r ".$THEME.\"current.ini\".bar.\"$BAR_NAME\" | keys[]" "$JSON_FILE")
        for PROP in $PROPS; do
            VALUE=$(jq -r ".$THEME.\"current.ini\".bar.\"$BAR_NAME\".\"$PROP\".hexadecimal" "$JSON_FILE")
            if [ "$VALUE" != "null" ]; then
                sed -i -E "/^\[bar\/$BAR_NAME\]/,/^\[/ s/^($PROP\s*=\s*).*/\1$VALUE/" "$CURRENT_FILE"
            fi
        done
    done
fi

# ==============================================================================
# 2. DEFINICIÓN DE COLORES (Para Scripts y BSPWM)
# ==============================================================================

declare -A COLORS

case $THEME in
    latte)
        COLORS[TEXT]="#4c4f69"; COLORS[GREEN]="#40a02b"; COLORS[RED]="#d20f39"
        COLORS[OVERLAY0]="#7c7f93"; COLORS[OVERLAY1]="#8c8fa1"; COLORS[LAVENDER]="#7287fd"
        COLORS[BASE]="#eff1f5"
        ;;
    frappe)
        COLORS[TEXT]="#c6d0f5"; COLORS[GREEN]="#a6d189"; COLORS[RED]="#e78284"
        COLORS[OVERLAY0]="#737994"; COLORS[OVERLAY1]="#838ba7"; COLORS[LAVENDER]="#babbf1"
        COLORS[BASE]="#303446"
        ;;
    macchiato)
        COLORS[TEXT]="#cad3f5"; COLORS[GREEN]="#a6da95"; COLORS[RED]="#ed8796"
        COLORS[OVERLAY0]="#6e738d"; COLORS[OVERLAY1]="#8087a2"; COLORS[LAVENDER]="#b7bdf8"
        COLORS[BASE]="#24273a"
        ;;
    mocha)
        COLORS[TEXT]="#cdd6f4"; COLORS[GREEN]="#a6e3a1"; COLORS[RED]="#f38ba8"
        COLORS[OVERLAY0]="#6c7086"; COLORS[OVERLAY1]="#7f849c"; COLORS[LAVENDER]="#b4befe"
        COLORS[BASE]="#1e1e2e"
        ;;
    default)
        COLORS[TEXT]="#ffffff"   # Blanco
        COLORS[GREEN]="#1bbf3e"  # Verde Hacker
        COLORS[RED]="#e51d0b"    # Rojo
        COLORS[OVERLAY0]="#6C757D" # Gris desconectado
        COLORS[OVERLAY1]="#888888" # Gris fecha
        COLORS[LAVENDER]="#C2F6FC" # Cyan (Focused Border)
        COLORS[BASE]="#1e1e2e"   # Fondo Oscuro Original
        ;;
esac

# ==============================================================================
# 3. SCRIPTS BASH & ICONOS POLYBAR
# ==============================================================================

echo " -> [Scripts] Actualizando scripts en $SCRIPTS_DIR..."

update_script_var() {
    local file="$SCRIPTS_DIR/$1"
    local var_name="$2"
    local new_color="${COLORS[$3]}"
    if [ -f "$file" ]; then
        sed -i -E "s/^($var_name=\").*(\")/\1$new_color\2/" "$file"
    fi
}

update_script_var "vpn_status" "GREEN" "GREEN" 2>/dev/null 
update_script_var "vpn_status" "TEXT" "TEXT" 2>/dev/null 
update_script_var "vpn_status" "OVERLAY0" "OVERLAY0" 2>/dev/null 
update_script_var "ethernet_status" "GREEN" "GREEN" 2>/dev/null 
update_script_var "ethernet_status" "TEXT" "TEXT" 2>/dev/null 
update_script_var "ethernet_status" "RED" "RED" 2>/dev/null 
update_script_var "results.sh" "TEXT" "TEXT" 2>/dev/null 
update_script_var "target_to_hack" "RED" "RED" 2>/dev/null 
update_script_var "target_to_hack" "TEXT" "TEXT" 2>/dev/null 
update_script_var "calendar.sh" "OVERLAY1" "OVERLAY1" 2>/dev/null 
update_script_var "calendar.sh" "TEXT" "TEXT" 2>/dev/null

# Iconos especiales en current.ini (Update y Calendar)
sed -i -E "/^\[module\/update\]/,/^\[/ s/(%\{F)#[0-9a-fA-F]{6}(})/\1${COLORS[GREEN]}\2/" "$CURRENT_FILE" 2>/dev/null 
sed -i -E "/^\[module\/calendar\]/,/^\[/ s/(%\{F)#[0-9a-fA-F]{6}(})/\1${COLORS[TEXT]}\2/" "$CURRENT_FILE" 2>/dev/null 

# ==============================================================================
# 4. BSPWM
# ==============================================================================

echo " -> [BSPWM] Actualizando bordes..."
if [ -f "$BSPWM_FILE" ]; then
    sed -i -E "s/^(focused_color=\").*(\")/\1${COLORS[LAVENDER]}\2/" "$BSPWM_FILE"
    sed -i -E "s/^(normal_color=\").*(\")/\1${COLORS[BASE]}\2/" "$BSPWM_FILE"
    bspc config focused_border_color "${COLORS[LAVENDER]}"
    bspc config normal_border_color "${COLORS[BASE]}"
else
    echo "⚠️ No se encontró bspwmrc."
fi

# ==============================================================================
# 6. LSD
# ==============================================================================

echo " -> [LSD] Actualizando tema..."
if [[ "${1}" == "default" ]]; then 
  rm ~/.config/lsd/colors.yaml
else 
  SOURCE_LSD="$LSD_THEMES_DIR/catppuccin-$THEME/colors.yaml"
  if [ -f "$SOURCE_LSD" ]; then
      cp -f "$SOURCE_LSD" "$LSD_CONFIG_FILE"
  else
      echo "⚠️ No se encontró tema LSD: $SOURCE_LSD"
  fi
fi 

# ==============================================================================
# 7. BAT
# ==============================================================================

echo " -> [Bat] Configurando tema..."

# Crea el directorio si no existe (dirname toma la carpeta padre de BAT_CONFIG_FILE)
mkdir -p "$(dirname "$BAT_CONFIG_FILE")"

# Capitaliza la primera letra (latte -> Latte)
THEME_CAP="${THEME^}" 
BAT_THEME_NAME="Catppuccin $THEME_CAP"

if [[ "${1}" == "default" ]]; then 
  BAT_THEME_NAME=""
fi 

# Crea o actualiza el archivo config
if [ ! -f "$BAT_CONFIG_FILE" ]; then
    echo "--theme=\"$BAT_THEME_NAME\"" > "$BAT_CONFIG_FILE"
else
    # Si existe y tiene --theme, lo reemplaza
    if grep -q "^--theme=" "$BAT_CONFIG_FILE"; then
        sed -i "s/^--theme=.*/--theme=\"$BAT_THEME_NAME\"/" "$BAT_CONFIG_FILE"
    else
        # Si existe pero no tiene --theme, lo agrega
        echo "--theme=\"$BAT_THEME_NAME\"" >> "$BAT_CONFIG_FILE"
    fi
fi

echo " -> [ZSHRC] Configurando tema..."
sed -E "s/THEME=(:?['\"])([A-Za-z]+)(:?['\"])$/THEME=\"${THEME}\"/" -i ~/.zshrc

echo " -> [KITTY] Configurando la kitty..."
sed -iE "s/include themes\/.*/include themes\/${THEME}.conf/g" ~/.config/kitty/kitty.conf

CONFIG="$HOME/.config/kitty/kitty.conf"
function get_sockets(){
  SOCKET_PREFIX=$(grep -oP "listen_on unix:\K.*" "${CONFIG}")
  if [[ "${SOCKET_PREFIX}" ]]; then
    find /tmp -type s -path "${SOCKET_PREFIX}*" -user "${USER}" 2>/dev/null 
  fi 
}

while IFS= read -r socket; do 
  kitty @ --to "unix:$socket" set-colors --all "${HOME}/.config/kitty/themes/${THEME}.conf" 2>/dev/null >&1 
done < <(get_sockets)

# Discomment that if un wanna send commands and exec 
#while IFS= read -r socket; do
 #  kitten @ --to unix:"${socket}" send-text "source ~/.zshrc && exec zsh\x0d" 
#done < <(get_sockets)



# Temas de wallpapers 
sed -E "s/^THEME=[\"'](.*)[\"']/THEME=\"${THEME_CAP}\"/" -i ~/.config/rofi/Selector/selector.sh
sed -E "s/^THEME=[\"'](.*)[\"']/THEME=\"${THEME}\"/" -i ~/.config/bspwm/bspwmrc
feh --bg-fill $HOME/Imágenes/wallpapers/Themes/${THEME_CAP}/Wallpaper.jpg
# JGMenu Tema Catppuccin
cp "${HOME}"/.config/jgmenu/themes/"${THEME}"/jgmenurc "${HOME}"/.config/jgmenu/jgmenurc

# eww Catppuccin theme 
FILE="$HOME/.config/eww/colors.scss"

# Definir colores según el tema
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
esac

# Reescribimos el archivo colors.scss completo
# Esto es más rápido y seguro que sed
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

echo " -> [EWW] Tema cambiado a: $THEME"

if ! pgrep -x eww &>/dev/null; then 
  eww daemon 
fi 


# Recargar eww para aplicar cambios
eww reload

# P10k 
echo " -> [POWERLEVEL10K] Tema cambiado a: ${THEME}"
cp "${HOME}"/p10k-themes/"${THEME}"/.p10k.zsh "${HOME}"/.p10k.zsh

echo " -> [POLYBAR SCRIPTS] Tema cambiado a: ${THEME}"

# Archivo objetivo (Ajusta la ruta si es necesario)
FILE="$HOME/.config/polybar/scripts/powermenu.rasi"

case $THEME in
    mocha)
        # Catppuccin Mocha
        bg="#1e1e2e"        # Base
        bg_alt="#181825"    # Mantle (un poco más oscuro para contraste)
        line="#313244"      # Surface0 (para bordes sutiles)
        fg="#cdd6f4"        # Text
        comment="#585b70"   # Surface2
        selected="#fab387"  # Peach (mantiene ese tono naranja/seleccionado)
        pink="#f5c2e7"      # Pink
        purple="#cba6f7"    # Mauve (El púrpura de Catppuccin)
        ;;
    macchiato)
        # Catppuccin Macchiato
        bg="#24273a"
        bg_alt="#1e2030"
        line="#363a4f"
        fg="#cad3f5"
        comment="#5b6078"
        selected="#f5a97f"
        pink="#f5bde6"
        purple="#c6a0f6"
        ;;
    frappe)
        # Catppuccin Frappe
        bg="#303446"
        bg_alt="#292c3c"
        line="#414559"
        fg="#c6d0f5"
        comment="#626880"
        selected="#ef9f76"
        pink="#f4b8e4"
        purple="#ca9ee6"
        ;;
    latte)
        # Catppuccin Latte (Tema Claro)
        bg="#eff1f5"
        bg_alt="#e6e9ef"    # Mantle
        line="#ccd0da"      # Surface0
        fg="#4c4f69"        # Text
        comment="#acb0be"
        selected="#fe640b"  # Peach (Naranja vibrante para light mode)
        pink="#ea76cb"
        purple="#8839ef"    # Mauve
        ;;
    default)
        # Tu tema original (Dracula-ish)
        bg="#1B1B27"
        bg_alt="#282a36"
        line="#44475a"
        fg="#f8f8f2"
        comment="#6272a4"
        selected="#ffb86c"
        pink="#ff79c6"
        purple="#bd93f9"
        ;;
    *)
        echo "Error: Tema '$1' no reconocido."
        echo "Opciones: mocha, macchiato, frappe, latte, default"
        exit 1
        ;;
esac

# -----------------------------------------------------------------------------
# 2. Reescritura del archivo powermenu.rasi
# -----------------------------------------------------------------------------

cat > "$FILE" <<EOF
/* Tema aplicado: $THEME */

configuration {
    transparency: "real";
    location: 0;
    font: "Font Awesome 30";
    opacity: 1000;
}

* {
    border: 0;
    margin: 0;
    padding: 0;
    spacing: 0;
    
    /* Paleta de colores dinamica */
    background:     $bg;
    background-alt: $bg_alt;
    line:           $line;
    foreground:     $fg;
    foreground-alt: $fg;
    Comment:        $comment;
    selected:       $selected;
    Pink:           $pink;
    purple:         $purple;
    
    background-color: @background;
    text-color:       @purple;
}

window {
    background-color: @background;
    border:           2px;
    border-color:     @line;
    border-radius:    50px;
    width:            490px;
    height:           130px;
    x-offset:         -4;
    y-offset:         0;
}

listview {
    background-color: @background;
    columns:          1;
    lines:            5;
    spacing:          60px;
    layout:           horizontal;
}

mainbox {
    background-color: @background;
    children:         [ listview ];
    padding:          40px;
}

element {
    background-color: @background;
    text-color:       @line;
    orientation:      horizontal;
}

element-text {
    background-color: inherit;
    text-color:       inherit;
    font:             "Font Awesome 25";
    expand:           false;
    horizontal-align: 0.5;
    vertical-align:   0.5;
    margin:           0px;
}

element selected {
    background-color: @background;
    text-color:       @purple;
    border:           0px;
    border-color:     @selected;
}
EOF

POWERMENU_ALT="$HOME/.config/polybar/scripts/powermenu_alt/powermenu.rasi"

case $THEME in
    mocha)
        # Catppuccin Mocha
        bg="#1e1e2e"        # Base
        fg="#cdd6f4"        # Text
        primary="#cba6f7"   # Mauve
        secondary="#585b70" # Surface2
        urgent="#f38ba8"    # Red
        ;;
    macchiato)
        # Catppuccin Macchiato
        bg="#24273a"
        fg="#cad3f5"
        primary="#c6a0f6"
        secondary="#5b6078"
        urgent="#ed8796"
        ;;
    frappe)
        # Catppuccin Frappe
        bg="#303446"
        fg="#c6d0f5"
        primary="#ca9ee6"
        secondary="#626880"
        urgent="#e78284"
        ;;
    latte)
        # Catppuccin Latte (Claro)
        bg="#eff1f5"
        fg="#4c4f69"
        primary="#8839ef"
        secondary="#acb0be" # Surface2
        urgent="#d20f39"
        ;;
    default)
        # Tu configuración original (Nord/Dracula mix)
        bg="#282A36"
        fg="#D8DEE9"
        primary="#BD93F9"
        secondary="#3B4252"
        urgent="#BF616A"
        ;;
esac

# Generamos la versión transparente añadiendo "D0" al final del hex
# D0 equivale a ~80% de opacidad.
bg_trans="${bg}D0"

# -----------------------------------------------------------------------------
# 2. Reescritura del archivo
# -----------------------------------------------------------------------------

cat > "$POWERMENU_ALT" <<EOF
@import "keybinds.rasi"

* {
    background-color:       transparent;
    background:             $bg;
    background-transparent: $bg_trans;
    text-color:             $fg;
    primary:                $primary;
    secondary:              $secondary;
    urgent:                 $urgent;
}

configuration {
    font:                   "Hack Nerd Font 30";
}

window {
    width:                  100%;
    height:                 100%;
    background-color:       @background-transparent;
    transparency:           "real";
    children:               [dummy, listview, dummy];
}

listview {
    lines:                  5;
    layout:                 horizontal;
    children:               [element];
    margin:                 120px 0px 0px 750px; 
    // margin:              arriba abajo derecha izquierda
}

element {
    children:               [element-text];
    padding:                15px 40px;
    border-color:           @primary;
    border-radius:          20px;
}

element-text {
    text-color:             inherit;
    margin:                 15px 0 0 0;
}

element.selected {
    text-color:             @background;
    background-color:       @primary;
}
EOF

POWERMENU_ALT_2="$HOME/.config/polybar/scripts/powermenu_alt_2/ef-trio-dark.rasi"

case $THEME in
    mocha)
        # Catppuccin Mocha
        bg="#1e1e2e"        # Base
        bg_alt="#313244"    # Surface0
        fg="#cdd6f4"        # Text
        selected="#cba6f7"  # Mauve (Color de acento)
        selected_fg="#1e1e2e" # Base (Para contraste sobre el acento)
        active="#a6e3a1"    # Green
        urgent="#f38ba8"    # Red
        comment="Catppuccin Mocha"
        ;;
    macchiato)
        # Catppuccin Macchiato
        bg="#24273a"
        bg_alt="#363a4f"
        fg="#cad3f5"
        selected="#c6a0f6"
        selected_fg="#24273a"
        active="#a6da95"
        urgent="#ed8796"
        comment="Catppuccin Macchiato"
        ;;
    frappe)
        # Catppuccin Frappe
        bg="#303446"
        bg_alt="#414559"
        fg="#c6d0f5"
        selected="#ca9ee6"
        selected_fg="#303446"
        active="#a6d189"
        urgent="#e78284"
        comment="Catppuccin Frappe"
        ;;
    latte)
        # Catppuccin Latte (Claro)
        bg="#eff1f5"
        bg_alt="#ccd0da"
        fg="#4c4f69"
        selected="#8839ef"  # Mauve
        selected_fg="#eff1f5" # Base claro
        active="#40a02b"    # Green
        urgent="#d20f39"    # Red
        comment="Catppuccin Latte"
        ;;
    default)
        # Ef-Trio-Dark Original
        bg="#160f0f"
        bg_alt="#2a2228"
        fg="#d8cfd5"
        selected="#6a294f"
        selected_fg="#ffdfdf"
        active="#60b444"
        urgent="#f48359"
        comment="Ef-Trio-Dark (Default)"
        ;;
    *)
        echo "Tema no reconocido."
        exit 1
        ;;
esac

# Reescribimos el archivo ef-trio-dark.rasi
cat > "$POWERMENU_ALT_2" <<EOF
/* Theme: $comment */
* {
    background:     $bg;
    background-alt: $bg_alt;
    foreground:     $fg;
    selected:       $selected;
    selected-fg:    $selected_fg;
    active:         $active;
    urgent:         $urgent;
}
EOF

echo " -> [ROFI SELECTOR] Cambiando tema a: ${THEME}"

case $THEME in
    mocha)
        # Catppuccin Mocha
        bg="#1e1e2e"        # Base
        bg_alt="#45475a"    # Surface1 (Un poco más claro que base para contraste)
        fg="#cdd6f4"        # Text
        selected="#cba6f7"  # Mauve (Color de acento)
        active="#a6e3a1"    # Green
        urgent="#f38ba8"    # Red
        ;;
    macchiato)
        # Catppuccin Macchiato
        bg="#24273a"
        bg_alt="#494d64"    # Surface1
        fg="#cad3f5"
        selected="#c6a0f6"
        active="#a6da95"
        urgent="#ed8796"
        ;;
    frappe)
        # Catppuccin Frappe
        bg="#303446"
        bg_alt="#51576d"    # Surface1
        fg="#c6d0f5"
        selected="#ca9ee6"
        active="#a6d189"
        urgent="#e78284"
        ;;
    latte)
        # Catppuccin Latte (Claro)
        bg="#eff1f5"
        bg_alt="#bcc0cc"    # Surface1
        fg="#4c4f69"
        selected="#8839ef"  # Mauve
        active="#40a02b"    # Green
        urgent="#d20f39"    # Red
        ;;
    default)
        # Valores Originales (Aditya Shakya Theme)
        bg="#0b0d16"
        bg_alt="#39404f"
        fg="#D8DEE9"
        selected="#ca3c75"
        active="#A3BE8C"
        urgent="#BF616A"
        ;;
    *)
        echo "Tema no reconocido."
        exit 1
        ;;
esac

ROFI_SELECTOR="$HOME/.config/rofi/colors.rasi"

# Reescribimos el archivo
cat > "${ROFI_SELECTOR}" <<EOF
/* Copyright (C) 2020-2022 Aditya Shakya <adi1090x@gmail.com> */
/* Colors - Theme: $THEME */

* {
    background:     $bg;
    background-alt: $bg_alt;
    foreground:     $fg;
    selected:       $selected;
    active:         $active;
    urgent:         $urgent;
}
EOF

light_rasi="${HOME}/.config/polybar/scripts/ThemeSelector/confirm/light.rasi"

case $THEME in
    mocha)
        # Catppuccin Mocha (Oscuro)
        bg="#1e1e2e"
        bg_alt="#313244"      # Surface0
        fg="#cdd6f4"
        selected="#cba6f7"    # Mauve
        selected_fg="#1e1e2e" # Texto oscuro sobre el acento
        active="#a6e3a1"      # Green
        urgent="#f38ba8"      # Red
        comment="Catppuccin Mocha"
        ;;
    macchiato)
        # Catppuccin Macchiato (Oscuro medio)
        bg="#24273a"
        bg_alt="#363a4f"
        fg="#cad3f5"
        selected="#c6a0f6"
        selected_fg="#24273a"
        active="#a6da95"
        urgent="#ed8796"
        comment="Catppuccin Macchiato"
        ;;
    frappe)
        # Catppuccin Frappe (Oscuro suave)
        bg="#303446"
        bg_alt="#414559"
        fg="#c6d0f5"
        selected="#ca9ee6"
        selected_fg="#303446"
        active="#a6d189"
        urgent="#e78284"
        comment="Catppuccin Frappe"
        ;;
    latte)
        # Catppuccin Latte (Claro - El único claro)
        bg="#eff1f5"
        bg_alt="#ccd0da"
        fg="#4c4f69"
        selected="#8839ef"    # Mauve
        selected_fg="#eff1f5" # Texto claro sobre acento oscuro
        active="#40a02b"
        urgent="#d20f39"
        comment="Catppuccin Latte"
        ;;
    default)
        # Default CUSTOM (Oscuro, NO BLANCO como pediste)
        # Basado en un tono gris muy oscuro azulado agradable
        bg="#0f111a"
        bg_alt="#202636"
        fg="#a9b1d6"
        selected="#7aa2f7"    # Azul Tokyo Night
        selected_fg="#0f111a"
        active="#9ece6a"
        urgent="#f7768e"
        comment="Default (Dark Custom)"
        ;;
    *)
        echo "Tema no reconocido."
        exit 1
        ;;
esac

# Reescribimos el archivo
cat > "${light_rasi}" <<EOF
/* Colors - Theme: $comment */
* {
    background:     $bg;
    background-alt: $bg_alt;
    foreground:     $fg;
    selected:       $selected;
    selected-fg:    $selected_fg;
    active:         $active;
    urgent:         $urgent;
}
EOF

# Dunst 
echo " -> [DUNST] Cambiando tema a: ${THEME}"

DUNST_CONF="$HOME/.config/dunst/dunstrc"

case $THEME in
    mocha)
        # Catppuccin Mocha
        bg="#1e1e2e"        # Base
        fg="#cdd6f4"        # Text
        frame="#cba6f7"     # Mauve (Normal)
        low_frame="#45475a" # Surface1
        crit_frame="#f38ba8" # Red
        crit_bg="#1e1e2e"   # Base (o Surface0 #313244 si quieres contraste)
        crit_fg="#f38ba8"   # Red Text
        ;;
    macchiato)
        # Catppuccin Macchiato
        bg="#24273a"
        fg="#cad3f5"
        frame="#c6a0f6"
        low_frame="#494d64"
        crit_frame="#ed8796"
        crit_bg="#24273a"
        crit_fg="#ed8796"
        ;;
    frappe)
        # Catppuccin Frappe
        bg="#303446"
        fg="#c6d0f5"
        frame="#ca9ee6"
        low_frame="#51576d"
        crit_frame="#e78284"
        crit_bg="#303446"
        crit_fg="#e78284"
        ;;
    latte)
        # Catppuccin Latte (Claro)
        bg="#eff1f5"
        fg="#4c4f69"
        frame="#8839ef"     # Mauve
        low_frame="#bcc0cc" # Surface1
        crit_frame="#d20f39" # Red
        crit_bg="#eff1f5"
        crit_fg="#d20f39"
        ;;
    default)
        # Tu configuración original (Parece Rose-Pine)
        bg="#1f1d2e"
        fg="#e0def4"
        frame="#c4a7e7"
        low_frame="#161320"
        crit_frame="#f38ba8"
        crit_bg="#302d41"
        crit_fg="#f38ba8"
        ;;
    *)
        echo "Tema no reconocido."
        exit 1
        ;;
esac

# -----------------------------------------------------------------------------
# 2. Reescritura de dunstrc
# -----------------------------------------------------------------------------

cat > "$DUNST_CONF" <<EOF
# Configuración generada por dunst_theme.sh
# Tema aplicado: $THEME

[global]
    monitor = 0
    follow = mouse
    width = 300
    height = 100
    offset = (20, 20)
    scale = 0
    origin = bottom-right
    notification_limit = 0
    padding = 20
    horizontal_padding = 80
    frame_width = 2
    
    # Color del marco por defecto (se sobrescribe en urgency)
    frame_color = "$frame"
    
    separator_color = frame
    separator_height = 2
    transparency = 30
    corner_radius = 15

    font = JetBrainsMono Nerd Font 10
    markup = full
    format = "%s %b"
    alignment = left
    vertical_alignment = center
    word_wrap = yes
    ignore_newline = no
    stack_duplicates = false
    hide_duplicate_count = true

    show_indicators = false
    indicate_hidden = yes
    shrink = no

    idle_threshold = 120
    fullscreen = show
    show_age_threshold = 60
    history_length = 20

    # Time settings
    timeout = 8
    min_timeout = 1
    max_timeout = 10

    # Icons
    icon_position = off
    enable_recursive_icon_lookup = false

    # Progress bar
    progress_bar = true
    progress_bar_height = 6
    progress_bar_frame_width = 1
    progress_bar_min_width = 150
    progress_bar_max_width = 300

[urgency_low]
    background = "$bg"
    foreground = "$fg"
    frame_color = "$low_frame"
    timeout = 6

[urgency_normal]
    background = "$bg"
    foreground = "$fg"
    frame_color = "$frame"
    timeout = 8

[urgency_critical]
    background = "$crit_bg"
    foreground = "$crit_fg"
    frame_color = "$crit_frame"
    timeout = 0
EOF

kill $(timeout 2  dunst 2>&1 | grep -oP "with PID \K'(.*)'"  | tr -d "'")
pidof -q dunst || dunst & >/dev/null 


# -----------------------------------------------------------------------------
# 3. Recargar Dunst
# -----------------------------------------------------------------------------

echo "Tema '$THEME' aplicado a $DUNST_CONF"

# Matamos el proceso actual para forzar la recarga
# Dunst se reiniciará automáticamente al recibir la siguiente notificación
# o por el servicio de dbus.
killall dunst 2>/dev/null

# Opcional: Enviar notificación de prueba
notify-send -t 1200 "Tema cambiado" "Aplicado: $THEME" -u normal

# rofi_theme_selector
echo " -> [ROFI THEME SELECTOR] Aplicando tema a rofi"

SHARED_RASI="$HOME/.config/bspwm/themes/shared.rasi" 

# Ruta de la imagen (La extraje de tu ejemplo para mantenerla)
WALLPAPER='url("~/Imágenes/wallpapers/HTB.jpg", width)'
FONT='JetBrainsMono NF Bold 9'

case $THEME in
    mocha)
        # Catppuccin Mocha
        bg="#1e1e2e"
        fg="#cdd6f4"
        selected="#89b4fa"  # Blue
        active="#a6e3a1"    # Green
        urgent="#f38ba8"    # Red
        ;;
    macchiato)
        # Catppuccin Macchiato
        bg="#24273a"
        fg="#cad3f5"
        selected="#8aadf4"
        active="#a6da95"
        urgent="#ed8796"
        ;;
    frappe)
        # Catppuccin Frappe
        bg="#303446"
        fg="#c6d0f5"
        selected="#8caaee"
        active="#a6d189"
        urgent="#e78284"
        ;;
    latte)
        # Catppuccin Latte
        bg="#eff1f5"
        fg="#4c4f69"
        selected="#1e66f5"  # Blue
        active="#40a02b"    # Green
        urgent="#d20f39"    # Red
        ;;
    default)
        # Tokyo Night (Tu original)
        bg="#1A1B26"
        fg="#c0caf5"
        selected="#7aa2f7"
        active="#9ece6a"
        urgent="#f7768e"
        ;;
    *)
        echo "Tema no reconocido."
        exit 1
        ;;
esac

# Generamos el background-alt añadiendo transparencia (E0 = ~88% opacidad)
bg_alt="${bg}E0"

# Reescribimos el archivo
cat > "${SHARED_RASI}" <<EOF
* {
    font:           "$FONT";
    background:     $bg;
    background-alt: $bg_alt;
    foreground:     $fg;
    selected:       $selected;
    active:         $active;
    urgent:         $urgent;
    img-background: $WALLPAPER;
}
EOF

WALL_SHARED_RASI="$HOME/.config/rofi/Selector/shared.rasi"
cat > "${WALL_SHARED_RASI}" <<EOF
* {
    font:           "$FONT";
    background:     $bg;
    background-alt: $bg_alt;
    foreground:     $fg;
    selected:       $selected;
    active:         $active;
    urgent:         $urgent;
    img-background: $WALLPAPER;
}
EOF


echo "Tema '$THEME' aplicado a $ROFI_SELECTOR"

# ==============================================================================
# FINALIZACIÓN
# ==============================================================================
#
#

echo "✅ Tema '$THEME' aplicado completamente."
echo "🔄 Reiniciando Polybar..."

/usr/bin/kitter --load-config ~/.config/kitty/kitty.conf --all-sockets  
/usr/bin/kitter --load-config ~/.config/kitty/kitty.conf --all-sockets  


killall -q polybar
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done
pkill -USR1 -x kitty

if [ -f "$HOME/.config/polybar/launch.sh" ]; then
  ( bash "$HOME/.config/polybar/launch.sh" &>/dev/null & ) &>/dev/null 
else
    polybar-msg cmd restart
fi

exit 0
