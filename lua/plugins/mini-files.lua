return {
  "nvim-mini/mini.files",
  opts = {
    content = {
      sort = function(fs_entries)
        -- fetch mtime for each entry
        for _, entry in ipairs(fs_entries) do
          local stat = vim.loop.fs_stat(entry.path)
          entry._mtime = stat and stat.mtime.sec or 0
        end
        -- directories first, then by mtime descending (newest first)
        table.sort(fs_entries, function(a, b)
          if a.fs_type ~= b.fs_type then
            return a.fs_type == "directory"
          end
          return a._mtime > b._mtime
        end)
        return fs_entries
      end,
    },
  },
}
