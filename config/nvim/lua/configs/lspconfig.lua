local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

-- list of servers configured with default config.
local default_servers = {
  "html",
  "cssls",
  "vtsls",
  "marksman",
}

-- lsps with default config
for _, lsp in ipairs(default_servers) do
  vim.lsp.config(lsp, {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
  })
end

-- PHP
vim.lsp.config("intelephense", { -- Php language server 
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  root_dir = require("lspconfig.util").root_pattern(".git", "composer.json", "."),
  settings = {
    intelephense = {
      environment = {
        includePaths = {},
      },
    },
  },
})

vim.lsp.config("bashls", { -- Bash language server 
  cmd_env = { LANG = "es_ES.UTF-8" },
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
})

vim.lsp.config("lua_ls", { -- lua language server 
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = {
        enable = false,
      },
      workspace = {
        library = {
          vim.fn.expand "$VIMRUNTIME/lua",
          vim.fn.expand "$VIMRUNTIME/lua/vim/lsp",
          vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types",
          vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy",
          "${3rd}/love2d/library",
        },
        maxPreload = 100000,
        preloadFileSize = 10000,
      },
    },
  },
})

vim.lsp.config("basedpyright", { -- Python language server 
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  settings = {
    basedpyright = {
      typeCheckingMode = "standard",
    },
  },
})

vim.lsp.config("clangd", { -- "C" language server 
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  cmd = {
    "clangd",
    "--offset-encoding=utf-16",
  },
})

vim.lsp.config("rust_analyzer", { -- rust language server 
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  settings = {
    ["rust-analyzer"] = {
      rustfmt = {
        extraArgs = { "+nightly" },
      },
    },
  },
})

for _, lsp in ipairs({
  "html",
  "cssls",
  "vtsls",
  "marksman",
  "intelephense",
  "bashls",
  "lua_ls",
  "basedpyright",
  "clangd",
  "rust_analyzer",
}) do
  vim.lsp.enable(lsp)
end
