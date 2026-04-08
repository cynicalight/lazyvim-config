-- ~/.config/nvim/lua/plugins/daily-note.lua (LazyVim 插件格式)
return {
  dir = vim.fn.stdpath("config") .. "/lua",
  config = function()
    require("daily-note").setup({
      notes_dir = vim.fn.expand("$OBSIDIAN_HOME/Personal/Daily/"),
      enable_quote = true,
    })
  end,
}
