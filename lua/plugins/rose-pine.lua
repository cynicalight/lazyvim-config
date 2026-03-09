return {
    {
        "rose-pine/neovim",
        name = "rose-pine",
        priority = 1000,
        opts = {
            variant = "auto",
            dark_variant = "main",
            styles = {
                transparency = true,
            },
            groups = {
                background = "#f7f3ee", -- 奶白底
                panel = "#efebe5", -- 比背景深一点，给浮窗/面板分层
                border = "#c8beb3", -- 边框更明显
                comment = "muted",
                link = "iris",
                punctuation = "subtle",
            },
            highlight_groups = {
                Normal = { bg = "#f7f3ee" },
                NormalNC = { bg = "#f7f3ee" },

                NormalFloat = { bg = "#efebe5" },
                FloatBorder = { bg = "#efebe5", fg = "#c8beb3" },

                CursorLine = { bg = "#eee8df" },
                CursorColumn = { bg = "#eee8df" },

                Visual = { bg = "#ddd6ca" }, -- 选中区域不能再接近白色
                Search = { bg = "#e6d7b8", fg = "#40342f" },
                IncSearch = { bg = "#d9c08f", fg = "#2a2220" },

                Pmenu = { bg = "#efebe5", fg = "#575279" },
                PmenuSel = { bg = "#ddd6ca", fg = "#2a2220" },

                StatusLine = { bg = "#e8e1d8", fg = "#575279" },
                StatusLineNC = { bg = "#f0ebe5", fg = "#9893a5" },

                LineNr = { fg = "#b2a79b" },
                CursorLineNr = { fg = "#907aa9", bold = true },
            },
        },
        config = function(_, opts)
            require("rose-pine").setup(opts)
            vim.cmd("colorscheme rose-pine")
        end,
    },
}
