-- This file needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :( 

---@type ChadrcConfig
local M = {}

M.base46 = {
	theme = "yoru", -- theme = 'onedark', el tema original de nvim
  transparency = false, -- o true si quieres activar la transparencia
	hl_override = {
	Comment = { 
      italic = true 
    },
	["@comment"] = { 
      italic = true, -- Aqui defininos si queremos ver los comentarios en cursiva 
--      underline = true, -- Esto define si queremos ver subrayado en los comentariops
--      bold = true, -- Esto define si queremos ver comentarios en negrita
    },
	},
}

-- M.nvdash = { load_on_startup = true }
 M.ui = {
        statusline = {
          theme = 'default', -- default, vscode, minimal, vscode_colored -> Esto cambia la linea de abajo
        },

       tabufline = { 
                    lazyload = false,
                    enabled = true,
       },
      cmp = {
      style = 'default',  -- Esto cambia la apariencia de las sugerencias de nvim 
      },
}

vim.defer_fn(function()
  require("minty").setup()
end, 100)


return M
