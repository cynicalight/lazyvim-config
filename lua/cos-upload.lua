-- cos-upload.lua
-- Paste clipboard image → upload to Tencent COS → insert markdown link
-- Prerequisites: pngpaste (brew install pngpaste), coscli (configured)

local M = {}

M.config = {
  bucket = "cos://bu44er-1313346488",
  region = "ap-shanghai",
  cos_prefix = "obsidian",
  url_base = "https://bu44er-1313346488.cos.ap-shanghai.myqcloud.com/obsidian/",
  url_suffix = "?imageMogr2/quality/80&imageSlim",
  tmp_dir = "/tmp/nvim-cos-upload",
}

local ns = vim.api.nvim_create_namespace("cos_upload")

local function generate_filename()
  local date_part = os.date("%Y%m%d%H%M%S")
  local ms = math.floor((vim.uv.hrtime() / 1e6) % 1000)
  return string.format("%s%03d.png", date_part, ms)
end

function M.paste_and_upload()
  if vim.fn.executable("pngpaste") ~= 1 then
    vim.notify("pngpaste not found. Install: brew install pngpaste", vim.log.levels.ERROR)
    return
  end
  if vim.fn.executable("coscli") ~= 1 then
    vim.notify("coscli not found. See cos-upload.lua for setup", vim.log.levels.ERROR)
    return
  end

  -- Save clipboard image to temp file
  vim.fn.mkdir(M.config.tmp_dir, "p")
  local filename = generate_filename()
  local tmp_path = M.config.tmp_dir .. "/" .. filename

  local save_result = vim.fn.system({ "pngpaste", tmp_path })
  if vim.v.shell_error ~= 0 then
    vim.notify("No image in clipboard", vim.log.levels.WARN)
    return
  end

  -- Insert placeholder at cursor and track with extmark
  local bufnr = vim.api.nvim_get_current_buf()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_buf_get_lines(bufnr, row - 1, row, false)[1]
  local before = line:sub(1, col)
  local after = line:sub(col + 1)
  local placeholder = "![uploading...]()"

  vim.api.nvim_buf_set_lines(bufnr, row - 1, row, false, { before .. placeholder .. after })
  local mark_id = vim.api.nvim_buf_set_extmark(bufnr, ns, row - 1, col, {})

  -- Async upload to COS
  local cos_path = string.format("%s/%s/%s", M.config.bucket, M.config.cos_prefix, filename)
  vim.system(
    { "coscli", "cp", tmp_path, cos_path },
    { text = true },
    function(result)
      vim.schedule(function()
        if not vim.api.nvim_buf_is_valid(bufnr) then
          return
        end

        local pos = vim.api.nvim_buf_get_extmark_by_id(bufnr, ns, mark_id, {})
        local mark_row = pos[1]
        local cur_line = vim.api.nvim_buf_get_lines(bufnr, mark_row, mark_row + 1, false)[1]

        if result.code == 0 then
          local url = M.config.url_base .. filename .. M.config.url_suffix
          local final_link = string.format("![](%s)", url)
          local new_line = cur_line:gsub("%!%[uploading%.%.%.%]%(%)", final_link, 1)
          vim.api.nvim_buf_set_lines(bufnr, mark_row, mark_row + 1, false, { new_line })
          os.remove(tmp_path)
          vim.notify("Image uploaded: " .. filename, vim.log.levels.INFO)
        else
          local err = (result.stderr or ""):gsub("\n", " ")
          local new_line = cur_line:gsub("%!%[uploading%.%.%.%]%(%)", "![upload failed]()", 1)
          vim.api.nvim_buf_set_lines(bufnr, mark_row, mark_row + 1, false, { new_line })
          vim.notify("COS upload failed: " .. err, vim.log.levels.ERROR)
        end

        vim.api.nvim_buf_del_extmark(bufnr, ns, mark_id)
      end)
    end
  )
end

return M
