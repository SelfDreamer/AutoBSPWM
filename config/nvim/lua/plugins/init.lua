return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  { "nvzone/volt", 
    lazy = true 
  },

  { "nvzone/menu", 
    lazy = true
  },

  {
    "nvzone/minty",
    cmd = { 
      "Shades",
      "Huefy" 
          },
    opts = {
--      border = true,
    }
  }, 
-- Hi this is a test because i wanna show your keyboards with a legal keylogger :)
  {
    "nvzone/floaterm",
    dependencies = "nvzone/volt",
    opts = {
      border = true,
    },
    cmd = "FloatermToggle",
  },

  { 
    "nvzone/showkeys", 
    cmd = "ShowkeysToggle", 
    opts = {
      position = 'top-center',
    }
  },


  {
      "nvzone/typr",
      dependencies = "nvzone/volt",
      opts = {},
      cmd = { "Typr", "TyprStats" },
  },

  {
    "nvzone/timerly",
    dependencies = 'nvzone/volt',
    cmd = "TimerlyToggle",
    opts = { 
            } -- optional
  },


  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'echasnovski/mini.nvim',
    },

    ft = { 
      "markdown" 
    },
    opts = {
    },
  },

  {
    "folke/snacks.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      picker = {
        enabled = true,
        ui_select = true, -- opcional, para reemplazar vim.ui.select
    },
  }
}

  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },
}
