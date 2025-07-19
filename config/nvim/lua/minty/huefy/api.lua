local M = {}
local v = require "minty.huefy.state"

M.save_color = function()

  vim.cmd("set modifiable")
  require("volt").close()
  local line = vim.api.nvim_get_current_line()
  line = line:gsub(v.hex, v.new_hex)
  vim.api.nvim_set_current_line(line)
end
-- Color  de prueba -> #4f2e15
return M
