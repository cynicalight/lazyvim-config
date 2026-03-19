-- ~/.config/nvim/lua/plugins/venv-selector.lua
return {
    "linux-cultist/venv-selector.nvim",
    dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim" },
    opts = {
        -- 自动搜索常见虚拟环境位置
        anaconda_base_path = "/opt/homebrew/anaconda3", -- 或 ~/anaconda3
        anaconda_envs_path = "/opt/homebrew/anaconda3/envs",
        miniconda_base_path = "/opt/homebrew/Caskroom/miniconda/base",
    },
    keys = {
        { "<leader>cv", "<cmd>VenvSelect<cr>", desc = "Select VirtualEnv" },
    },
}
