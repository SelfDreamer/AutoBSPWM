#!/usr/bin/env python
import customtkinter
from tkcolorpicker.gradientbar import GradientBar
from tkcolorpicker.colorsquare import ColorSquare
from tkcolorpicker.alphabar import AlphaBar
from tkcolorpicker.functions import hexa_to_rgb, col2hue, rgb_to_hsv

class CTkAdvancedColorPicker(customtkinter.CTkFrame):
    """
    Advanced color picker
    by Akascape
    """
    def __init__(self,
                 master,
                 color="#000000",
                 command=None, **kwargs):
        
        super().__init__(master, **kwargs)
        try:
            col = hexa_to_rgb(color)
            hue = col2hue(*col[:3])
        except:
            raise ValueError("Color must be a hex string")

        self.command = command
        self._color_selected = False  # Flag para saber si se seleccionó un color

        self.bar = GradientBar(self, hue=hue, width=200, highlightthickness=0)
        self.bar.pack(fill="x")

        self.square = ColorSquare(self, hue=hue, width=200, color=rgb_to_hsv(*col[:3]), height=200, highlightthickness=0)
        self.square.pack(fill="both", expand=True)

        self.button = customtkinter.CTkButton(self, text=color, height=10, border_width=0,
                                              corner_radius=5, fg_color=color, hover=False)
        self.button.pack(fill="x", pady=(5, 0))

        self.quit_button = customtkinter.CTkButton(self, text="Salir", command=self._quit, fg_color="red")
        self.quit_button.pack(fill="x", pady=(5, 5))

        self.square.bind("<ButtonRelease-1>", self._change_sel_color, True)
        self.square.bind("<B1-Motion>", self._change_sel_color, True)
        self.bar.bind("<B1-Motion>", self._change_color, True)
        self.bar.bind("<ButtonRelease-1>", self._change_color, True)

    def _change_sel_color(self, event):
        color = self.square.get()[2]
        self.button.configure(fg_color=color, text=color)
        self._color_selected = True  # Marca que el usuario eligió un color

        r, g, b = self.square.get()[0]
        if r > 170 and g > 170 and b > 170:
            self.button.configure(text_color="black")
        else:
            self.button.configure(text_color="white")

        if self.command:
            self.command(self.get())

    def _change_color(self, event):
        h = self.bar.get()
        self.square.set_hue(h)
        self._change_sel_color(None)

    def set(self, color):
        self.winfo_toplevel().update()
        col = hexa_to_rgb(color)
        hue = col2hue(*col[:3])
        self.square.set_hue(hue)
        self.square.set_hsv(rgb_to_hsv(*col[:3]))
        self.bar.set(hue)
        self._change_sel_color(None)

    def get(self):
        if self._color_selected:
            return self.square.get()[2]
        else:
            return None

    def _quit(self):
        self._color_selected = False  # Por si acaso
        self.winfo_toplevel().destroy()
