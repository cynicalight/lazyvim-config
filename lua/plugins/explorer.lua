return {
    -- 禁用 Snacks Explorer
    {
        "folke/snacks.nvim",
        opts = {
            explorer = { enabled = false },
        },
    },

    -- 启用 Neo-tree
    {
        "nvim-neo-tree/neo-tree.nvim",
        enabled = true,
        keys = {
            { "<leader>e", "<cmd>Neotree toggle reveal<cr>", desc = "Explorer NeoTree (root dir)" },
            { "<leader>E", "<cmd>Neotree toggle reveal dir=.<cr>", desc = "Explorer NeoTree (cwd)" },
        },
        opts = {
            filesystem = {
                follow_current_file = {
                    enabled = true,
                },
                filtered_items = {
                    visible = true,
                    hide_dotfiles = false,
                },
            },
        },
    },
}
