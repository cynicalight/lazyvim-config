return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    default_component_configs = {
      diagnostics = {
        enabled = false,
      },
    },
    event_handlers = {
      {
        event = "neo_tree_window_after_open",
        handler = function(args)
          local state = args.state or require("neo-tree.sources.manager").get_state("filesystem")
          if state and not state._default_sort_applied then
            state._default_sort_applied = true
            require("neo-tree.sources.common.commands").order_by_modified(state)
          end
        end,
      },
    },
  },
}
