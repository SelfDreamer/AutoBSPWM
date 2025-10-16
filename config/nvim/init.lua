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
  highlight DiagnosticVirtualTextError guifg=#e06c75 gui=NONE
  highlight DiagnosticVirtualTextWarn guifg=#e7c787 gui=NONE
  highlight DiagnosticVirtualTextInfo guifg=#8be9fd gui=NONE
  highlight DiagnosticVirtualTextHint guifg=#d398fd gui=NONE

  " Colores para el borde del cuadro emergente (popup)
  highlight DiagnosticFloatingError guifg=#e06c75 guibg=#282a36
  highlight DiagnosticFloatingWarn guifg=#e7c787 guibg=#282a36
  highlight DiagnosticFloatingInfo guifg=#7be9fd guibg=#282a36
  highlight DiagnosticFloatingHint guifg=#bd93f9 guibg=#282a36
]]

vim.diagnostic.config({
  virtual_text = { prefix = "" },
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

vim.notify = require("notify")

require("mason").setup({
  ui = { border = "rounded" },
})

local orig_notify = vim.notify
vim.notify = function(msg, ...)
  if msg:match("vim.tbl_islist is deprecated") then
    return
  end
  orig_notify(msg, ...)
end

vim.deprecated = nil
vim.tb_islist = vim.tbl_islist(...)

vim.diagnostic.config({
  virtual_text = false,
})


require("snacks.input").enable()

-- Configuración de lsp_lines
lsp_lines = require("lsp_lines")
lsp_lines.setup()
lsp_lines.toggle()
vim.cmd('lua require("lsp_lines").toggle()')
