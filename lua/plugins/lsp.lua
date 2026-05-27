return {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
        ---@type lspconfig.options
        servers = {
            marksman = {
                diagnostics = false,
            },
            tailwindcss = {
                settings = {
                    tailwindCSS = {
                        includeLanguages = {
                            typescriptreact = "html",
                            javascriptreact = "html",
                        },
                    },
                },
            },
            pyright = {},

            vtsls = {
                settings = {
                    vtsls = {
                        autoUseWorkspaceTsdk = true,
                    },
                },
            },

            sourcekit = {
                filetypes = { "swift" },
                cmd = { "xcrun", "sourcekit-lsp" },
                root_dir = function(bufnr, on_dir)
                    local util = require("lspconfig.util")
                    local fname = vim.api.nvim_buf_get_name(bufnr)
                    on_dir(
                        util.root_pattern("buildServer.json", ".bsp")(fname)
                            or util.root_pattern("*.xcodeproj", "*.xcworkspace")(fname)
                            or util.root_pattern("compile_commands.json", "Package.swift")(fname)
                            or vim.fs.dirname(vim.fs.find(".git", { path = fname, upward = true })[1])
                    )
                end,
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
