require "yanks"

vim.opt.termguicolors = true
vim.deprecated = nil
vim.tb_islist = vim.tbl_islist(...)

_G.dd = function(...)
  Snacks.debug.inspect(...)
end
_G.bt = function()
  Snacks.debug.backtrace()
end
vim.print = _G.dd 

vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "
vim.opt.listchars = "tab:»·,trail:·"
-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

vim.cmd("set nolist")

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },
  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)

local x = vim.diagnostic.severity

-- Definir colores manualmente para los signos de diagnóstico
vim.cmd [[
  " Colores para los signos de diagnóstico (iconos en la izquierda)
  highlight DiagnosticSignError guifg=#e06c75 gui=bold
  highlight DiagnosticSignWarn guifg=#e7c787 gui=bold
  highlight DiagnosticSignInfo guifg=#8be9fd gui=bold
  highlight DiagnosticSignHint guifg=#d398fd gui=bold

  " Colores para los mensajes en la línea virtual (sin estilos raros)
  highlight DiagnosticVirtualTextError cterm=italic gui=italic guifg=#f38ba9 guibg=#32283b 
  highlight DiagnosticVirtualTextWarn cterm=italic gui=italic guifg=#f9e2b0 guibg=#33313b 
  highlight DiagnosticVirtualTextInfo cterm=italic gui=italic guifg=#89dcec guibg=#283041 
  highlight DiagnosticVirtualTextHint cterm=italic gui=italic guifg=#d398fd guibg=#282a36 


  " Colores para el borde del cuadro emergente (popup)
  highlight DiagnosticFloatingError guifg=#e06c75 guibg=#282a36
  highlight DiagnosticFloatingWarn guifg=#e7c787 guibg=#282a36
  highlight DiagnosticFloatingInfo guifg=#7be9fd guibg=#160b3d
  highlight DiagnosticFloatingHint guifg=#bd93f9 guibg=#282a36
]]

vim.diagnostic.config({
  virtual_text = true,
  virtual_lines = { current_line = true },
  update_in_insert = false,
  signs = {
    text = {
      [x.ERROR] = "󰅙",
      [x.WARN] = "",
      [x.INFO] = "󰋼",
      [x.HINT] = "󰌵"
    }
  },
  underline = true,
  float = { border = "single" },
})

-- Asegurar que los signos personalizados se aplican correctamente con colores
for type, icon in pairs({
  Error = "󰅙",
  Warn = "",
  Info = "󰋼",
  Hint = "󰌵"
}) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

require("mason").setup({
  ui = { border = "rounded" },
})


require("snacks.input").enable()


local cmp = require("cmp")

cmp.setup({
    window = {
        completion = cmp.config.window.bordered({
            border = "rounded",
            scrollbar = true,       
            max_width = 60,
            max_height = 12,
        }),
        documentation = cmp.config.window.bordered({
            border = "rounded",
            scrollbar = true,
            max_height = 15,
        }),
    }, 
    mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs(-2),
    ['<C-f>'] = cmp.mapping.scroll_docs(2),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),

  experimental = {
    ghost_text = true,
  },

})

local orig = vim.lsp.util.open_floating_preview

function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = "rounded"  -- << aquí lo haces redondeado

  opts.max_width = 200
  opts.max_height = 200

  return orig(contents, syntax, opts, ...)
end



