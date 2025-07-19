return {

  {
    name = "󰐢  Picker UI",
    cmd = function()
      open_picker('files')
    end,
  },

  {
    name = "  Picker cmd",
    hl = "ExRed",
    cmd = function()
      open_picker('commands')
    end,
  },


  {
    name = "  Color Picker", 
    hl = 'ExBlue',
    cmd = function()
      open_color_picker()
    end,
  },

  {
    name = "  Theme Picker",
    hl = 'ExYellow',
    cmd = function()
      require("nvchad.themes").open { 
        border = true
      }
    end,
  },

}
