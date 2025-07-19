return {
  {
    name = "  Show Pulstations",
    cmd = function()
      vim.cmd("ShowkeysToggle")
    end,
  },

  {
    name = 'separator',
  },

  {
    name = "  TyprStats",
    hl = 'ExYellow',
    cmd = function()
      vim.cmd("TyprStats")
    end,
  },

  {
    name = "󰧹  Typr", 
    hl = 'ExBlue',
    cmd = function()
      vim.cmd("Typr")
    end,
  }, 

}
