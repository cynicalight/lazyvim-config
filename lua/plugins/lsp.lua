return {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
        ---@type lspconfig.options
        servers = {
            gopls = {
                settings = {
                    gopls = {
                        analyses = {
                            ST1000 = false,
                        },
                    },
                },
            },
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
