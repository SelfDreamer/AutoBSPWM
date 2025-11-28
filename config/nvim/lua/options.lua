require "nvchad.options"

-- add yours here!

local o = vim.o
o.cursorlineopt ='both' -- to enable cursorline!

vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", {
  bg = "#3b1c21",
})

vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", {
  bg = "#3a2f1c",
})

vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", {
  bg = "#1e2e2e",
})

vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", {
  bg = "#1b2538",
})
