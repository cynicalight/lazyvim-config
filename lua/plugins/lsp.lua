return {
    "neovim/nvim-lspconfig",
    init = function()
        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                if client and client.name == "marksman" then
                    vim.diagnostic.disable(args.buf)
                end
            end,
        })
    end,
    ---@class PluginLspOpts
    opts = {
        ---@type lspconfig.options
        servers = {
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
