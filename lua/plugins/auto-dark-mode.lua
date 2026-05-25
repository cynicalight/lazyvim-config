local is_linux = vim.fn.has("linux") == 1 and vim.fn.has("mac") == 0

local function apply_gruvbox()
    vim.opt.background = "light"
    vim.cmd("colorscheme gruvbox-material")
    vim.api.nvim_set_hl(0, "@markup.strong", { fg = "#ea6962", bold = true })
end

return {
    {
        "f-person/auto-dark-mode.nvim",
        enabled = not is_linux,
        opts = {
            update_interval = 1000,
            set_dark_mode = function()
                vim.opt.background = "dark"
                vim.cmd("colorscheme catppuccin-mocha")
            end,
            set_light_mode = apply_gruvbox,
        },
    },
    -- Linux: auto-dark-mode 已禁用，启动时直接固定为 gruvbox-material (light)
    is_linux and {
        "sainnhe/gruvbox-material",
        priority = 1000,
        init = apply_gruvbox,
    },
}
