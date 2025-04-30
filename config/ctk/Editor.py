#!/usr/bin/env python
import sys
import customtkinter as ctk 
from CTkMessagebox import CTkMessagebox
import subprocess, re, os 
from PIL import Image
from tkinter import filedialog
import cv2, random 

def is_hex(color_entry) -> bool:

    if not re.fullmatch(r"#([A-Fa-f0-9]{6})", color_entry):
        return False

    return True

def is_running(app: str) -> bool:

    return bool(subprocess.Popen(['pgrep', '-x', app], stdout=subprocess.PIPE, stderr=subprocess.PIPE).communicate())

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

            return 
        else:
            CTkMessagebox(message='Esto no parece ser un color ANSII', title='Ups!!', icon='warning')
        
        if entry_widget.get():
            entry_widget.delete(0, 'end')
        return 

    @staticmethod
    def normal_border_color(root: ctk.CTk, border_color, entry_widget: ctk.CTkEntry):

        if not border_color: return 

        if is_hex(border_color):
            process = subprocess.Popen(['bspc', 'config', 'normal_border_color', border_color], stdout=subprocess.PIPE, stderr=subprocess.PIPE)

            process.communicate()

            return 
        else:
            CTkMessagebox(message='Esto no parece ser un color ANSII', title='Ups!!', icon='warning')
        
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

        # Create the danguer sect 
        self.danguer_sect(root=self.root)

        # Start the app
        self.__app__(root=self.root)

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
            palette_window = ctk.CTkToplevel()
            palette_window.title("Elige un color")
            palette_window.geometry("600x600")
            palette_window.lift()
            palette_window.focus_force()

            # Scrollable Frame para los colores
            scroll_frame = ctk.CTkScrollableFrame(palette_window, width=780, height=580)
            scroll_frame.pack(padx=10, pady=10, fill="both", expand=True)

            # Lista de 100 colores HEX aleatorios
            colors = [f'#{random.randint(0, 0xFFFFFF):06x}' for _ in range(100)]

            def _on_mousewheel(event):
                scroll_frame._parent_canvas.yview_scroll(int(-1*(event.delta/120)), "units")

            scroll_frame.bind_all("<MouseWheel>", _on_mousewheel)  # Windows y Linux
            scroll_frame.bind_all("<Button-4>", lambda e: scroll_frame._parent_canvas.yview_scroll(-1, "units"))  # Mac arriba
            scroll_frame.bind_all("<Button-5>", lambda e: scroll_frame._parent_canvas.yview_scroll(1, "units"))   # Mac abajo

            for idx, color in enumerate(colors):
                row = idx // 5   # 5 columnas por fila
                col = idx % 5

                # Botón de color grande
                color_button = ctk.CTkButton(
                    scroll_frame, 
                    width=80, 
                    height=80,
                    fg_color=color,
                    hover_color=color,
                    text="",
                    command= lambda c=color: self.__update__(label=color_label_fbcw, entry_widget=entry_fbcw, palette_window=palette_window, color=c)
                )
                color_button.grid(row=row*2, column=col, padx=15, pady=10)

                # Entry grande debajo del botón
                color_entry = ctk.CTkEntry(
                    scroll_frame, 
                    width=80,
                    height=30,
                    justify="center",
                    font=("Arial", 14)
                )
                color_entry.grid(row=row*2+1, column=col, padx=15, pady=(0, 20))
                color_entry.insert(0, color)
                color_entry.configure(state="readonly") 

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
            palette_window2 = ctk.CTkToplevel()
            palette_window2.title("Elige un color")
            palette_window2.geometry("600x600")
            palette_window2.lift()
            palette_window2.focus_force()

            # Scrollable Frame para los colores
            scroll_frame = ctk.CTkScrollableFrame(palette_window2, width=780, height=580)
            scroll_frame.pack(padx=10, pady=10, fill="both", expand=True)
            
            def _on_mousewheel(event):
                scroll_frame._parent_canvas.yview_scroll(int(-1*(event.delta/120)), "units")

            scroll_frame.bind_all("<MouseWheel>", _on_mousewheel)  # Windows y Linux
            scroll_frame.bind_all("<Button-4>", lambda e: scroll_frame._parent_canvas.yview_scroll(-1, "units"))  # Mac arriba
            scroll_frame.bind_all("<Button-5>", lambda e: scroll_frame._parent_canvas.yview_scroll(1, "units"))   # Mac abajo


            # Lista de 100 colores HEX aleatorios
            colors = [f'#{random.randint(0, 0xFFFFFF):06x}' for _ in range(100)]

            for idx, color in enumerate(colors):
                row = idx // 5   # 5 columnas por fila
                col = idx % 5

                # Botón de color grande
                color_button = ctk.CTkButton(
                    scroll_frame, 
                    width=80, 
                    height=80,
                    fg_color=color,
                    hover_color=color,
                    text="",
                    command= lambda c=color: self.__update__(label=color_label_nbc, entry_widget=entry_nbc, palette_window=palette_window2, color=c)
                )
                color_button.grid(row=row*2, column=col, padx=15, pady=10)

                # Entry grande debajo del botón
                color_entry = ctk.CTkEntry(
                    scroll_frame, 
                    width=80,
                    height=30,
                    justify="center",
                    font=("Arial", 14)
                )
                color_entry.grid(row=row*2+1, column=col, padx=15, pady=(0, 20))
                color_entry.insert(0, color)
                color_entry.configure(state="readonly") 

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
        root.geometry('800x700')

    def in_bspwm(self, root: ctk.CTk) -> None:
        if os.getenv(key='DESKTOP_SESSION') != 'bspwm':
            print("\n[!] Este script solo puede ser ejecutado en bspwm!")
            sys.exit(1)
            

if __name__ == "__main__":
    editor = Editor()
