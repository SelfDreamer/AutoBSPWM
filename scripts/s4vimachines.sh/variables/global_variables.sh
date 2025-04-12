#!/usr/bin/env bash
# Variables globales
export url='https://infosecmachines.io/api/machines'
PATH_ARCHIVE='/tmp/bundle.js'
TMP_ARCHIVE='/tmp/bundle.js.tmp'
declare -i parameter_counter=0
verbose_mode=false
confirm_act=false
help=false
results="/tmp/results.tmp"
htb_results="/tmp/htb_results"
vulnhub_results="/tmp/vulnhub_results"
exclude_banner=false
browser='firefox'
open_browser=false
show_output_translate=false
language='en'
target_os=0
target_difficulty=0
