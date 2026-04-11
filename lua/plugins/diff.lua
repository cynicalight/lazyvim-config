return {
  "esmuellert/codediff.nvim",
  cmd = "CodeDiff",
  opts = {
    diff = {
      conflict_result_width_ratio = { 1, 3, 3 }, -- Width ratio for center layout panes {left, center, right} (e.g., {1, 2, 1} for wider result)
    },
    keymaps = {
      conflict = {
        accept_incoming = "<leader>ct",  -- Accept incoming (theirs/left) change
        accept_current = "<leader>co",
      },
    },
  },
  config = function (_, opts)
    require("codediff").setup(opts)
  end
}
