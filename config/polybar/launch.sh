#!/usr/bin/env bash
# =============================================================
# ░█▀█░█▀█░█░░░█░█░█▀▄░█▀█░█▀▄
# ░█▀▀░█░█░█░░░░█░░█▀▄░█▀█░█▀▄
# ░▀░░░▀▀▀░▀▀▀░░▀░░▀▀░░▀░▀░▀░▀
# Author: FlickGMD 
# Repo: https://github.com/FlickGMD/AutoBSPWM
# Date: 2025-06-22 16:06:10
# =============================================================

killall -q polybar

{ while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done } 

# ░█▀▄░▀█▀░█▀▀░█░█░▀█▀░░░█▄█░█▀█░█▀▄░█░█░█░░░█▀▀░█▀▀
# ░█▀▄░░█░░█░█░█▀█░░█░░░░█░█░█░█░█░█░█░█░█░░░█▀▀░▀▀█
# ░▀░▀░▀▀▀░▀▀▀░▀░▀░░▀░░░░▀░▀░▀▀▀░▀▀░░▀▀▀░▀▀▀░▀▀▀░▀▀▀
polybar log -c ~/.config/polybar/current.ini &
polybar ethernet_status -c ~/.config/polybar/current.ini &
polybar vpn_status -c ~/.config/polybar/current.ini & 

# ░█░█░█▀█░█▀▄░█░█░█▀▀░█▀█░█▀█░█▀▀░█▀▀░█▀▀
# ░█▄█░█░█░█▀▄░█▀▄░▀▀█░█▀▀░█▀█░█░░░█▀▀░▀▀█
# ░▀░▀░▀▀▀░▀░▀░▀░▀░▀▀▀░▀░░░▀░▀░▀▀▀░▀▀▀░▀▀▀
polybar primary -c ~/.config/polybar/workspace.ini &

# ░█░░░█▀▀░█▀▀░▀█▀░░░█▀▄░█▀█░█▀▄
# ░█░░░█▀▀░█▀▀░░█░░░░█▀▄░█▀█░█▀▄
# ░▀▀▀░▀▀▀░▀░░░░▀░░░░▀▀░░▀░▀░▀░▀
polybar updates -c ~/.config/polybar/current.ini &
polybar date -c ~/.config/polybar/current.ini &
polybar target_to_hack -c ~/.config/polybar/current.ini &
polybar primary -c ~/.config/polybar/current.ini &

# ░█▀▀░█▀█░█▀█░▀█▀░█▀█░▀█▀░█▀█░█▀▀░█▀▄░░░█▀▀░█▀▄░█▀█░█▄█░█▀▀
# ░█░░░█░█░█░█░░█░░█▀█░░█░░█░█░█▀▀░█▀▄░░░█▀▀░█▀▄░█▀█░█░█░█▀▀
# ░▀▀▀░▀▀▀░▀░▀░░▀░░▀░▀░▀▀▀░▀░▀░▀▀▀░▀░▀░░░▀░░░▀░▀░▀░▀░▀░▀░▀▀▀
sleep 0.5
polybar principal_bar -c ~/.config/polybar/current.ini &  
