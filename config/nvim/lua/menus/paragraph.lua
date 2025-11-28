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
    name = " Bulled list",
    cmd = function ()
      write_in_line("- Bulled list")
    end,
    hl = "ExBlue",
  },

  {
    name = "󰉻 Numbered list",
    cmd = function ()
      write_in_line("1. Numbered list")
    end, 
    hl = "ExRed",
  },

  {
    name = " Task list",
    cmd = function ()
      write_in_line("- [ ] Task list")
    end,
    hl = "ExYellow",
  },

  {
    name = 'separator'
  },

  {
    name = "󰉫 Heading 1",
    cmd = function ()

      write_in_line("# Heading 1")
      
    end,
    hl = "ExWhite",
  },

  {
    name = "󰉬 Heading 2",
    cmd = function ()

      write_in_line("## Heading 2")
      
    end,
    hl = "ExWhite",

  },
  {
    name = "󰉭 Heading 3",
    cmd = function ()

      write_in_line("### Heading 3")
      
    end,
    hl = "ExWhite",

  },
  {
    name = "󰉮 Heading 4",
    cmd = function ()

      write_in_line("#### Heading 4")
      
    end,
    hl = "ExWhite",

  },

  {
    name = "󰉯 Heading 5",
    cmd = function ()

      write_in_line("##### Heading 5")
      
    end, 
    hl = "ExWhite",

  },

  {
    name = "󰉰 Heading 6",
    cmd = function ()

      write_in_line("###### Heading 6")
      
    end, 
    hl = "ExWhite",

  },

  {
    name = 'separator'
  },

  {
    name = " Quote",
    cmd = function ()
      write_in_line("> Quote")
      
    end
  },

}
