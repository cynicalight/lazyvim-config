-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- 强制 <leader>ft 打开浮动终端 (基于 Snacks.terminal)
vim.keymap.set("n", "<leader>ft", function()
  -- win = { style = "float" } 是默认值，这里显式写出来以防万一
  Snacks.terminal(nil, { cwd = LazyVim.root(), win = { style = "float" } })
end, { desc = "Terminal (Root Dir)" })
