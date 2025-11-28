return {
  {
    "rcarriga/nvim-notify",
    lazy = false,
    config = function()
      local notify = require("notify")
      notify.setup({
        stages = "slide", -- o "fade_in_slide_out", "static", "fade"
        timeout = 3000,
        background_colour = "#1e1e2e",
      })
      vim.print = notify
      vim.notify = notify
    end,
  },

  { 
    'feline-nvim/feline.nvim',
    lazy = true,
  },
  
  {
    "luukvbaal/statuscol.nvim", 
    lazy = false,
    enabled = true,
    config = function()
      local builtin = require("statuscol.builtin")

      require("statuscol").setup({
        relculright = true,
        segments = {

          {
            text = { builtin.foldfunc },
            click = "v:lua.ScFa",
          },
          { 
            text = { "%s" }, -- signos (git, diagnostics, etc.)
            click = "v:lua.ScSa" 
          },

          {
            sign = { name = { ".*" }, maxwidth = 2, colwidth = 1, auto = true },
            click = "v:lua.ScSa",
          },


          {
            text = {

              function(args)
                local curr = vim.fn.line(".")
                local num = builtin.lnumfunc(args)

                if args.lnum == curr then
                  return num .. "  "
                else
                  return num .. " "
                end
              end,

            },
            click = "v:lua.ScLa",
          },

        }
      })
    end,
  },


  {
    "catppuccin/nvim", 
    name = "catppuccin",
    priority = 1000,
    lazy = false,
    config = function ()

      local ctp_feline = require('catppuccin.special.feline')
      ctp_feline.setup()


      ctp_feline.setup({
          view = {
              lsp = {
                  name = true
              }
          },
          assets = {
            lsp = {
              server = "󰅡",
              error = "",
              warning = "",
              info = "󰋼",
              hint = "󰛩",
              },
        },
      })

      require("feline").setup({
        disable = {
          filetypes = {}, 
          buftypes = {},
        },
        components = ctp_feline.get_statusline(),
      })


    end
  },

done


  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },
  

  {
    "SelfDreamer/lsp_lines",
    enabled = true,
    lazy = false,
    config = function ()
      local lsp_lines = require("lsp_lines")
      lsp_lines.setup()
      lsp_lines.toggle()
      vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { undercurl = true, sp = "#FF5F5F" })
      vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn",  { undercurl = true, sp = "#FFA500" })
      vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo",  { undercurl = true, sp = "#5FAFFF" })
      vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint",  { undercurl = true, sp = "#5FFF87" })

        vim.schedule(function()
        vim.diagnostic.config({
            virtual_text = false,
            virtual_lines = {
            current_line = true,  
          },
        })
    end)

    end
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
    lazy = true,
    keys = { "<C-d>", "<C-u>" },
    opts = { mappings = {
        "<C-u>",
        "<C-d>",
      } 
    },
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

    cmd = function ()
      

      local cmp = require("cmp")

      cmp.setup({
          window = {
              completion = cmp.config.window.bordered({
                  border = "rounded",
                  scrollbar = true,       
                  max_width = 60,
                  max_height = 12,
              }),
              documentation = cmp.config.window.bordered({
                  border = "rounded",
                  scrollbar = true,
                  max_height = 15,
              }),
          }, 
        
          mapping = cmp.mapping.preset.insert({
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),

        experimental = {
          ghost_text = true,
        },

      })
    end


  },
  
  -- Neovide cursor plugin
  -- Cursor personalizado
  -- Tags Ignore 
  -- Cursor 
  -- Neovide 
  -- Plugin para hacer que el cursor de neovim sea como el de neovide, si lo quieres habilitar cambia la variable enabled a true 
  -- {
  --  "sphamba/smear-cursor.nvim",
  --  lazy = false,
  --  enabled = true, 
  --  opts = {},
  -- },
  {
    "sphamba/smear-cursor.nvim",
    lazy = false, 
    enabled = false,
    opts = {},
  },

  {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown" },
  lazy = false,          
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
--  config = function()
--    require("render-markdown").setup({
--    })
--    vim.cmd([[
--      augroup NoConcealMarkdown
--        autocmd!
--        autocmd FileType markdown setlocal conceallevel=0 concealcursor=
--      augroup END
--    ]])  end,
  },


  {
    "folke/snacks.nvim",
    ---@type snacks.Config
    lazy = true,
    priority = 1000,
    opts = {
      
      image = {
        enabled = false, -- Por si quieres ver imagenes en archivos markdown y demás. 
      },

      picker = {
        enabled = true,
        ui_select = true, 
        filetypes = {"markdown", "html", "txt", "lua", "sh"},
        border = "rounded",
        prompt = " ",
        show_delay = 5000,
        limit_live = 10000,
      },

    dashboard  = {
        enabled = true, 
        ui_select = true,
      }, 
    indent = {
        enabled = true, 
        priority = 1, 
      },
    opts = {
        input = { enabled = true },
        notifier = { enabled = true },
     },
    scroll = {
        enabled = true, 
        opts = {},
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
    "nvzone/minty",
    cmd = { 
      "Shades",
      "Huefy" 
          },
    opts = {
--       border = true,
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
    "hrsh7th/cmp-cmdline",
    event = "CmdlineEnter", 
    dependencies = {
      "hrsh7th/nvim-cmp",
    },
    config = function()
      local cmp = require("cmp")
        -- `:` cmdline setup.
        cmp.setup.cmdline(':', {
          mapping = cmp.mapping.preset.cmdline(),
          sources = cmp.config.sources({
            { name = 'path' }
          }, {
            {
              name = 'cmdline',
              option = {
                ignore_cmds = { 'Man', '!' }
              }
            }
          })
        })


    end,
  },

  {
    'SuperBo/fugit2.nvim',
    build = false,
    opts = {
      width = 100,
    },
    dependencies = {
      'MunifTanjim/nui.nvim',
      'nvim-tree/nvim-web-devicons',
      'nvim-lua/plenary.nvim',
      {
        'chrisgrieser/nvim-tinygit', -- opcional: para vista de PR de GitHub
        dependencies = { 'stevearc/dressing.nvim' }
      },
    },
    cmd = { 'Fugit2', 'Fugit2Diff', 'Fugit2Graph' },
    keys = {
      { '<leader>F', mode = 'n', '<cmd>Fugit2<cr>' }
    },
  },




  {
  "nvim-treesitter/nvim-treesitter",
  opts = {
  ensure_installed = {
    "vim", 
    "lua", 
    "sql",
    "php",
      },
    },
  },
}
