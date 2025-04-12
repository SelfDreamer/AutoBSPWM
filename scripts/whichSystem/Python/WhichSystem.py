#!/usr/bin/env python
from signal import SIGINT, signal
import sys, subprocess, re
from Colors import *

# Funciones para el cursor
def disable_cursor():
    sys.stdout.write("\033[?25l")
    sys.stdout.flush()

def enable_cursor():
     sys.stdout.write("\033[?25h")
     sys.stdout.flush()


def handler(signal, frame):

    print(f"\n\n{bright_red}[!] Deteniendo programa...{end}\n"); enable_cursor()
    sys.exit(1)

signal(SIGINT, handler=handler)


def Get_OS(ttl):

    if ttl >= 1 and ttl <= 64:
        return f"\n\n{bright_cyan}[+] {bright_magenta}{sys.argv[1]}{bright_white} (ttl -> {ttl}):{bright_green} Linux{end}\n"
    elif ttl >= 65 and ttl <= 128:
        return f"\n\n{bright_cyan}[+] {bright_magenta}{sys.argv[1]}{bright_white} (ttl -> {ttl}):{bright_green} Windows{end}\n"
    else:
        return f"\n\n{bright_cyan}[+] {bright_magenta}{sys.argv[1]}{bright_white} (ttl -> {ttl}):{bright_red} Desconocido{end}\n"

def Get_TTL(stdout):
    
    pattern = r'ttl=\d{1,3}'
    match = re.search(pattern=pattern, string=stdout)

    if (match):
        ttl = match.group(0).replace('ttl=', '')
        return int(ttl)
    
    enable_cursor()
    raise re.PatternError(msg=f"Error fatal, no se encontro el TTL en la dirección IP {sys.argv[1]}")

def main():
    
    disable_cursor()
    if not len(sys.argv) == 2:
        enable_cursor()
        print(f"\n{bright_cyan}[+]{bright_white} Usage: {sys.argv[0]} {bright_magenta}127.0.0.1{end}\n")
        sys.exit(1)
    
    disable_cursor()
    process = subprocess.Popen(args=['/usr/bin/ping', '-c', '1', f'{sys.argv[1]}'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)

    stdout, stderr = process.communicate()

    ttl = Get_TTL(stdout.decode())
    
    os = Get_OS(ttl)
    
    enable_cursor()
    print(os)

if __name__ == "__main__":
    main()
