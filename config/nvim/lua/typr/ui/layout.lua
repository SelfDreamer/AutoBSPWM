local ui = require "typr.ui"

local empty_line = {
  lines = function()
    return { {} }
  end,
  name = "emptyline",
}

return {
  {
    lines = ui.headerbtns,
    name = "headerbtns",
  },

  empty_line,

  {
    lines = ui.words,
    name = "words",
  },

  empty_line,

  {
    lines = ui.stats,
    name = "stats",
  },

  {
    lines = ui.mappings,
    name = "mappings",
  },
}
