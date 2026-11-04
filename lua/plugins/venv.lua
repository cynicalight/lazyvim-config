-- ~/.config/nvim/lua/plugins/venv-selector.lua
return {
    "linux-cultist/venv-selector.nvim",
    dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim" },
    opts = {
        -- 自动搜索常见虚拟环境位置
    },
    keys = {
        { "<leader>cv", "<cmd>VenvSelect<cr>", desc = "Select VirtualEnv" },
    },
}
