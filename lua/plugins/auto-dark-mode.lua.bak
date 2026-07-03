local is_linux = vim.fn.has("linux") == 1 and vim.fn.has("mac") == 0

local function apply_gruvbox()
    vim.opt.background = "light"
    vim.cmd("colorscheme gruvbox-material")
    vim.api.nvim_set_hl(0, "@markup.strong", { fg = "#ea6962", bold = true })
end

local plugins = {}

if not is_linux then
    table.insert(plugins, {
        "f-person/auto-dark-mode.nvim",
        opts = {
            update_interval = 1000,
            set_dark_mode = function()
                vim.opt.background = "dark"
                vim.cmd("colorscheme catppuccin-mocha")
            end,
            set_light_mode = apply_gruvbox,
        },
    })
end

if is_linux then
    table.insert(plugins, {
        "sainnhe/gruvbox-material",
        priority = 1000,
        init = apply_gruvbox,
    })
end

return plugins
