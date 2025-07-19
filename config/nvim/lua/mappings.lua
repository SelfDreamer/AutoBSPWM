pcall(require, "menu")
require "nvchad.mappings"


local map = vim.keymap.set

vim.keymap.set("n", "<C-A-t>", "<cmd>FloatermToggle<cr>", {
  desc = "Toggle terminal"
      }
)

vim.keymap.set({ "n", "v" }, "<RightMouse>", function()
  require('menu.utils').delete_old_menus()

  vim.cmd.exec '"normal! \\<RightMouse>"'

  -- clicked buf
  local buf = vim.api.nvim_win_get_buf(vim.fn.getmousepos().winid)
  local options = vim.bo[buf].ft == "NvimTree" and "nvimtree" or "default"

  require("menu").open(options, { mouse = true })
end, {})



map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

vim.keymap.set("n", "<C-p>", function()
  -- Obtener el path al home del usuario
  local home = vim.env.HOME or os.getenv("HOME")

  -- Cambiar directorio de trabajo
  vim.cmd.cd(home)

  -- Lanzar el picker de archivos
  require("snacks").picker("files")
end, { desc = "Buscar archivos desde ~/ (home)" })
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
