pcall(require, "menu")
require "nvchad.mappings"
local menu = require("menu")
local menu_utils = require("menu.utils")
local lsp_lines = require("lsp_lines")

local is_lsplines_enabled = true
local snacks = require "snacks"

local map = vim.keymap.set

vim.keymap.set("n", "<C-A-t>", "<cmd>FloatermToggle<cr>", {
  desc = "Toggle terminal"
      }
)

vim.keymap.set({ "n", "v" }, "<RightMouse>", function()
  menu_utils.delete_old_menus()

  local buf = vim.api.nvim_win_get_buf(vim.fn.getmousepos().winid)
  local ft = vim.bo[buf].ft

  local options
  if ft == "NvimTree" then
    options = "nvimtree"
  elseif ft == "markdown" then
    options = "markdown"   
  else
    options = "default" 
  end

  menu.open(options, {
    mouse = true,
    border = true,
  })
end, {})


vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
        package.loaded["feline"] = nil
        package.loaded["catppuccin.special.feline"] = nil
        require("feline").setup {
            components = require("catppuccin.special.feline").get_statusline(),
        }
    end,
})


vim.api.nvim_create_user_command(
  'History', 
  function(opts)
    snacks.picker.command_history{}
  end,
  { nargs = "?" } -- opcional
)

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")


vim.keymap.set(
  "",
  "<Leader>l",
  function ()

    -- Si esta habilitado, lo desactivamos
    if is_lsplines_enabled then 
      is_lsplines_enabled = false 
      vim.diagnostic.config({
        virtual_text = { 
          prefix = "",  
          spacing = 2,
        },
      })
      lsp_lines.toggle()
    else 
      -- Como ahora esta deshabilitado, lo habilitamos 
      is_lsplines_enabled = true 
      vim.diagnostic.config({
        virtual_text = false,
      })

      lsp_lines.toggle()
    end 

  end,
  { desc = "Toggle lsp_lines" }
)


vim.keymap.set("n", "<C-p>", function()
  -- Lanzar el picker de archivos
  require("snacks").picker("files", { 
    hidden=true
  })
end, { desc = "Buscar archivos" })
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
