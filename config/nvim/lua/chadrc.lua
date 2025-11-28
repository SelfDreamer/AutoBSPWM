-- This file needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :( 

---@type ChadrcConfig
local M = {}
M.base46 = {
    theme = "catppuccin", -- theme = 'onedark', el tema original de nvim
    ---@type boolean
    transparency = false, -- o true si quieres activar la transparencia. Pero se ve mal xd 
    theme_toggle = {"catppuccin", "vscode_light"},
    hl_override = {
      CursorLineNr = { 
        fg = "#ee9561",
        ---@type boolean
        bold = true,
      },
    Comment = { 
      italic = true,   
    },
    ["@comment"] = { 
      italic = true, -- Aqui defininos si queremos ver los comentarios en cursiva 
--      underline = true, -- Esto define si queremos ver subrayado en los comentariops
      -- bold = true, -- Esto define si queremos ver comentarios en negrita
    }, 
  },  
}
-- M.nvdash = { load_on_startup = true }
M.ui = {
      statusline = {
        enabled = false,
        theme = 'minimal', -- default, vscode, minimal, vscode_colored -> Esto cambia la linea de abajo
        separator_style = 'round', -- Define como quieres que se vean los esparadores. Variable de tipo Literal['round', 'block', 'default'. 'arrow'] 
      },
     tabufline = { 
                  enabled = true, -- Plugin de la parte superior del editor para mostrar el archivo en el que estas trabajando, asimismo el boton de salir y el switch para el tema  
                  lazyload = false, -- Si Lazy esta en true, la barra cargara cuando haiga mas de 1 archivo. Lazy en programación puede significar para mi que carga recursos a medida que el usuario lo requiere. En este caso, si esta en true, cargara la barra a medida que haigan mas archivos, mas de 1 archivo en concreto.  
     },
    cmp = {
      lspkind_text = true,
      style = 'flat_dark',  -- Esto cambia la apariencia de las sugerencias de nvim 
    },
}

return M
