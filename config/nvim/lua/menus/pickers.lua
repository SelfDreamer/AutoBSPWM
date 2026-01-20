lazy_core_config = require("lazy.core.config")

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
      open_color_picker() -- A normal commenct 
    end,
  },

  {
    name = "  Aerial",
    hl = 'ExYellow',
    cmd = function()
      local loaded = lazy_core_config.plugins["catppuccin"]
      if not loaded and loaded._.loaded then
        vim.cmd("silent! AerialStart")
      end


      require("aerial").open()
    end,
  },


}
