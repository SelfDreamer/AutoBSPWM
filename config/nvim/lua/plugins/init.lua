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

  {
    "karb94/neoscroll.nvim",
    keys = { "<C-d>", "<C-u>" },
    opts = { mappings = {
        "<C-u>",
        "<C-d>",
    } },
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline", 
      "L3MON4D3/LuaSnip"
    },
  },

  {
    "folke/snacks.nvim",
    ---@type snacks.Config
    lazy = false,
    priority = 1000,
    opts = {
      picker = {
        enabled = true,
        ui_select = true, 
      },
    dashboard  = {
        enabled = true, 
        ui_select = true,
      }, 
    indent = {
        enabled = true, 
        priority = 1, 
      },
    
    }
  },

  { "nvzone/volt", 
    lazy = true 
  },

  { "nvzone/menu", 
    lazy = true
  },

  {
    "rcarriga/nvim-notify",
    config = function()
      local notify = require("notify")
      notify.setup({
        stages = "slide", -- o "fade_in_slide_out", "static", "fade"
        timeout = 3000,
        background_colour = "#1e1e2e",
      })
      vim.notify = notify
    end,
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
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown" },
  lazy = true,          
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("render-markdown").setup({
    })
    vim.cmd([[
      augroup NoConcealMarkdown
        autocmd!
        autocmd FileType markdown setlocal conceallevel=0 concealcursor=
      augroup END
    ]])  end,
  },

  {
    "hrsh7th/cmp-cmdline",
    event = "CmdlineEnter", 
    dependencies = {
      "hrsh7th/nvim-cmp",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "cmdline" },
        },
      })
    end,
  },



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
