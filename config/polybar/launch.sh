#!/usr/bin/env sh

## Add this to your wm startup file.

# Terminate already running bar instances
killall -q polybar

## Wait until the processes have been shut down
#while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

## Launch

## Left bar
polybar log -c ~/.config/polybar/current.ini &
#polybar secondary -c ~/.config/polybar/current.ini &

## Right bar
#polybar top -c ~/.config/polybar/current.ini &
polybar primary -c ~/.config/polybar/current.ini &
polybar ethernet_status -c ~/.config/polybar/current.ini &
#polybar memory_status -c ~/.config/polybar/current.ini &

polybar vpn_status -c ~/.config/polybar/current.ini & 
polybar target_to_hack -c ~/.config/polybar/current.ini &

## Center bar
polybar primary -c ~/.config/polybar/workspace.ini &
polybar date -c ~/.config/polybar/current.ini &
polybar updates -c ~/.config/polybar/current.ini &

sleep 0.5
polybar principal_bar -c ~/.config/polybar/current.ini &  
