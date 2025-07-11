#!/usr/bin/env python
from random import choice
from typing import Any
import customtkinter as ctk 
from CTkMessagebox import CTkMessagebox
import subprocess, re, os, sys, cv2 
from PIL import Image
from CTkColorPicker import AskColor
import CTkFileDialog  
from CTkFileDialog.Constants import PWD, HOME
from tkfontchooser import askfont        

def is_hex(color_entry) -> bool:

    if not re.fullmatch(r"#([A-Fa-f0-9]{6})", color_entry):
        return False

    return True

def is_valid_image(image_path) -> bool:
    try:
        with Image.open(image_path) as img:
            img.verify()
        return True
    except:
        return False

class Picker(AskColor):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

        self.exit_button = ctk.CTkButton(
            master=self.frame,
            text="✕",
            width=14,
            height=14,
            corner_radius=7,
            fg_color="#FF5F57",
            hover_color="#D9433F",
            font=("Arial", 10),
            command=lambda: self._on_closing()
        )
        self.exit_button.place(x=5, y=5)

class BSPWM():
    
    distro = os.popen(cmd='lsb_release -d | grep -oP "Parrot|Kali"').read().strip()

    if distro == 'Kali':

        backends = ['glx', 'xrender', 'egl', 'dummy']
    else: 

        backends = ['glx', 'xrender']

    def __init__(self, root: Any) -> None:
        self.root = root 
    
    ENTRY_SIZE: ctk.CTkEntry
    ENTRY_BACKGROUND: ctk.CTkEntry
    ENTRY_FOREGROUND: ctk.CTkEntry
    FONT_FAMILY_LABEL: ctk.CTkLabel 
    FONT_FAMILY_ENTRY: ctk.CTkEntry 
    RADIUS_SLIDDER: ctk.CTkSlider
    LABEL_RADIUS: ctk.CTkLabel
    OPT_BACKEND: ctk.CTkOptionMenu
    VSYNC_SWITCH: ctk.CTkSwitch
    ANIMATIONS_SWITCH: ctk.CTkSwitch
    FADING_SWITCH: ctk.CTkSwitch
    BACKGROUND_SLIDER: ctk.CTkSlider
    OPACITY_LABEL: ctk.CTkLabel
    
    @staticmethod
    def browse_directory(entry: ctk.CTkEntry):

        d = CTkFileDialog.askdirectory(autocomplete=True, tool_tip=True, initial_dir=HOME, style='Default')

        if d: 

            entry.delete(0, ctk.END)
            entry.insert(index=0, string=d)

    @staticmethod
    def choose(dir_path: str, entry: ctk.CTkEntry, master: Any):

        if not dir_path:
            return 
        
        if not os.path.isdir(dir_path) or not os.path.exists(dir_path):
            CTkMessagebox(message='La ruta indicada no es valida o no existe!')
            return
        
        files = [ f.path for f in os.scandir(dir_path)
                 if not os.path.isdir(f.path) and not f.path.startswith('.') and os.path.isfile(f.path) and f.path.endswith(('.mp4', '.mvk', '.jpg', '.webp', '.gif', '.jpeg')) ]
        
        if not files: 
            CTkMessagebox(master=master, message='Directorio vacio!', icon='cancel', title='Error')

            return

        wall = choice(files)
    
        if not is_valid_image(wall):
            CMD = f'''if pgrep -x xwinwrap; then 
                AnimatedWall --stop
                pkill xwinwrap
            fi 
            AnimatedWall --start %s
            ''' % (wall)

            process = subprocess.run(CMD, stdout=True, stderr=True, shell=True).stdout

            return 
        
        CMD = '''
            if pidof -q xwinwrap; then 
                pkill xwinwrap
            fi 

            feh --bg-fill %s
        ''' % (wall)

        subprocess.run(CMD, stdout=True, stderr=True, shell=True).stdout

    @staticmethod
    def focused_border_color(root, border_color, entry_widget):

        if not border_color: return 

        if is_hex(border_color):
            process = subprocess.Popen(['bspc', 'config', 'focused_border_color', border_color], stdout=subprocess.PIPE, stderr=subprocess.PIPE)

            process.communicate()

            CTkMessagebox(message=f'Bordeado {border_color} aplicado', title='info', icon='info')

            return 
        else:
            CTkMessagebox(message='Esto no parece ser un color hex', title='Ups!!', icon='warning')
        
        if entry_widget.get():
            entry_widget.delete(0, 'end')
        return 

    @staticmethod
    def normal_border_color(root: Any, border_color, entry_widget: ctk.CTkEntry):

        if not border_color: return 

        if is_hex(border_color):
            process = subprocess.Popen(['bspc', 'config', 'normal_border_color', border_color], stdout=subprocess.PIPE, stderr=subprocess.PIPE)

            process.communicate()

            CTkMessagebox(message=f'Bordeado {border_color} aplicado', title='info', icon='info')

            return 
        else:
            CTkMessagebox(message='Esto no parece ser un color hex', title='Ups!!', icon='warning')
        
        if entry_widget.get():
            entry_widget.delete(0, 'end')
        return 
    
    # Picom secction
    @staticmethod
    def put_backend(backend, master: ctk.CTk, ruta: str, notify: bool = True):

        if not backend:

            return 
        
        distro = os.popen(cmd='lsb_release -d | grep -oP "Parrot|Kali"').read().strip()

        if distro == 'Kali':

            valid_backends = ('glx', 'xrender', 'egl', 'dummy')

        else:

            valid_backends = ('glx', 'xrender')

        if ruta.startswith('~'):
            ruta = os.path.expanduser(ruta)

        if backend not in valid_backends:
            if notify: CTkMessagebox(title='Error', message='Backend no válido. Usa "glx" o "xrender".', icon='cancel', master=master)
            return

        try:
            with open(ruta, "r", encoding="utf-8") as f:
                contenido = f.read()
        except FileNotFoundError:
            if notify: CTkMessagebox(title='Error', message=f'No se encontró el archivo:\n{ruta}', icon='cancel', master=master)
            return

        match = re.search(r'(backend\s*=\s*")[^"]+(")', contenido)
        if match:
            backend_actual = match.group(0).split('=')[1].strip().strip('"')
            if backend_actual == backend:
                if notify: CTkMessagebox(title='Sin cambios', message=f'El backend ya está establecido como "{backend}".', icon='info', master=master)
                return
        else:
            if notify: CTkMessagebox(title='Error', message='No se encontró una línea con "backend = ..." en el archivo.', icon='cancel', master=master)
            return

        nuevo_contenido = re.sub(r'(backend\s*=\s*")[^"]+(")', fr'\1{backend}\2', contenido)

        try:
            with open(ruta, "w", encoding="utf-8") as f:
                f.write(nuevo_contenido)
            if notify: CTkMessagebox(title='Éxito', message=f'Se cambió el backend a "{backend}".', icon='check', master=master)
        except Exception as e:
            if notify: CTkMessagebox(title='Error', message=f'No se pudo escribir el archivo:\n{e}', icon='cancel', master=master)


    @staticmethod
    def browse_wallpaper(entry_widget: ctk.CTkEntry, filetypes: list = ['.jpg', '.png', '.webp', '.mp4', '.mvk']):
       
        img = CTkFileDialog.askopenfilename(filetypes=filetypes, autocomplete=True, tool_tip=True, style='Default')
        
        if img:
            
            entry_widget.delete(0, ctk.END)
            entry_widget.insert(0, img)

    @staticmethod
    def config_border(root: Any, border, entry_widget: ctk.CTkEntry): 
        if entry_widget.get() == '':
            return 

        valid_borders = [border for border in range(0, 10)]
        
        try:
            if int(border) not in valid_borders:
                CTkMessagebox(message='Este borde no es valido!', title='Error', icon='warning')
                entry_widget.delete(0, 'end')
                return
        except ValueError:
            CTkMessagebox(message='Este valor no esta permitido!', title='Error', icon='cancel')
            entry_widget.delete(0, 'end')
            return 
        else:
            process = subprocess.Popen(['bspc', 'config', 'border_width', border], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    
            process.communicate()

    @staticmethod
    def reset_default(master: ctk.CTk, button_widget: ctk.CTkButton) -> None:
    
        message = CTkMessagebox(master=master, message='¿Deseas reinciar la configuración?', title='Reiniciar', option_1='Yes', option_2='No', icon='question')
        
        if message.get() == 'Yes':
            CMD = '''
            if pidof -q picom; then 
                pkill picom 
            fi 
            ''' 
        

            (BSPWM.RADIUS_SLIDDER.set(10))
            BSPWM.LABEL_RADIUS.configure(text="Picom Corner Radius 10")
            BSPWM.OPT_BACKEND.set(value='glx')
            process = subprocess.run("bspc wm -r", shell=True, stdout=True).stdout 
                
            BACKEND = BSPWM.get_backend()
            if BACKEND != 'glx':
                BACKEND = 'glx'

            RUTA = os.path.expanduser('~/.config/picom/picom.conf')
            BSPWM.put_backend(master=master, ruta=RUTA, backend=BACKEND, notify=False)

            VSYNC = BSPWM.is_vsync_enabled(file='~/.config/picom/picom.conf')

            if not VSYNC: 
                VSYNC = True 

                if BSPWM.VSYNC_SWITCH.get() == 0: BSPWM.VSYNC_SWITCH.select() 
                BSPWM.changue_vsync(new_state="true")

            CORNER_RADIUS = BSPWM.get_corner()

            if CORNER_RADIUS != 10:
                CORNER_RADIUS = 10 
                BSPWM.put_corner_radius(corner_radius=CORNER_RADIUS, root=master, notify=False)
        
            ANIMATIONS = BSPWM.is_active_animations()

            if not ANIMATIONS:
                ANIMATIONS = True 

                if BSPWM.ANIMATIONS_SWITCH.get() != 1: BSPWM.ANIMATIONS_SWITCH.select() 
                BSPWM.put_animations(master=master, switch=BSPWM.switch, notify=False)
                
            FADDING = BSPWM.is_active_fadding()

            if FADDING:
                BSPWM.PUT_FADING(master=master, new_state='false', notify=False)
                
                BSPWM.FADING_SWITCH.deselect()   

            KITTY_FONT_SIZE = str(BSPWM.Get_FontSize())
            
            if KITTY_FONT_SIZE != "11":

                KITTY_FONT_SIZE = "11"

                BSPWM.Put_Font_size(font_size=KITTY_FONT_SIZE, master=master, entry_widget=BSPWM.ENTRY_SIZE, notify=False)

            OPACITY_BACK = BSPWM.Get_Size_Background()

            if OPACITY_BACK != 1.0: 
                OPACITY_BACK = 1.0 

                BSPWM.BACKGROUND_SLIDER.set(OPACITY_BACK)

                BSPWM.UpdateBackgroundOpacity(master=master, opacity=OPACITY_BACK, notify=False)

                BSPWM.OPACITY_LABEL.configure(text="Kitty Background Opacity 1.0")

            BACK_COLOR = BSPWM.GetBackgroundColor()

            if BACK_COLOR != "#1a1b26":
                
                BACK_COLOR = '#1a1b26'
                BSPWM.UpgradeBackgroundColor(color=BACK_COLOR, master=master, Entry_Widget=BSPWM.ENTRY_BACKGROUND, notify=False)
            
            FOREGROUND_COLOR = BSPWM.GetForeground()

            if FOREGROUND_COLOR != "#a9b1d6": 
                FOREGROUND_COLOR = "#a9b1d6"
                
                BSPWM.Apply_foreground(foreground=FOREGROUND_COLOR, master=master, entry_widget=BSPWM.ENTRY_FOREGROUND, notify=False)

            FONT_FAMILY = BSPWM.Get_Current_Font()
        
            if FONT_FAMILY != 'Hack Nerd Font':

                cmd = '''
                kitter --font-family Hack Nerd Font
                '''

                p = subprocess.Popen(['/usr/bin/kitter', '--font-family', 'Hack Nerd Font'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
                out, err = p.communicate( )

                BSPWM.FONT_FAMILY_LABEL.configure(text=f"Font Family (Hack Nerd Font)")
                BSPWM.FONT_FAMILY_ENTRY.configure(placeholder_text='Hack Nerd Font...')

        return 

    
    @staticmethod
    def is_video(image_path: str) -> bool:
        cap = cv2.VideoCapture(image_path)
        if cap.isOpened():  # Si el archivo se puede abrir como video
            return True

        return False    
        
    @staticmethod
    def ANIMATED_WALL(image_path):
        
        if image_path and BSPWM.is_video(image_path):
    
            CMD = f'''if pgrep -x xwinwrap; then 
                AnimatedWall --stop
                pkill xwinwrap
            fi 
            AnimatedWall --start %s
            ''' % (image_path)

            process = subprocess.run(CMD, stdout=True, stderr=True, shell=True).stdout

    @staticmethod 
    def put_wallpaper(master: ctk.CTk, image_path, entry_widget: ctk.CTkEntry, Animated=False) -> None:

        if not image_path: 

            entry_widget.configure(placeholder_text='~/Imágenes/wallpapers/')
            return 

        if image_path.startswith("~"):
            image_path = os.path.expanduser(image_path)
       
        if not os.path.exists(path=image_path):

             CTkMessagebox(master=master, message='No Such File Or Directory', title='Error', icon='cancel')
             entry_widget.delete(0, 'end')
             entry_widget.configure(placeholder_text='~/Imágenes/wallpapers/')
             return 

        if not is_valid_image(image_path):

            if BSPWM.is_video(image_path) and not Animated:
                value = CTkMessagebox(message='Este wallpaper parece ser uno animado, ¿Deseas ponerlo?', title='Advertencia', option_1='Yes', option_2='No', icon='warning')

                if value.get() == 'Yes':


                    BSPWM.ANIMATED_WALL(image_path)
                    return 
                else:

                    return 

            CTkMessagebox(master=master, message='Imagen invalida', title='Error', icon='cancel')
            entry_widget.delete(0, 'end')
            entry_widget.configure(placeholder_text='Wallpaper.jpg...')
            return 
        
        one_process = subprocess.run('./AnimatedWall --stop', stdout=True, stderr=True, shell=True).stdout
    
        process = subprocess.Popen(['/usr/bin/feh', '--bg-fill', image_path], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        
        process.communicate()
    
    @staticmethod
    def is_vsync_enabled(file: str) -> bool:

        file = os.path.expanduser(file)

        with open(file, 'r') as picom:
            for line in picom:
                if line.strip().startswith(('#', '//')):
                    continue
                match = re.search(r'^vsync\s*=\s*(true|false)', line.strip())
                if match:
                    return match.group(1).lower() == 'true'
        return False

    @staticmethod
    def SWITCH_BTN(master: ctk.CTk, frame: ctk.CTkFrame, file='~/.config/picom/picom.conf'):
        estado = BSPWM.is_vsync_enabled(file)

        widget_picom_vsync = ctk.CTkSwitch(master=frame, text='Vsync', onvalue=1, offvalue=0, command=lambda: BSPWM.changue_vsync(widget_picom_vsync.get()))
        BSPWM.VSYNC_SWITCH = widget_picom_vsync
        widget_picom_vsync.pack(side='right', fill='x', pady=10, padx=10)

        if estado:
            widget_picom_vsync.select()
        else:
            widget_picom_vsync.deselect()

    @staticmethod
    def changue_vsync(new_state, archivo_picom="~/.config/picom/picom.conf"):

        archivo_picom = os.path.expanduser(archivo_picom)
        
        with open(archivo_picom, 'r') as f:
            lines = f.readlines()

        with open(archivo_picom, 'w') as f:
            for line in lines:
                if line.strip().startswith(('#', '//')):
                    f.write(line)
                    continue

                if re.search(r'^\s*vsync\s*=\s*(true|false)', line.strip()):
                    f.write(f"vsync = {'true' if new_state else 'false'}\n")
                else:
                    f.write(line)

    @staticmethod
    def get_backend(conf_path='~/.config/picom/picom.conf'):
        conf_path = os.path.expanduser(conf_path)

        backend_patterns = [
            r"^\s*backend\s*=\s*['\"](.*?)['\"]",  # Para backend = 'glx' o "glx"
            r"^\s*backend\s*=\s*([^'\";\s]+)"       # Para backend = glx (sin comillas)
        ]
        
        try:
            with open(conf_path, 'r') as f:
                for line in f:
                    if line.strip().startswith('#'):
                        continue
                    
                    for pattern in backend_patterns:
                        match = re.search(pattern, line.strip())
                        if match:
                            return match.group(1)
            return None
        except (FileNotFoundError, PermissionError):
            return None 

    @staticmethod
    def put_corner_radius(corner_radius, root: Any, entry_widget=None, config_file='~/.config/picom/picom.conf', notify: bool = True):

        if not corner_radius:
            return 

        config_file = os.path.expanduser(config_file)
        new_value = int(corner_radius)

        with open(config_file, 'r') as f:
            lines = f.readlines()

        for line in lines:
            match = re.match(r'^\s*corner-radius\s*=\s*(\d{1,3})', line)
            if match:
                current_value = int(match.group(1))
                if current_value == new_value:
                    if notify: CTkMessagebox(message=f'El corner radius ya es {new_value}', master=root, title='Info')
                    return

        updated = False
        for i, line in enumerate(lines):
            if re.match(r'^\s*corner-radius\s*=\s*\d{1,3}', line):
                lines[i] = f'corner-radius = {new_value}\n'
                updated = True
                break

        if not updated:
            lines.append(f'\ncorner-radius = {new_value}\n')

        with open(config_file, 'w') as f:
            f.writelines(lines)

        if notify: CTkMessagebox(message=f'corner-radius actualizado a {new_value}', master=root, title='Info')

    @staticmethod
    def is_active_animations(file_config: str='~/.config/picom/picom.conf'): 
        
        file_config = os.path.expanduser(file_config)

        with open(file_config, 'r') as file: 

            for line in file: 

                if re.match(pattern='@include "picom-animations.conf"', string=line.strip()): 

                    return True 


        return False 

    @staticmethod
    def put_animations(master: ctk.CTk, switch: ctk.CTkSwitch, notify: bool = True):
        
        '''
        Cuando valga 0 es False, cuando valga 1 sera True.
        En base a esto, podemos activar o desactivar las animaciones de picom 
        '''
        linea_objetivo = '@include "picom-animations.conf"'
        config_file = '~/.config/picom/picom.conf'
        config_file = os.path.expanduser(config_file)

        with open(config_file, "r") as f:
            lineas = f.readlines()

        with open(config_file, "w") as f:
            for linea in lineas:
                if linea.strip().lstrip("#").strip() == linea_objetivo:
                    if switch.get():
                        f.write(linea.lstrip("#"))  # Descomentar
                        CTkMessagebox(master=master, message='Animaciones habilitadas', icon='info', title='Animaciones')
                    else:
                        if not linea.strip().startswith("#"):
                            CTkMessagebox(master=master, message='Animaciones inhabilitadas', icon='info', title='Animaciones')
                            f.write("#" + linea)  # Comentar
                        else:
                            f.write(linea)
                else:
                    f.write(linea)


    @staticmethod
    def ANIMATE_PICOM_SWITCH(master: ctk.CTk, frame: ctk.CTkFrame):
        BSPWM.switch = ctk.CTkSwitch(master=frame, onvalue=1, offvalue=0, text='Animations', command=lambda: BSPWM.put_animations(master=master, switch=BSPWM.switch))
        BSPWM.ANIMATIONS_SWITCH = BSPWM.switch
        BSPWM.switch.pack(side='right', fill='x', padx=10, pady=10)

        if BSPWM.is_active_animations():

            BSPWM.switch.select()
        else:

            BSPWM.switch.deselect()    

    @staticmethod
    def is_active_fadding():
            
        file = '~/.config/picom/picom.conf'
        file = os.path.expanduser(file)

        with open(file, 'r') as f: 

            for line in f:
                if line.strip() == 'fading = true': return True 


        return False 

    @staticmethod
    def PUT_FADING(master: ctk.CTk, new_state, archivo_picom='~/.config/picom/picom.conf', notify: bool = True):
        archivo_picom = os.path.expanduser(archivo_picom)

        try:
            with open(archivo_picom, 'r') as file:
                lines = file.readlines()

            found = False
            with open(archivo_picom, 'w') as file:
                for line in lines:
                    if line.strip().startswith(('#', '//')):
                        file.write(line)
                        continue

                    match = re.match(r'^\s*fading\s*=\s*(true|false)', line.strip())
                    if match:
                        file.write(f"fading = {'true' if new_state else 'false'}\n")
                        found = True
                    else:
                        file.write(line)

            if found:
                if new_state:
                    if notify: CTkMessagebox(message='¡Fading activado correctamente!', title='Activado', icon='info', master=master)
                else:
                    if notify: CTkMessagebox(message='Fading desactivado correctamente.', title='Desactivado', icon='info', master=master)
            else:
                if notify: CTkMessagebox(message='No se encontró la línea "fading" en el archivo :(', title='Error', icon='cancel', master=master)

        except Exception as e:
            if notify: CTkMessagebox(message=f'Error al procesar el archivo:\n{e}', title='Error', icon='cancel', master=master)
        
    @staticmethod
    def PICOM_FADDING(master: ctk.CTk, frame: ctk.CTkFrame):

        switch = ctk.CTkSwitch(master=frame, text='Fadding', onvalue=1, offvalue=0, command=lambda: BSPWM.PUT_FADING(master=master, new_state=switch.get()))
        BSPWM.FADING_SWITCH = switch
        switch.pack(fill='x', side='right', padx=10, pady=10)
        
        if BSPWM.is_active_fadding():

            switch.select()

        else:

            switch.deselect()

    @staticmethod
    def get_corner(picom_file='~/.config/picom/picom.conf'):
        
        picom_file = os.path.expanduser(picom_file)

        with open(picom_file, 'r') as f:

            for line in f:
                match = re.match(pattern=r'corner-radius = \d{1,3}', string=line.strip())

                if match:
                    corner = (match.group(0).split('=')[1].strip())
                    return int(corner)

    @staticmethod
    def is_remote_control_enabled(kitty_file : str = '~/.config/kitty/kitty.conf') -> bool:
        if kitty_file.startswith('~'):
            kitty_file = os.path.expanduser(path=kitty_file)

        with open(kitty_file, 'r') as f:
            for line in f:
                target = (line.strip())
                
                match = re.match(pattern=r'allow_remote_control (yes|no)', string=target)

                if match: 

                    if (match.group(1)) == 'yes':

                        return True 

        return False 
    
    @staticmethod
    def Get_FontSize(kitty_file : str = '~/.config/kitty/kitty.conf') -> int:

        if kitty_file.startswith('~'):
            kitty_file = os.path.expanduser(path=kitty_file)

        with open(kitty_file, 'r') as f:

            for line in f:

                target = line.strip()

                match = re.match(pattern=r'font_size \d{1,3}', string=target)
                
                if match: 
                    Font_size = int(match.group(0).replace('font_size', '').strip())

        return Font_size
    
    def Put_Font_size(font_size : str, master: ctk.CTk, entry_widget : ctk.CTkEntry, kitty_file : str = '~/.config/kitty/kitty.conf', notify=True):
        
        if not font_size.strip():
            return 

        if kitty_file.startswith('~'):

            kitty_file = os.path.expanduser(path=kitty_file)

        if (re.match(pattern=r'^\d+(\.\d+)?$', string=font_size)):

        
            if BSPWM.Get_FontSize() == int(font_size):

                return 

            process = subprocess.Popen(['/usr/bin/kitter', '--font-size', font_size], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    
            out, err = process.communicate()

            if (err.decode('utf-8')):

                if notify: CTkMessagebox(master=master, title = 'Error', message = f'Error ocurrido {err.decode()}')
        
            with open(kitty_file, "r") as archivo:
                lineas = archivo.readlines()

            nuevas_lineas = []
            for linea in lineas:
                # Reemplaza 'font_size' seguido de 1 a 3 dígitos por 'font_size 22'
                nueva_linea = re.sub(r"^font_size\s+\d{1,3}", f"font_size {font_size}", linea)
                nuevas_lineas.append(nueva_linea)

            with open(kitty_file, "w") as archivo:

                archivo.writelines(nuevas_lineas)        

            if notify: CTkMessagebox(master=master, message = 'Tamaño de fuente aplicado', title = 'Info', icon = 'info')

        else:

            entry_widget.delete(0, 'end')
            entry_widget.configure(placeholder_text=f'Font Size ({BSPWM.Get_FontSize()})')
            if notify: CTkMessagebox(master=master, title = 'Invalid Font Size', message = f'El tamaño de fuente debe de ser un numero entero!', icon='error')

    @staticmethod
    def Get_Size_Background(kitty_file : str = '~/.config/kitty/kitty.conf'):
        
        if kitty_file.startswith('~'):
            kitty_file = os.path.expanduser(path=kitty_file)

        with open(kitty_file) as f:

            for line in f:

                target = line.strip()

                match = re.match(pattern=r'^background_opacity\s+\d{1,3}.\d{1,3}', string=target)
                
                if match:
                    return (float(match.group(0).replace('background_opacity', '').strip()))
    

    @staticmethod
    def PutBackgroundWidget(master: ctk.CTk, frame: ctk.CTkFrame) -> None:
        background_opacity = BSPWM.Get_Size_Background()
        background_opacity_label = ctk.CTkLabel(master=frame, fg_color='transparent', text=f'Kitty Background Opacity {background_opacity}', font=('Arial', 15))
        BSPWM.OPACITY_LABEL = background_opacity_label
        background_opacity_label.pack(side='left', fill='y')
        
        entry_background_size = ctk.CTkSlider(master=frame, from_=0.0, to=1.0, width=135, command = lambda value: BSPWM.UpdateLabel(value, label=background_opacity_label))#, #placeholder_text=f'Font Size ({BSPWM.Get_FontSize()})')
        BSPWM.BACKGROUND_SLIDER = entry_background_size
        entry_background_size.set(background_opacity)

        entry_background_size.pack(side='right', fill='x')

        button_apply_back_size = ctk.CTkButton(master=frame, text='Apply', command = lambda: BSPWM.UpdateBackgroundOpacity(master=master, opacity=entry_background_size.get()))
        button_apply_back_size.pack(side='right', padx=14)

    @staticmethod
    def UpdateLabel(value: float, label: ctk.CTkLabel) -> None:
        text = (f"{float(value):.2f}")

        label.configure(text=f'Kitty Background Opacity {text}')

    @staticmethod
    def UpdateBackgroundOpacity(master: ctk.CTk, opacity: float, kitty_file : str = '~/.config/kitty/kitty.conf', notify=True):
        
        if kitty_file.startswith('~'):
            kitty_file = os.path.expanduser(kitty_file)

        if BSPWM.Get_Size_Background() == opacity:
            return 
        
        opacity = (f"{float(opacity):.2f}")

        cmd = f'''
        /usr/bin/kitter --background-opacity {opacity}
        ''' 

        process = subprocess.run(cmd, shell=True, stderr=True, stdout=True).stdout 
   
        with open(kitty_file, "r") as archivo:
            lineas = archivo.readlines()

        nuevas_lineas = []
        for linea in lineas:
            nueva_linea = re.sub(r"^background_opacity\s+\d{1,3}.\d{1,3}", f"background_opacity {opacity}", linea)
            nuevas_lineas.append(nueva_linea)

        with open(kitty_file, "w") as archivo:

            archivo.writelines(nuevas_lineas)        

        if notify: CTkMessagebox(master=master, message='Opacidad aplicada', title='Info', icon='info')
    
    @staticmethod
    def UpgradeBackgroundColor(color: str, Entry_Widget: ctk.CTkEntry, master: ctk.CTk, frame=None, notify=True) -> None: 

        if not color.strip():

            return 

        if not is_hex(color_entry=color):
            Entry_Widget.delete(0, 'end')
            Entry_Widget.configure(placeholder_text='#000000')
            if notify: CTkMessagebox(message='Esto no parece ser un color en hexadecimal', title='Info', icon='info', master=master)
            return
        # kitter --background-color '#000000'
        process = subprocess.Popen(['kitter', '--background-color', f'{color}'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)

        out, err = process.communicate()

        BSPWM.UpdateColorFile(color, notify=notify)

    @staticmethod
    def UpdateColorFile(color: str, file: str = '~/.config/kitty/color.ini', notify=True):

        if file.startswith('~'):
            file = os.path.expanduser(path=file)

        with open(file, "r") as archivo:
            lineas = archivo.readlines()

        nuevas_lineas = []
        for linea in lineas:
            nueva_linea = re.sub(r"^background #([A-Fa-f0-9]{6})", f"background {color}", linea)
            nuevas_lineas.append(nueva_linea)

        with open(file, "w") as archivo:

            archivo.writelines(nuevas_lineas)  

        if notify: CTkMessagebox(message=f'background {color} aplicado', title='Mensaje', icon='info')

    @staticmethod
    def GetBackgroundColor(color_files : str = '~/.config/kitty/color.ini'):
        if color_files.startswith('~'):
            color_files = os.path.expanduser(path=color_files)

        with open(color_files, 'r') as f:
            for line in f:

                target = line.strip()

                match = re.match(pattern=r'^background #([A-Fa-f0-9]{6})', string=target)

                if match:

                    return (match.group(0).replace('background ', '').strip())
    
    @staticmethod
    def GetForeground(fore_file : str = '~/.config/kitty/color.ini'):

        if fore_file.startswith('~'):
            fore_file = os.path.expanduser(path=fore_file)

        with open(fore_file, 'r') as f:

            for line in f:

                target = line.strip()
                
                match = re.match(pattern=r'foreground #([A-Fa-f0-9]{6})', string=target)

                if match:

                    foreground = (match.group(0).replace('foreground ', ''))

                    if is_hex(color_entry=foreground):

                        return str(foreground)

    @staticmethod
    def Apply_foreground(foreground: str, entry_widget: ctk.CTkEntry, master: ctk.CTk, config_file: str = '~/.config/kitty/color.ini', notify=True) -> None:
        
        if config_file.startswith('~'):
            config_file = os.path.expanduser(config_file)

        if not foreground:
            return
        if not is_hex(foreground):
            
            entry_widget.delete(0, 'end')
            entry_widget.configure(placeholder_text=f'{BSPWM.GetForeground()}')
            if notify: CTkMessagebox(message='Esto no parece ser un color en hexadecimal!', title='Error', icon='warning')
            return 

        process = subprocess.Popen(['kitter', '--foreground-color', foreground], stdout=subprocess.PIPE, stderr=subprocess.PIPE)

        out, err = process.communicate()
    
        with open(config_file, "r") as archivo:
            lineas = archivo.readlines()

        nuevas_lineas = []
        for linea in lineas:
            nueva_linea = re.sub(r"^foreground #([A-Fa-f0-9]{6})", f"foreground {foreground}", linea)
            nuevas_lineas.append(nueva_linea)

        with open(config_file, "w") as archivo:

            archivo.writelines(nuevas_lineas)        
        
        if notify: CTkMessagebox(message=f'Foreground {foreground} aplicado', title='Mensaje', icon='info')
    
    @staticmethod
    def Get_Current_Font(): 
        cmd = "kitty +runpy 'from kitty.cli import *; print(create_default_opts().font_family)'"
    
        return os.popen(cmd=cmd).read().strip()

    @staticmethod  
    def Apply_font(entry: ctk.CTkEntry, label: ctk.CTkLabel, notify=True):
        font = entry.get()

        if font:
            p = subprocess.Popen(['kitter', '--font-family', font, '--all-sockets'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            out, err = p.communicate()
            label.configure(text=f"Font Family ({BSPWM.Get_Current_Font()})")

class Editor():

    def __init__(self) -> None:
        

        self.root = ctk.CTk()
            
        self.DEFAULT = 'DEFAULT'

        # Create the danguer sect 
        self.danguer_sect(root=self.root)

        sections = ['bspwm', 'picom', 'kitty', 'wallpaper']
            
        self.top_margin = ctk.CTkFrame(master=self.root, height=10, fg_color='transparent')
        self.top_margin.pack(fill=ctk.X, side=ctk.TOP)

        self.tab = ctk.CTkTabview(self.root)
        self.tab.pack(fill=ctk.BOTH, expand=ctk.TRUE, padx=10, pady=10)
        self.tabs_dict = {

                }
        for self.section in sections:
            self.tab.add(self.section)
            self.tabs_dict[self.section] = self.tab.tab(self.section)
    
        # Validation if we in bspwm
        self.in_bspwm(root=self.root)

        # Configure the app 
        self.__configure__(root=self.root)

        # Create secction bspwm
        self.create_bspwm_sec(root=self.tabs_dict['bspwm'])

        # Creathe the wallpaper secction
        self.create_wallpaper_sec(root=self.tabs_dict['wallpaper'])

        # Create the picom secction
        self.create_picom_sec(root=self.tabs_dict['picom'])

        # Create the kitty section 
        self.create_kitty_sec(root=self.tabs_dict['kitty'])

        # Start the app
        self.__app__(root=self.root)

    def create_kitty_sec(self, root: Any) -> None: 
        background_color = BSPWM.GetBackgroundColor()
        # Frame que contendra los widgets para la configuracion de kitty 
        container_widgets_kitty = ctk.CTkFrame(master=root)
        container_widgets_kitty.pack(pady=10, fill='x', padx=10)

        # Kitty font size 
        kitty_font_size_frame = ctk.CTkFrame(master=container_widgets_kitty, fg_color='transparent')
        kitty_font_size_frame.pack(pady=10, fill='x', padx=10)
        
        label_font_size = ctk.CTkLabel(master=kitty_font_size_frame, fg_color='transparent', text=f'Kitty Font Size', font=('Arial', 15))
        label_font_size.pack(side='left', fill='y')
        
        self.entry_font_size = ctk.CTkEntry(master=kitty_font_size_frame, placeholder_text=f'Font Size ({BSPWM.Get_FontSize()})')
        self.entry_font_size.pack(side='right', fill='x')
        BSPWM.ENTRY_SIZE = self.entry_font_size

        button_apply_font_size = ctk.CTkButton(master=kitty_font_size_frame, text='Apply', command=lambda:BSPWM.Put_Font_size(font_size=self.entry_font_size.get(), entry_widget=self.entry_font_size, master=root))
        button_apply_font_size.pack(side='right', padx=10)

        # set-background-opacity || kitty @ set-background-opacity 0.0
        kitty_background_opacity_frame = ctk.CTkFrame(master=container_widgets_kitty, fg_color='transparent')
        kitty_background_opacity_frame.pack(pady=10, fill='x', padx=10)

        BSPWM.PutBackgroundWidget(master=root, frame=kitty_background_opacity_frame)

        # set kitty color || kitter --background-color #f2f2f2 
        kitty_background_color_frame = ctk.CTkFrame(master=container_widgets_kitty, fg_color='transparent') 
        kitty_background_color_frame.pack(pady=10, fill='x', padx=10)

        kitty_color_label = ctk.CTkLabel(master=kitty_background_color_frame, fg_color='transparent', text='Kitty background Color', font=('Arial', 15))
        kitty_color_label.pack(side='left', fill='y')

        color_label_kitty = ctk.CTkFrame(master=kitty_background_color_frame, fg_color='gray', corner_radius=6, width=17, height=17)
        color_label_kitty.pack(side='left', padx=(10, 10))

        def kitty_frame_label(event):
            color = Picker()

            color = color.get()

            if color: 

                self.entry_label_kitty.delete(0, 'end') 
                self.entry_label_kitty.insert(index=0, string=color)
    
                color_label_kitty.configure(fg_color=color)

        color_label_kitty.bind("<Button-1>", command=kitty_frame_label)

        self.entry_label_kitty = ctk.CTkEntry(master=kitty_background_color_frame, placeholder_text=background_color)
        self.entry_label_kitty.pack(side='right', fill='x')
        BSPWM.ENTRY_BACKGROUND = self.entry_label_kitty

        button_kitty_apply = ctk.CTkButton(master=kitty_background_color_frame, text='Apply', command = lambda: BSPWM.UpgradeBackgroundColor(self.entry_label_kitty.get(), self.entry_label_kitty, root, kitty_background_color_frame))
        button_kitty_apply.pack(side='right', padx=10)
        def update_background_frame_kitty(event):
            color = self.entry_label_kitty.get()
            if color.startswith('#') and len(color) == 7:
                try:
                    # Intentar aplicar el color
                    color_label_kitty.configure(fg_color=color)
                    return
                except:
                    pass
            # Si no es válido o está vacío, poner gris
            color_label_kitty.configure(fg_color="gray")

        self.entry_label_kitty.bind("<KeyRelease>", update_background_frame_kitty)
        
        # Last label foreground #a9b1d6 kitty 
        foreground_frame_kitty = ctk.CTkFrame(master=container_widgets_kitty, fg_color='transparent')
        foreground_frame_kitty.pack(pady=10, fill='x', padx=10)

        foreground_label = ctk.CTkLabel(master=foreground_frame_kitty, fg_color='transparent', font=('Arial', 15), text='Kitty Foreground')
        foreground_label.pack(side='left', fill='y')
        
        # Frame al estilo NvChad, es el ultimo para la configuración de la kitty, para que lo tengas en cuenta.
        frame_foreground_kitty = ctk.CTkFrame(master=foreground_frame_kitty, fg_color='gray', corner_radius=6, width=17, height=17)
        frame_foreground_kitty.pack(side='left', padx=(10, 10))

        
        foreground = BSPWM.GetForeground()
        self.entry_foreground_kitty = ctk.CTkEntry(master=foreground_frame_kitty, placeholder_text=foreground)
        self.entry_foreground_kitty.pack(side='right', fill='x') 
        BSPWM.ENTRY_FOREGROUND = self.entry_foreground_kitty
        def update_foreground_frame_kitty(event):
            color = self.entry_foreground_kitty.get()
            if color.startswith('#') and len(color) == 7:
                try:
                    # Intentar aplicar el color
                    frame_foreground_kitty.configure(fg_color=color)
                    return
                except:
                    pass
            # Si no es válido o está vacío, poner gris
            frame_foreground_kitty.configure(fg_color="gray")

        self.entry_foreground_kitty.bind("<KeyRelease>", update_foreground_frame_kitty)

        foreground_kitty_apply = ctk.CTkButton(master=foreground_frame_kitty, text='Apply', command=lambda: BSPWM.Apply_foreground(foreground=self.entry_foreground_kitty.get(), entry_widget=self.entry_foreground_kitty, master=root))
        foreground_kitty_apply.pack(side='right', padx=10)
        def kitty_foreground_frame(event):
            color = Picker()

            color = color.get()
            
            if color: 
                self.entry_foreground_kitty.delete(0, 'end') 
                self.entry_foreground_kitty.insert(index=0, string=color)

                frame_foreground_kitty.configure(fg_color=color)

        frame_foreground_kitty.bind("<Button-1>", command=kitty_foreground_frame)
        
        font_family_frame_kitty = ctk.CTkFrame(master=container_widgets_kitty, fg_color='transparent')
        font_family_frame_kitty.pack(fill=ctk.X, padx=10, pady=10)

        self.font_family_label = ctk.CTkLabel(master=font_family_frame_kitty, fg_color='transparent', font=('Arial', 15), text=f'Font Family ({BSPWM.Get_Current_Font()})')
        self.font_family_label.pack(side=ctk.LEFT, fill=ctk.Y)

        self.entry_family = ctk.CTkEntry(master=font_family_frame_kitty, placeholder_text=BSPWM.Get_Current_Font() + '...')
        self.entry_family.pack(side=ctk.RIGHT, fill=ctk.X)

        button_apply_font = ctk.CTkButton(master=font_family_frame_kitty, text="Apply", command=lambda :BSPWM.Apply_font(self.entry_family, self.font_family_label))
        button_apply_font.pack(side=ctk.RIGHT, padx=10)

        BSPWM.FONT_FAMILY_LABEL = self.font_family_label 
        BSPWM.FONT_FAMILY_ENTRY = self.entry_family
            
        def AskFont(event=None):
            f = askfont(master=root)
            if f: 
                font = f['family'] 
                self.entry_family.delete(0, ctk.END)
                self.entry_family.insert(index=0, string=font)

        self.font_family_label.bind('<Button-1>', command=lambda _:AskFont())

    def create_picom_sec(self, root: Any):
        # Frame que contendra los widgets para la configuración de picom
        container_widgets_picom = ctk.CTkFrame(root)
        container_widgets_picom.pack(pady=10, fill='x', padx=10)

        # Backend picom 
        widget_backend_frame = ctk.CTkFrame(master=container_widgets_picom, fg_color='transparent')
        widget_backend_frame.pack(side='top', fill='x', pady=10, padx=10)  # Empacar verticalmente con espacio entre ellos 
            
        # Label 
        label_backend = ctk.CTkLabel(master=widget_backend_frame, fg_color='transparent', text='Picom Backend', font=('Arial', 15))
        label_backend.pack(side='left', fill='y')

        entry_backend = ctk.CTkOptionMenu(master=widget_backend_frame, values=BSPWM.backends)
        BSPWM.OPT_BACKEND = entry_backend
        value = BSPWM.get_backend()
        entry_backend.set(value=str(value))

        entry_backend.pack(fill='x', side='right')

        # Button to put backend 
        button_backend = ctk.CTkButton(master=widget_backend_frame, text='apply', command=lambda: BSPWM.put_backend(backend=entry_backend.get(), master=root, ruta='~/.config/picom/picom.conf'))
        button_backend.pack(side='right', padx=10)

        # PICOM VSYNC 
        frame_vsync = ctk.CTkFrame(master=container_widgets_picom, fg_color='transparent')
        frame_vsync.pack(fill='x', pady=10, padx=10)

        widget_picom_vsync = ctk.CTkLabel(master=frame_vsync, fg_color='transparent', text='Vsync (True / False)', font=('Arial', 15))
        widget_picom_vsync.pack(side='left', fill='y')

        # BUTTON SWITCH 
        BSPWM.SWITCH_BTN(master=root, frame=frame_vsync)

        # PICOM CORNER_RADIUS 
        frame_corner_radius = ctk.CTkFrame(master=container_widgets_picom, fg_color='transparent')
        frame_corner_radius.pack(fill='x', pady=10, padx=10)

        value = BSPWM.get_corner() 
        self.widget_corner_radius = ctk.CTkLabel(master=frame_corner_radius, fg_color='transparent', text=f'Picom Corner Radius {value}', font=('Arial', 15))
        BSPWM.LABEL_RADIUS = self.widget_corner_radius
        self.widget_corner_radius.pack(side='left', fill='y')

#        entry_corner_radius = ctk.CTkEntry(master=frame_corner_radius, placeholder_text='0')
#        entry_corner_radius.pack(side='right')
        entry_corner_radius = ctk.CTkSlider(master=frame_corner_radius, from_=0, to=50, number_of_steps=50, width=135, command=self.update_radius)
        BSPWM.RADIUS_SLIDDER = entry_corner_radius
        entry_corner_radius.set(value)
        entry_corner_radius.pack(side='right')
         

        
        apply_button = ctk.CTkButton(master=frame_corner_radius, text='apply', command=lambda: BSPWM.put_corner_radius(corner_radius=entry_corner_radius.get(),root=root,entry_widget=entry_corner_radius))
        apply_button.pack(side='right', padx=10)

        # PICOM ANIMATIONS 
        frame_animations_picom = ctk.CTkFrame(master=container_widgets_picom, fg_color='transparent')
        frame_animations_picom.pack(fill='x', padx=10, pady=10)

        # Label Picom Animations 
        picom_animation_label = ctk.CTkLabel(master=frame_animations_picom, fg_color='transparent', text='Picom Animations', font=('Arial', 15))
        picom_animation_label.pack(side='left', fill='y')

        # Button Switch Picom Animations
        BSPWM.ANIMATE_PICOM_SWITCH(frame=frame_animations_picom, master=root)

        # Picom Fading unable or disable 
        frame_picom_fadding = ctk.CTkFrame(master=container_widgets_picom, fg_color='transparent')
        frame_picom_fadding.pack(fill='x', padx=10, pady=10)
        
        # Label to show text for Fading
        picom_fadding_label = ctk.CTkLabel(master=frame_picom_fadding, fg_color='transparent', text='Picom Fadding', font=('Arial', 15))
        picom_fadding_label.pack(side='left', fill='y')

        # Button switch picom fadding 
        BSPWM.PICOM_FADDING(master=root, frame=frame_picom_fadding)

    def update_radius(self, value):
        radius_value = int(value)

        self.widget_corner_radius.configure(text=f'Picom Corner Radius {radius_value}', font=('Arial', 15))


    def create_wallpaper_sec(self, root: Any) -> None:
        
        self.current_state = None 
        # Frame que contendra los widgets para la configuración del wallpaper

        self.container_widgets_wallpaper = ctk.CTkFrame(root, fg_color='transparent')
        self.container_widgets_wallpaper.pack(pady=10, fill=ctk.BOTH, padx=10, expand=ctk.TRUE)
       

        def clear_content():
            for widget in self.wallpaper_dynamic_content.winfo_children():
                try: 
                    widget.destroy()
                except Exception as e:
                    print(f"Error ocurrido: {e}")

        def default():
            Defaulttext = """
        En esta sección podras elegir entre meter un Wallpaper de tipo imagen y uno de tipo video.
        Sientete libre de elegir Imágenes y Videos.
        """
            default_label = ctk.CTkLabel(master=self.wallpaper_dynamic_content, text=Defaulttext, font=('Arial', 15))
            default_label.pack(fill=ctk.X, pady=0)

            row = ctk.CTkFrame(master=self.wallpaper_dynamic_content, fg_color='transparent')
            row.pack(fill=ctk.X, padx=10, pady=(10, 5), side=ctk.BOTTOM)

            default_entry = ctk.CTkEntry(master=row, placeholder_text='~/Imágenes/wallpapers/', width=550)
            default_entry.pack(side=ctk.LEFT, fill=ctk.X, expand=True, padx=(0, 10))

            default_button = ctk.CTkButton(master=row, text='Apply', command=lambda: BSPWM.put_wallpaper(
                image_path=default_entry.get(),
                entry_widget=default_entry,
                master=self.root,
                ) )
            default_button.pack(side=ctk.LEFT)

            browse_default = ctk.CTkButton(master=self.wallpaper_dynamic_content, text='Browse', width=800, command=lambda :BSPWM.browse_wallpaper(entry_widget=default_entry) )
            browse_default.pack(side=ctk.BOTTOM, fill=ctk.X, padx=10, pady=10)

        def CustomImage():
            Customtext = """
        En esta sección solo podras meter fondos de pantalla de tipo imagen. 
        Exclusivamente imagenes, no animados ni otras cosas.
        """
            CustomLabel = ctk.CTkLabel(master=self.wallpaper_dynamic_content, text=Customtext, font=('Arial', 15))
            CustomLabel.pack(fill=ctk.X, pady=0)

            Customrow = ctk.CTkFrame(master=self.wallpaper_dynamic_content, fg_color='transparent')
            Customrow.pack(fill=ctk.X, padx=10, pady=(10, 5), side=ctk.BOTTOM)

            Custom_entry = ctk.CTkEntry(master=Customrow, placeholder_text='~/Imágenes/wallpapers/', width=550)
            Custom_entry.pack(side=ctk.LEFT, fill=ctk.X, expand=True, padx=(0, 10))

            CustomButton = ctk.CTkButton(master=Customrow, text='Apply', command=lambda: BSPWM.put_wallpaper(
                image_path=Custom_entry.get(),
                entry_widget=Custom_entry,
                master=self.root,
                ) )
            CustomButton.pack(side=ctk.LEFT)

            browse_default = ctk.CTkButton(master=self.wallpaper_dynamic_content, text='Browse', width=800, command=lambda :BSPWM.browse_wallpaper(
                entry_widget=Custom_entry,
                filetypes=['jpg', 'jpeg', 'webp']
                )
                )

            browse_default.pack(side=ctk.BOTTOM, fill=ctk.X, padx=10, pady=10)

        def CustomAnimated():
            Animatedtext = """
        En esta sección ahora puedes meter fondos de pantalla animados, mas no imágenes.  
        Pueden ser gifs o videos.
        """
            AnimatedLabel = ctk.CTkLabel(master=self.wallpaper_dynamic_content, text=Animatedtext, font=('Arial', 15))
            AnimatedLabel.pack(fill=ctk.X, pady=0)

            Animatedrow = ctk.CTkFrame(master=self.wallpaper_dynamic_content, fg_color='transparent')
            Animatedrow.pack(fill=ctk.X, padx=10, pady=(10, 5), side=ctk.BOTTOM)

            Animated_entry = ctk.CTkEntry(master=Animatedrow, placeholder_text='~/Imágenes/wallpapers/', width=550)
            Animated_entry.pack(side=ctk.LEFT, fill=ctk.X, expand=True, padx=(0, 10))

            CustomButton = ctk.CTkButton(master=Animatedrow, text='Apply', command=lambda: BSPWM.ANIMATED_WALL(
                image_path=Animated_entry.get(),
                ) )

            CustomButton.pack(side=ctk.LEFT)

            browse_default = ctk.CTkButton(master=self.wallpaper_dynamic_content, text='Browse', width=800, command=lambda :BSPWM.browse_wallpaper(
                entry_widget=Animated_entry,
                filetypes=['.mp4', '.mvk', '.webm', '.gif']
                )
                )

            browse_default.pack(side=ctk.BOTTOM, fill=ctk.X, padx=10, pady=10)

        def Random():
            RandomText = """
            En esta sección la aplicación elegira por ti el fondo de pantalla a usar.
            Puede ser un fondo de pantalla normal o uno Animado.
        """
            RandomLabel = ctk.CTkLabel(master=self.wallpaper_dynamic_content, text=RandomText, font=('Arial', 15))
            RandomLabel.pack(fill=ctk.X, pady=0)

            RandomRow = ctk.CTkFrame(master=self.wallpaper_dynamic_content, fg_color='transparent')
            RandomRow.pack(fill=ctk.X, padx=10, pady=(10, 5), side=ctk.BOTTOM)

            RandomEntry = ctk.CTkEntry(master=RandomRow, placeholder_text='~/Imágenes/wallpapers/', width=550)
            RandomEntry.pack(side=ctk.LEFT, fill=ctk.X, expand=True, padx=(0, 10))

            RandomButton = ctk.CTkButton(master=RandomRow, text='Choose', command=lambda: BSPWM.choose(
                dir_path=RandomEntry.get(),
                entry=RandomEntry,
                master=root,
                ) )

            RandomButton.pack(side=ctk.LEFT)

            browse_default = ctk.CTkButton(master=self.wallpaper_dynamic_content, text='Browse', width=800, command=lambda :BSPWM.browse_directory(
                entry=RandomEntry
                )
                )

            browse_default.pack(side=ctk.BOTTOM, fill=ctk.X, padx=10, pady=10)

        def _on_changue(option: Any | None):
            if option == self.current_state:
                return 

            self.current_state = option
            clear_content()

            funcion = funciones.get(option)

            if funcion: 
                funcion()

        # Mapeo de string -> función real
        funciones = {
            'Default': default,
            'Custom Image': CustomImage,
            'Custom Animated': CustomAnimated,
            'Random': Random,
        }
        
        options = list(funciones.keys()) 
        self.buttons = ctk.CTkOptionMenu(master=self.container_widgets_wallpaper, 
                                         values=options,
                                         width=400,
                                         command=_on_changue)
    
        self.buttons.pack()

        self.wallpaper_dynamic_content = ctk.CTkFrame(self.container_widgets_wallpaper)
        self.wallpaper_dynamic_content.pack(fill=ctk.BOTH, expand=ctk.TRUE, padx=10, pady=10)
        
        _on_changue("Default")

    def create_bspwm_sec(self, root: Any) -> None:
        # 'TITULO' para la ventana, ya que no se puede ver un titulo real en bspwm
        self.tittle_sect = ctk.CTkFrame(master=root)
        self.tittle_sect.pack(side='top', fill='x', padx=10, pady=10)
        
        self.title_label = ctk.CTkLabel(master=self.tittle_sect, text="bspwm settings", font=("Arial", 18))
        self.title_label.pack(pady=10, anchor=ctk.CENTER)

        # Create Frame for the widgets 
        self.container_widgets_bspwm = ctk.CTkFrame(root)
        self.container_widgets_bspwm.pack(pady=10, fill='x', padx=10)

        # focused_border_color widget 
        widget_fbcw = ctk.CTkFrame(master=self.container_widgets_bspwm, fg_color='transparent')
        widget_fbcw.pack(side='top', fill='x', pady=10, padx=10)  # Empacar verticalmente con espacio entre ellos 

        entry_fbcw = ctk.CTkEntry(master=widget_fbcw, placeholder_text="#C2F6FC")
        entry_fbcw.pack(side='right', fill='x')
        def update_color_fbcw(event=None):
            color = entry_fbcw.get()
            if color.startswith('#') and len(color) == 7:
                try:
                    # Intentar aplicar el color
                    color_label_fbcw.configure(fg_color=color)
                    return
                except:
                    pass
            # Si no es válido o está vacío, poner gris
            color_label_fbcw.configure(fg_color="gray")

        entry_fbcw.bind("<KeyRelease>", update_color_fbcw)

        label = ctk.CTkLabel(master=widget_fbcw, text="Focused Border Color", font=('Arial', 15))
        label.pack(side='left', fill='y')
        
        # Cuadrado al estilo NvChad, es el primero de todos, para que lo tengas en cuenta jeje 
        color_label_fbcw = ctk.CTkFrame(master=widget_fbcw, fg_color='gray', corner_radius=6, width=17, height=17)
        color_label_fbcw.pack(side=ctk.LEFT, padx=(10, 10))

        def color_label_fbcw_event(event):
            
            color = Picker()

            color = color.get()

            if color: 

                entry_fbcw.delete(0, 'end')
                entry_fbcw.insert(index=0, string=color)

                color_label_fbcw.configure(fg_color=color)

        color_label_fbcw.bind('<Button-1>', color_label_fbcw_event)

        button = ctk.CTkButton(master=widget_fbcw, text="apply", command=lambda: BSPWM.focused_border_color(root=root, border_color=entry_fbcw.get(), entry_widget=entry_fbcw)) 
        button.pack(side='right', padx=10)


        #bspc config normal_border_color "#000000"
        # normal_border_color 
        widget_nbc = ctk.CTkFrame(master=self.container_widgets_bspwm, fg_color='transparent')
        widget_nbc.pack(side='top', fill='x', pady=10, padx=10)  # Empacar verticalmente con espacio entre ellos
        
        entry_nbc = ctk.CTkEntry(master=widget_nbc, placeholder_text="#000000")
        entry_nbc.pack(side='right', fill='x')

        label = ctk.CTkLabel(master=widget_nbc, text="Bpswm Normal Border Color", font=('Arial', 15))
        label.pack(side='left', fill='y')

        button = ctk.CTkButton(master=widget_nbc, text="apply", command=lambda: BSPWM.normal_border_color(root=root, border_color=entry_nbc.get(), entry_widget=entry_nbc)) 
        button.pack(side='right', padx=10)


        color_label_nbc = ctk.CTkFrame(master=widget_nbc, fg_color='gray', corner_radius=6, width=17, height=17)
        color_label_nbc.pack(side='left', padx=(10, 10))

        def color_label_nbc_event(event):
            color = Picker()
            
            color = color.get()
            
            if color: 
                entry_nbc.delete(0, 'end')
                entry_nbc.insert(index=0, string=color)

                color_label_nbc.configure(fg_color=color)

        color_label_nbc.bind('<Button-1>', color_label_nbc_event)

        #bspc config border_width 2 
        # Configure the border 
        widget_cb = ctk.CTkFrame(master=self.container_widgets_bspwm, fg_color='transparent')
        widget_cb.pack(side='top', fill='x', pady=10, padx=10)  # Empacar verticalmente con espacio entre ellos
        
        entry_cb = ctk.CTkEntry(master=widget_cb, placeholder_text="(0 - 9)")
        entry_cb.pack(side='right', fill='x')

        def update_color_nbc(event):
            color = entry_nbc.get()
            if color.startswith('#') and len(color) == 7:
                try:
                    color_label_nbc.configure(fg_color=color)
                    return
                except:
                    pass
            color_label_nbc.configure(fg_color="gray")

        entry_nbc.bind("<KeyRelease>", update_color_nbc)

        label = ctk.CTkLabel(master=widget_cb, text="Bpswm Border (0 - 9)", font=('Arial', 15))
        label.pack(side='left', fill='y')

        button = ctk.CTkButton(master=widget_cb, text="apply", command=lambda: BSPWM.config_border(root=root, border=entry_cb.get(), entry_widget=entry_cb)) 
        button.pack(side='right', padx=10)

    @staticmethod
    def destroy_app(root: Any) -> None:

        value = CTkMessagebox(message='¿Deseas salir?', title='Salir', icon='warning', option_1='Yes', option_2='No')

        if (value.get()) == 'Yes':
            root.destroy()

        return

    def danguer_sect(self, root: Any) -> None:

        # Frame contenedor de 2 widgets 
        self._danguer_frame = ctk.CTkFrame(master=root, corner_radius=10)
        self._danguer_frame.pack(fill='both', padx=10, pady=10)

        # Boton de resetear 
        self._reset_button = ctk.CTkButton(master=self._danguer_frame, corner_radius=10, text='Reset Default', command=lambda: BSPWM.reset_default(master=root, button_widget=self._reset_button))
        self._reset_button.pack(side='right', padx=10, pady=10)

        # Boton de salir 
        self._exit_button = ctk.CTkButton(master=self._danguer_frame, corner_radius=10, text='Salir', hover_color='red', command= lambda: self.destroy_app(root=root))
        self._exit_button.pack(side='left', padx=10, pady=10)
   
    @staticmethod
    def __app__(root: Any):
        root.mainloop()
    
    @staticmethod
    def __update__(label: ctk.CTkFrame, entry_widget: ctk.CTkEntry, palette_window: ctk.CTkToplevel, color) -> None:
        label.configure(fg_color=color)
        entry_widget.delete(0, 'end')
        entry_widget.insert(index=0, string=color)
        palette_window.destroy()
    
    @staticmethod
    def __mouse__(event, scroll_frame: ctk.CTkScrollableFrame) -> None:
        scroll_frame._parent_canvas.yview_scroll(int(-1*(event.delta/120)), "units")

    @staticmethod
    def __configure__(root: Any) -> None:
        ctk.set_appearance_mode(mode_string='Dark')
        root.geometry('800x450')

    def in_bspwm(self, root: Any) -> None:
        if os.getenv(key='DESKTOP_SESSION') != 'bspwm':
            print("\n[!] Este script solo puede ser ejecutado en bspwm!")
            sys.exit(1)
            
if __name__ == "__main__":
    editor = Editor()
