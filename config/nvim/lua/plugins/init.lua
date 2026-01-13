return {
  {
    "rcarriga/nvim-notify",
    lazy = false,
    config = function()
      local notify = require("notify")
      notify.setup({
        ---@type "fade_in_slide_out" | "static" | "fade"  | "slide"
        stages = "slide", -- o "fade_in_slide_out", "static", "fade"
        ---@type integer
        timeout = 3000,
        ---@type string
        background_colour = "#1e1e2e",
      })
      vim.print = notify
      vim.notify = notify
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    lazy = true,

    config = function ()
      require("telescope").setup{
        ---@type table 
        defaults = {
          ---@type "vertical"|"horizontal"
          layout_strategy = 'vertical',
          ---@type table 
          layout_config = {
            ---@type integer | float 
            height = 50,
          },
        }
      }
    end

  },

  
  -- Plugin para tener historial de la clipboard
  --
  -- Deshabilitado porque reduce el rendimiento.
  -- Habilitalo bajo tu propio riesgo.
  {
    "AckslD/nvim-neoclip.lua",
    lazy = false,
    enabled = false, 
      dependencies = {
      {'kkharji/sqlite.lua', module = 'sqlite'},
      -- you'll need at least one of these
      -- {'nvim-telescope/telescope.nvim'},
      -- {'ibhagwan/fzf-lua'},
    },
    config = function()
      require('neoclip').setup({
        ---@type boolean 
        enable_persistent_history = true,
        ---@type boolean 
        continuous_sync = true,

        ---@class OnSelectOptions
        ---@field move_to_front boolean
        ---@field close_telescope boolean
        ---@type OnSelectOptions
        on_select = {
          move_to_front = false,
        	close_telescope = true,
        },

      })
    end,
  },

  { 
    "stevearc/aerial.nvim",
    ---@type boolean
    lazy = true, 
    ---@type table
    opts = {

    },
    ---@type table 
    dependencies = {
       "nvim-treesitter/nvim-treesitter",
       "nvim-tree/nvim-web-devicons"
    },


    ---@type function
    config = function()

      require("aerial").setup({
        
        ---@type table 
        layout = {
        ---@type "prefer_right" | "prefer_left" | "right" | "left" | "float" 
        default_direction = "prefer_left",
        ---@type integer 
        width = 30,
        }, 

        -- optionally use on_attach to set keymaps when aerial has attached to a buffer
        ---@type function
        on_attach = function(bufnr)
          -- Jump forwards/backwards with '{' and '}'
          vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
          vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
        end,
      })
      -- You probably also want to set a keymap to toggle aerial
      vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>")

    end 
  },

  { 
    'feline-nvim/feline.nvim',
    lazy = true,
  },
  
  {
    "luukvbaal/statuscol.nvim", 
    lazy = true,
    event = "VimEnter",
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
    lazy = true,
    event = "VimEnter",
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


  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },
  

  {
    "SelfDreamer/lsp_lines",
    enabled = true,
    lazy = true,
    event = "BufReadPost",
    config = function ()
      local lsp_lines = require("lsp_lines")
      lsp_lines.setup()
      lsp_lines.toggle()

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
    event = "InsertEnter",
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
    priority = 1000,
    lazy = false,
    opts = {
      input = { enabled = true },
      notifier = { enabled = true },
      scroll = { enabled = true },
      indent = { enabled = true },

      image = {
        enabled = false, 
      },

      picker = {
        enabled = true,
        ui_select = true, 
        filetypes = {"markdown", "html", "txt", "lua", "sh"},
        border = "rounded",
        prompt = " ",
      },

      dashboard = {
        enabled = true,
        preset = {
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
            
            { 
              icon = " ", 
              key = "t", 
              desc = "Theme Selector", 
              action = function() 
                require("nvchad.themes").open(
                    {
                      border = true,
                    }
                  ) 
              end 
            },

            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
      },
    },
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
      "jq",
      "bash",
      "json",
        },
      },
    },
}
