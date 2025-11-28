---@param message string|table
local function write_in_line(message)
    local line = vim.api.nvim_win_get_cursor(0)[1] - 1  -- línea actual (1-indexed)

    -- Detectar tipo de message
    if type(message) == "string" then
        -- Si es string, lo insertamos como una sola línea
        vim.api.nvim_buf_set_lines(0, line, line, false, {message})
    elseif type(message) == "table" then
        -- Si es table, asumimos que es array de strings y escribimos cada elemento como línea
        vim.api.nvim_buf_set_lines(0, line, line, false, message)
    else
        error("write_in_line: argumento debe ser string o table de strings")
    end
end

return {

  {
    name = " Bold",
    cmd = function ()
      write_in_line("**Bold**")
    end, 
    hl = "ExWhite",
  },

  {
    name = ' Italic',
    cmd = function()
      write_in_line("*Italic*")
    end 
  },

  {
    name = ' StrikeThrough',
    cmd = function()
      write_in_line("~~StrikeThrough~~")
    end,
    hl = "ExYellow"
  },

  {
    name = '󰸱 Highlight',
    cmd = function()
      write_in_line("==Highlight==")
    end,
    hl = "ExBlue",
  },
  
  {
    name = "separator",
  },

  {
    name = "  Code",
    cmd = function()
      write_in_line("`Code`")
    end 

  }



}
