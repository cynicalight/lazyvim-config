return {
  "folke/snacks.nvim",
  init = function()
    local function set_terminal_border_highlight()
      local float_border = vim.api.nvim_get_hl(0, { name = "FloatBorder", link = false })
      vim.api.nvim_set_hl(0, "SnacksTerminalBorder", { fg = float_border.fg, bg = "NONE" })
    end

    local group = vim.api.nvim_create_augroup("SnacksTerminalBorder", { clear = true })
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = group,
      callback = set_terminal_border_highlight,
    })
    set_terminal_border_highlight()
  end,
  opts = {
    terminal = {
      win = {
        position = "float",
        border = {
          { "╭", "SnacksTerminalBorder" },
          { "─", "SnacksTerminalBorder" },
          { "╮", "SnacksTerminalBorder" },
          { "│", "SnacksTerminalBorder" },
          { "╯", "SnacksTerminalBorder" },
          { "─", "SnacksTerminalBorder" },
          { "╰", "SnacksTerminalBorder" },
          { "│", "SnacksTerminalBorder" },
        },
      },
    },
    picker = {
      sources = {
        files = {
          hidden = true,
        },
      },
    },
  },
}
