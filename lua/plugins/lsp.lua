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
