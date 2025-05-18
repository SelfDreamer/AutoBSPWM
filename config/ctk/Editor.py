#!/usr/bin/env python
import customtkinter as ctk 
from CTkMessagebox import CTkMessagebox
import subprocess, re, os, sys, cv2, random 
from PIL import Image
from tkinter import filedialog 
from CTkColorPicker import AskColor

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

class BSPWM():
    
    distro = os.popen(cmd='lsb_release -d | grep -oP "Parrot|Kali"').read().strip()

    if distro == 'Kali':

        backends = ['glx', 'xrender', 'egl', 'dummy']
    else: 

        backends = ['glx', 'xrender']

    def __init__(self, root: ctk.CTk) -> None:
        self.root = root 
    
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
    def normal_border_color(root: ctk.CTk, border_color, entry_widget: ctk.CTkEntry):

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
    def put_backend(backend, master: ctk.CTk, ruta: str):

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
            CTkMessagebox(title='Error', message='Backend no válido. Usa "glx" o "xrender".', icon='cancel', master=master)
            return

        try:
            with open(ruta, "r", encoding="utf-8") as f:
                contenido = f.read()
        except FileNotFoundError:
            CTkMessagebox(title='Error', message=f'No se encontró el archivo:\n{ruta}', icon='cancel', master=master)
            return

        match = re.search(r'(backend\s*=\s*")[^"]+(")', contenido)
        if match:
            backend_actual = match.group(0).split('=')[1].strip().strip('"')
            if backend_actual == backend:
                CTkMessagebox(title='Sin cambios', message=f'El backend ya está establecido como "{backend}".', icon='info', master=master)
                return
        else:
            CTkMessagebox(title='Error', message='No se encontró una línea con "backend = ..." en el archivo.', icon='cancel', master=master)
            return

        nuevo_contenido = re.sub(r'(backend\s*=\s*")[^"]+(")', fr'\1{backend}\2', contenido)

        try:
            with open(ruta, "w", encoding="utf-8") as f:
                f.write(nuevo_contenido)
            CTkMessagebox(title='Éxito', message=f'Se cambió el backend a "{backend}".', icon='check', master=master)
        except Exception as e:
            CTkMessagebox(title='Error', message=f'No se pudo escribir el archivo:\n{e}', icon='cancel', master=master)


    @staticmethod
    def browse_wallpaper(master: ctk.CTk, entry_widget: ctk.CTkEntry):

        image_path = filedialog.askopenfilename(parent=master, title='Selecciona un archivo')
        
        if image_path:

            BSPWM.put_wallpaper(master=master, image_path=image_path, entry_widget=entry_widget)


    @staticmethod
    def config_border(root: ctk.CTk, border, entry_widget: ctk.CTkEntry): 
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
            
            process = subprocess.run("bspc wm -r", shell=True, stdout=True).stdout 

        return 
    
    @staticmethod
    def is_video(image_path):

        cap = cv2.VideoCapture(image_path)
        if cap.isOpened():  # Si el archivo se puede abrir como video
            return True

        return False

    @staticmethod
    def ANIMATED_WALL(image_path):
        CMD = f'''if pgrep -x xwinwrap; then 
            AnimatedWall --stop
            pkill xwinwrap
        fi 
        AnimatedWall --start {image_path}
        '''

        process = subprocess.run(CMD, stdout=True, stderr=True, shell=True).stdout

    @staticmethod 
    def put_wallpaper(master: ctk.CTk, image_path, entry_widget: ctk.CTkEntry) -> None:

        if not image_path: 

            entry_widget.configure(placeholder_text='Wallpaper.jpg...')
            return 

        if image_path.startswith("~"):
            image_path = os.path.expanduser(image_path)
       
        if not os.path.exists(path=image_path):

             CTkMessagebox(master=master, message='No Such File Or Directory', title='Error', icon='cancel')
             entry_widget.delete(0, 'end')
             entry_widget.configure(placeholder_text='Wallpaper.jpg...')
             return 

        if not is_valid_image(image_path):

            if BSPWM.is_video(image_path):
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
    def put_corner_radius(corner_radius, root: ctk.CTk, entry_widget, config_file='~/.config/picom/picom.conf'):

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
                    CTkMessagebox(message=f'El corner radius ya es {new_value}', master=root, title='Info')
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

        CTkMessagebox(message=f'corner-radius actualizado a {new_value}', master=root, title='Info')

    @staticmethod
    def is_active_animations(file_config: str='~/.config/picom/picom.conf'): 
        
        file_config = os.path.expanduser(file_config)

        with open(file_config, 'r') as file: 

            for line in file: 

                if re.match(pattern='@include "picom-animations.conf"', string=line.strip()): 

                    return True 


        return False 

    @staticmethod
    def put_animations(master: ctk.CTk, switch: ctk.CTkSwitch):
        
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
        switch = ctk.CTkSwitch(master=frame, onvalue=1, offvalue=0, text='Animations', command=lambda: BSPWM.put_animations(master=master, switch=switch))
        switch.pack(side='right', fill='x', padx=10, pady=10)

        if BSPWM.is_active_animations():

            switch.select()
        else:

            switch.deselect()    

    @staticmethod
    def is_active_fadding():
            
        file = '~/.config/picom/picom.conf'
        file = os.path.expanduser(file)

        with open(file, 'r') as f: 

            for line in f:
                if line.strip() == 'fading = true': return True 


        return False 

    @staticmethod
    def PUT_FADING(master: ctk.CTk, new_state, archivo_picom='~/.config/picom/picom.conf'):
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
                    CTkMessagebox(message='¡Fading activado correctamente!', title='Activado', icon='info', master=master)
                else:
                    CTkMessagebox(message='Fading desactivado correctamente.', title='Desactivado', icon='info', master=master)
            else:
                CTkMessagebox(message='No se encontró la línea "fading" en el archivo :(', title='Error', icon='cancel', master=master)

        except Exception as e:
            CTkMessagebox(message=f'Error al procesar el archivo:\n{e}', title='Error', icon='cancel', master=master)
        
    @staticmethod
    def PICOM_FADDING(master: ctk.CTk, frame: ctk.CTkFrame):

        switch = ctk.CTkSwitch(master=frame, text='Fadding', onvalue=1, offvalue=0, command=lambda: BSPWM.PUT_FADING(master=master, new_state=switch.get()))
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
    
    def Put_Font_size(font_size : str, master: ctk.CTk, entry_widget : ctk.CTkEntry, kitty_file : str = '~/.config/kitty/kitty.conf'):
        
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

                CTkMessagebox(master=master, title = 'Error', message = f'Error ocurrido {err.decode()}')
        
            with open(kitty_file, "r") as archivo:
                lineas = archivo.readlines()

            nuevas_lineas = []
            for linea in lineas:
                # Reemplaza 'font_size' seguido de 1 a 3 dígitos por 'font_size 22'
                nueva_linea = re.sub(r"^font_size\s+\d{1,3}", f"font_size {font_size}", linea)
                nuevas_lineas.append(nueva_linea)

            with open(kitty_file, "w") as archivo:

                archivo.writelines(nuevas_lineas)        

            CTkMessagebox(master=master, message = 'Tamaño de fuente aplicado', title = 'Info', icon = 'info')

        else:

            entry_widget.delete(0, 'end')
            entry_widget.configure(placeholder_text=f'Font Size ({BSPWM.Get_FontSize()})')
            CTkMessagebox(master=master, title = 'Invalid Font Size', message = f'El tamaño de fuente debe de ser un numero entero!', icon='error')

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
        background_opacity_label.pack(side='left', fill='y')
        
        entry_background_size = ctk.CTkSlider(master=frame, from_=0.0, to=1.0, width=135, command = lambda value: BSPWM.UpdateLabel(value, label=background_opacity_label))#, #placeholder_text=f'Font Size ({BSPWM.Get_FontSize()})')
        entry_background_size.set(background_opacity)
        entry_background_size.pack(side='right', fill='x')

        button_apply_back_size = ctk.CTkButton(master=frame, text='Apply', command = lambda: BSPWM.UpdateBackgroundOpacity(master=master, opacity=entry_background_size.get()))
        button_apply_back_size.pack(side='right', padx=14)

    @staticmethod
    def UpdateLabel(value: float, label: ctk.CTkLabel) -> None:
        text = (f"{float(value):.2f}")

        label.configure(text=f'Kitty Background Opacity {text}')

    @staticmethod
    def UpdateBackgroundOpacity(master: ctk.CTk, opacity: float, kitty_file : str = '~/.config/kitty/kitty.conf'):
        
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

        CTkMessagebox(master=master, message='Opacidad aplicada', title='Info', icon='info')
    
    @staticmethod
    def UpgradeBackgroundColor(color: str, Entry_Widget: ctk.CTkEntry, master: ctk.CTk, frame: ctk.CTkFrame) -> None: 

        if not color.strip():

            return 

        if not is_hex(color_entry=color):
            Entry_Widget.delete(0, 'end')
            Entry_Widget.configure(placeholder_text='#000000')
            CTkMessagebox(message='Esto no parece ser un color en hexadecimal', title='Info', icon='info', master=master)
            return
        # kitter --background-color '#000000'
        process = subprocess.Popen(['kitter', '--background-color', f'{color}'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)

        out, err = process.communicate()

        BSPWM.UpdateColorFile(color)

    @staticmethod
    def UpdateColorFile(color: str, file: str = '~/.config/kitty/color.ini'):

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

        CTkMessagebox(message=f'background {color} aplicado', title='Mensaje', icon='info')

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
    def Apply_foreground(foreground: str, entry_widget: ctk.CTkEntry, master: ctk.CTk, config_file: str = '~/.config/kitty/color.ini') -> None:
        
        if config_file.startswith('~'):
            config_file = os.path.expanduser(config_file)

        if not foreground:
            return

        if not is_hex(foreground):
            
            entry_widget.delete(0, 'end')
            entry_widget.configure(placeholder_text=f'{BSPWM.GetForeground()}')
            CTkMessagebox(message='Esto no parece ser un color en hexadecimal!', title='Error', icon='warning')
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
        
        CTkMessagebox(message=f'Foreground {foreground} aplicado', title='Mensaje', icon='info')


class Editor():

    def __init__(self) -> None:
        

        self.root = ctk.CTk()
        
        # Validation if we in bspwm
        self.in_bspwm(root=self.root)

        # Configure the app 
        self.__configure__(root=self.root)

        # Create secction bspwm
        self.create_bspwm_sec(root=self.root)

        # Creathe the wallpaper secction
        self.create_wallpaper_sec(root=self.root)

        # Create the picom secction
        self.create_picom_sec(root=self.root)

        # Create the kitty section 
        self.create_kitty_sec(root=self.root)

        # Create the danguer sect 
        self.danguer_sect(root=self.root)

        # Start the app
        self.__app__(root=self.root)

    def create_kitty_sec(self, root: ctk.CTk) -> None: 
        background_color = BSPWM.GetBackgroundColor()
        # Frame que contendra los widgets para la configuracion de kitty 
        container_widgets_kitty = ctk.CTkFrame(master=root)
        container_widgets_kitty.pack(pady=10, fill='x', padx=10)

        # Kitty font size 
        kitty_font_size_frame = ctk.CTkFrame(master=container_widgets_kitty, fg_color='transparent')
        kitty_font_size_frame.pack(pady=10, fill='x', padx=10)
        
        label_font_size = ctk.CTkLabel(master=kitty_font_size_frame, fg_color='transparent', text=f'Kitty Font Size', font=('Arial', 15))
        label_font_size.pack(side='left', fill='y')
        
        entry_font_size = ctk.CTkEntry(master=kitty_font_size_frame, placeholder_text=f'Font Size ({BSPWM.Get_FontSize()})')
        entry_font_size.pack(side='right', fill='x')

        button_apply_font_size = ctk.CTkButton(master=kitty_font_size_frame, text='Apply', command=lambda:BSPWM.Put_Font_size(font_size=entry_font_size.get(), entry_widget=entry_font_size, master=root))
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
            color = AskColor()

            color = color.get()

            if color: 

                entry_label_kitty.delete(0, 'end') 
                entry_label_kitty.insert(index=0, string=color)
    
                color_label_kitty.configure(fg_color=color)

        color_label_kitty.bind("<Button-1>", command=kitty_frame_label)

        entry_label_kitty = ctk.CTkEntry(master=kitty_background_color_frame, placeholder_text=background_color)
        entry_label_kitty.pack(side='right', fill='x')

        button_kitty_apply = ctk.CTkButton(master=kitty_background_color_frame, text='Apply', command = lambda: BSPWM.UpgradeBackgroundColor(entry_label_kitty.get(), entry_label_kitty, root, kitty_background_color_frame))
        button_kitty_apply.pack(side='right', padx=10)
        def update_background_frame_kitty(event):
            color = entry_label_kitty.get()
            if color.startswith('#') and len(color) == 7:
                try:
                    # Intentar aplicar el color
                    color_label_kitty.configure(fg_color=color)
                    return
                except:
                    pass
            # Si no es válido o está vacío, poner gris
            color_label_kitty.configure(fg_color="gray")

        entry_label_kitty.bind("<KeyRelease>", update_background_frame_kitty)
        
        # Last label foreground #a9b1d6 kitty 
        foreground_frame_kitty = ctk.CTkFrame(master=container_widgets_kitty, fg_color='transparent')
        foreground_frame_kitty.pack(pady=10, fill='x', padx=10)

        foreground_label = ctk.CTkLabel(master=foreground_frame_kitty, fg_color='transparent', font=('Arial', 15), text='Kitty Foreground')
        foreground_label.pack(side='left', fill='y')
        
        # Frame al estilo NvChad, es el ultimo para la configuración de la kitty, para que lo tengas en cuenta.
        frame_foreground_kitty = ctk.CTkFrame(master=foreground_frame_kitty, fg_color='gray', corner_radius=6, width=17, height=17)
        frame_foreground_kitty.pack(side='left', padx=(10, 10))

        
        foreground = BSPWM.GetForeground()
        entry_foreground_kitty = ctk.CTkEntry(master=foreground_frame_kitty, placeholder_text=foreground)
        entry_foreground_kitty.pack(side='right', fill='x') 
        def update_foreground_frame_kitty(event):
            color = entry_foreground_kitty.get()
            if color.startswith('#') and len(color) == 7:
                try:
                    # Intentar aplicar el color
                    frame_foreground_kitty.configure(fg_color=color)
                    return
                except:
                    pass
            # Si no es válido o está vacío, poner gris
            frame_foreground_kitty.configure(fg_color="gray")

        entry_foreground_kitty.bind("<KeyRelease>", update_foreground_frame_kitty)

        foreground_kitty_apply = ctk.CTkButton(master=foreground_frame_kitty, text='Apply', command=lambda: BSPWM.Apply_foreground(foreground=entry_foreground_kitty.get(), entry_widget=entry_foreground_kitty, master=root))
        foreground_kitty_apply.pack(side='right', padx=10)
        def kitty_foreground_frame(event):
            color = AskColor()

            color = color.get()
            
            if color: 
                entry_foreground_kitty.delete(0, 'end') 
                entry_foreground_kitty.insert(index=0, string=color)

                frame_foreground_kitty.configure(fg_color=color)

        frame_foreground_kitty.bind("<Button-1>", command=kitty_foreground_frame)


    def create_picom_sec(self, root: ctk.CTk):
        # Frame que contendra los widgets para la configuración de picom
        container_widgets_picom = ctk.CTkFrame(self.root)
        container_widgets_picom.pack(pady=10, fill='x', padx=10)

        # Backend picom 
        widget_backend_frame = ctk.CTkFrame(master=container_widgets_picom, fg_color='transparent')
        widget_backend_frame.pack(side='top', fill='x', pady=10, padx=10)  # Empacar verticalmente con espacio entre ellos 
            
        # Label 
        label_backend = ctk.CTkLabel(master=widget_backend_frame, fg_color='transparent', text='Picom Backend', font=('Arial', 15))
        label_backend.pack(side='left', fill='y')

        entry_backend = ctk.CTkOptionMenu(master=widget_backend_frame, values=BSPWM.backends)
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
        self.widget_corner_radius.pack(side='left', fill='y')

#        entry_corner_radius = ctk.CTkEntry(master=frame_corner_radius, placeholder_text='0')
#        entry_corner_radius.pack(side='right')
        entry_corner_radius = ctk.CTkSlider(master=frame_corner_radius, from_=0, to=50, number_of_steps=50, width=135, command=self.update_radius)

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


    def create_wallpaper_sec(self, root: ctk.CTk) -> None:
        
        # Frame que contendra los widgets para la configuración del wallpaper
        self.container_widgets_wallpaper = ctk.CTkFrame(self.root)
        self.container_widgets_wallpaper.pack(pady=10, fill='x', padx=10)

        widget_wallpaper = ctk.CTkFrame(master=self.container_widgets_wallpaper, fg_color='transparent')
        widget_wallpaper.pack(side='top', fill='x', pady=10, padx=10)  # Empacar verticalmente con espacio entre ellos 

        entry_wallpaper = ctk.CTkEntry(master=widget_wallpaper, placeholder_text="Wallpaper.jpg...") 
        entry_wallpaper.pack(side='right', fill='x')

        label = ctk.CTkLabel(master=widget_wallpaper, text="Put an wallpaper", font=('Arial', 15))
        label.pack(side='left', fill='y')

        button = ctk.CTkButton(master=widget_wallpaper, text="apply", command=lambda: BSPWM.put_wallpaper(master=root, image_path=entry_wallpaper.get(), entry_widget=entry_wallpaper)) 
        button.pack(side='right', padx=10)

        button = ctk.CTkButton(master=widget_wallpaper, text="Browse", command=lambda: BSPWM.browse_wallpaper(master=root, entry_widget=entry_wallpaper)) 
        button.pack(side='right', padx=10)


    def create_bspwm_sec(self, root: ctk.CTk) -> None:
        # 'TITULO' para la ventana, ya que no se puede ver un titulo real en bspwm
        self.tittle_sect = ctk.CTkFrame(master=root)
        self.tittle_sect.pack(side='top', fill='x')
        
        # Create the title 
        self.title_label = ctk.CTkLabel(master=self.tittle_sect, text="bspwm settings", font=("Arial", 18))
        self.title_label.pack(pady=10)
        
        # Create Frame for the widgets 
        self.container_widgets_bspwm = ctk.CTkFrame(self.root)
        self.container_widgets_bspwm.pack(pady=10, fill='x', padx=10)

        # focused_border_color widget 
        widget_fbcw = ctk.CTkFrame(master=self.container_widgets_bspwm, fg_color='transparent')
        widget_fbcw.pack(side='top', fill='x', pady=10, padx=10)  # Empacar verticalmente con espacio entre ellos 

        entry_fbcw = ctk.CTkEntry(master=widget_fbcw, placeholder_text="#C2F6FC")
        entry_fbcw.pack(side='right', fill='x')

        def update_color_fbcw(event):
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
        color_label_fbcw.pack(side='left', padx=(10, 10))

        def color_label_fbcw_event(event):
            
            color = AskColor()

            color = color.get()

            if color: 

                entry_fbcw.delete(0, 'end')
                entry_fbcw.insert(index=0, string=color)

                color_label_fbcw.configure(fg_color=color)

        color_label_fbcw.bind('<Button-1>', color_label_fbcw_event)

        button = ctk.CTkButton(master=widget_fbcw, text="apply", command=lambda: BSPWM.focused_border_color(root=self.root, border_color=entry_fbcw.get(), entry_widget=entry_fbcw)) 
        button.pack(side='right', padx=10)


        #bspc config normal_border_color "#000000"
        # normal_border_color 
        widget_nbc = ctk.CTkFrame(master=self.container_widgets_bspwm, fg_color='transparent')
        widget_nbc.pack(side='top', fill='x', pady=10, padx=10)  # Empacar verticalmente con espacio entre ellos
        
        entry_nbc = ctk.CTkEntry(master=widget_nbc, placeholder_text="#000000")
        entry_nbc.pack(side='right', fill='x')

        label = ctk.CTkLabel(master=widget_nbc, text="Bpswm Normal Border Color", font=('Arial', 15))
        label.pack(side='left', fill='y')

        button = ctk.CTkButton(master=widget_nbc, text="apply", command=lambda: BSPWM.normal_border_color(root=self.root, border_color=entry_nbc.get(), entry_widget=entry_nbc)) 
        button.pack(side='right', padx=10)


        color_label_nbc = ctk.CTkFrame(master=widget_nbc, fg_color='gray', corner_radius=6, width=17, height=17)
        color_label_nbc.pack(side='left', padx=(10, 10))

        def color_label_nbc_event(event):
            color = AskColor()
            
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
    def destroy_app(root: ctk.CTk) -> None:

        value = CTkMessagebox(message='¿Deseas salir?', title='Salir', icon='warning', option_1='Yes', option_2='No')

        if (value.get()) == 'Yes':
            root.destroy()

        return

    def danguer_sect(self, root: ctk.CTk) -> None:

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
    def __app__(root: ctk.CTk):
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
    def __configure__(root: ctk.CTk) -> None:
        ctk.set_appearance_mode(mode_string='Dark')
        root.geometry('800x870')

    def in_bspwm(self, root: ctk.CTk) -> None:
        if os.getenv(key='DESKTOP_SESSION') != 'bspwm':
            print("\n[!] Este script solo puede ser ejecutado en bspwm!")
            sys.exit(1)
            
if __name__ == "__main__":
    editor = Editor()
