return {
  "3rd/image.nvim",
  build = false, -- so that it doesn't build the rock https://github.com/3rd/image.nvim/issues/91#issuecomment-2453430239
  opts = {
    processor = "magick_cli",
    tmux_show_only_in_active_window = true, -- not work...
    integrations = {
      markdown = {
        only_render_image_at_cursor = true,
        only_render_image_at_cursor_mode = "popup",
        resolve_image_path = function(document_path, image_path, fallback)
          local trimmed = image_path:gsub("^%s+", ""):gsub("%s+$", "")
          local compact = trimmed:gsub("%s+", "")

          local normalized = nil
          if compact:match("^data:image/[%w%+%-%.]+;base64,") then
            normalized = compact
          elseif compact:match("^image/[%w%+%-%.]+;base64,") then
            normalized = "data:" .. compact
          end

          if normalized then
            local mime = normalized:match("^data:(image/[%w%+%-%.]+);base64,")
            local payload = normalized:match("^data:image/[%w%+%-%.]+;base64,(.+)$")
            if mime and payload and vim.base64 then
              local extension = mime:gsub("^image/", ""):gsub("%+xml$", "")
              local decoded = vim.base64.decode(payload)
              local path = string.format("%s.%s", vim.fn.tempname(), extension)
              local file = io.open(path, "wb")
              if file then
                file:write(decoded)
                file:close()
                return path
              end
            end
          end

          return fallback(document_path, trimmed)
        end,
      },
    },
  },
}
