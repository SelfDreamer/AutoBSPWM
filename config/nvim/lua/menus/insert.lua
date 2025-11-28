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
    name = "󰓫 Table",
    cmd = function()

      local tbl = {
        "| Column1 | Column2 |",
        "| -------------- | --------------- |", 
        "| Item1.2 | Item2.2 |",
        }
        
      write_in_line(tbl)

    end, 
    hl = "ExBlue" 
  },

  {
    name = " Callout",
    cmd = function()
      local content = {
        "> [!NOTE] Nota",
        "> Esto es una nota"
      }
      
      write_in_line(content)

    end, 
    hl = "ExWhite" 
  },

  {
    name = " Horizontal rule",
    cmd = function ()

      write_in_line("---")
      
    end,
    hl = "ExRed" 

  },

  {
    name = " Code block",
    cmd = function ()
      local content = {
        "```lua",
        "print ('This is a content')",
        "```"
      }
      write_in_line(content)
    end,
    hl = "ExYellow"
  }, 

}
