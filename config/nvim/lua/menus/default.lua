function open_picker(cmd)
  require('snacks').picker(cmd)  
end

function open_color_picker()
  require("minty.huefy").open( { 
    ---@type boolean
    border = true
  } )
end


---@param terminal 'Normal' | 'Floatting'
function open_terminal(terminal)
  if terminal == 'Normal' then
    local old_buf = require("menu.state").old_data.buf
    local old_bufname = vim.api.nvim_buf_get_name(old_buf)
    local old_buf_dir = vim.fn.fnamemodify(old_bufname, ":h")
    local cmd = "cd " .. old_buf_dir

    if vim.g.base46_cache then
      require("nvchad.term").new { cmd = cmd, pos = "sp" }
    else
      vim.cmd("enew")
      vim.fn.termopen(vim.o.shell .. " -c '" .. cmd .. " ; " .. vim.o.shell .. "'")
    end

  elseif terminal == 'Floatting' then
    vim.cmd('FloatermToggle')
  end
end

return {

  {
    name = "Format Buffer",
    cmd = function()
      local ok, conform = pcall(require, "conform")

      if ok then
        conform.format { lsp_fallback = true }
      else
        vim.lsp.buf.format()
      end
    end,
    rtxt = "<leader>fm",
  },

  {
    name = "Code Actions",
    cmd = vim.lsp.buf.code_action,
    rtxt = "<leader>ca",
  },

  { 
    name = "separator" 
  },

  {
    name = "  Lsp Actions",
    hl = "Exblue",
    items = "lsp",
  },

  { 
    name = "separator"
  },

  {
    name = "Edit Config",
    cmd = function()
      vim.cmd "tabnew"
      local conf = vim.fn.stdpath "config"
      vim.cmd("tcd " .. conf .. " | e init.lua")
    end,
    rtxt = "ed",
  },

  {
    name = "Copy Content",
    cmd = "%y+",
    rtxt = "<C-c>",
  },

  {
    name = "Delete Content",
    cmd = "%d",
    rtxt = "dc",
  },

  { 
    name = "separator" 
  },

  {
    name = "  Open in terminal",
    hl = "ExRed",
    cmd = function()
      open_terminal('Floatting')
    end 
  },

  { 
    name = "separator" 
  },

  {
    name = '  Pickers',
    items = 'pickers', 
    hl = 'ExYellow',
  },

  {
    name = 'separator'
  },

  {
    name = "  Keyboard",
    items = 'keyboards',
  },


  {
    name = 'separator',
  },

  {
    name = '󰺗  Chronometer',
    hl = "Exblue",
    cmd = function()
      vim.cmd('TimerlyToggle')
    end
  },

  {
    name = 'separator',
  },

  {
    name = "  Git options",
    hl = "ExRed",
    items = 'GitOptions',
  },

}
