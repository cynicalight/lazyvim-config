return {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
        ---@type lspconfig.options
        servers = {
            pyright = {},

            sourcekit = {
                filetypes = { "swift", "objective-c", "objective-cpp" },
                cmd = { "xcrun", "sourcekit-lsp" },
            },

            -- clangd = {
            --     cmd = {
            --         "clangd",
            --         "--background-index",
            --         "--clang-tidy",
            --         "--header-insertion=iwyu",
            --         "--completion-style=detailed",
            --         "--function-arg-placeholders",
            --         "--fallback-style={IndentWidth: 4}",
            --     },
            -- },
        },
    },
}
