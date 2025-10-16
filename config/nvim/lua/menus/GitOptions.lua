return {

  {
    name = "  Commits Graph",
    cmd = function()
      vim.cmd("Fugit2Graph")
    end,
  },

  {
    name = "  Git Manager", 
    hl = 'ExBlue',
    cmd = function()
      vim.cmd("Fugit2") -- A normal commenct 
    end,
  },

}
