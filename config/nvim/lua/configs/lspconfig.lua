require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls" }
-- vim.lsp.enable(servers)

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
  "basedpyright",
  "clangd",
  "rust_analyzer",
}) do
  vim.lsp.enable(lsp)
end
