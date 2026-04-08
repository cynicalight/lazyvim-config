-- daily-note.lua
-- 严格复刻 Obsidian Templater 日记模板
-- 放到 ~/.config/nvim/lua/daily-note.lua
-- 在 init.lua 里 require("daily-note").setup()

local M = {}

M.config = {
  notes_dir = vim.fn.expand("$OBSIDIAN_HOME/Personal/Diary/"),
  enable_quote = true,
  quote_api = "https://zenquotes.io/api/today",
  curl_timeout = 3,
}

---------------------------------------------------------------------------
-- 日期工具
---------------------------------------------------------------------------

local function fmt_date(offset_days)
  local t = os.time() + (offset_days * 86400)
  return os.date("%Y-%m-%d %a", t)
end

---------------------------------------------------------------------------
-- 每日名言 (异步)
---------------------------------------------------------------------------

local function fetch_quote_async(bufnr, line)
  if not M.config.enable_quote then
    return
  end

  vim.system(
    { "curl", "-s", "--max-time", tostring(M.config.curl_timeout), M.config.quote_api },
    { text = true },
    function(result)
      vim.schedule(function()
        if not vim.api.nvim_buf_is_valid(bufnr) then
          return
        end

        local raw = result.stdout or ""
        local q = raw:match('"q"%s*:%s*"(.-)"')
        local a = raw:match('"a"%s*:%s*"(.-)"')
        if not q then
          q = raw:match('"content"%s*:%s*"(.-)"')
          a = raw:match('"author"%s*:%s*"(.-)"')
        end

        local replacement
        if q and a then
          replacement = { "> *" .. q .. "*", "> — " .. a }
        else
          replacement = { "> *Failed to fetch quote*" }
        end

        vim.api.nvim_buf_set_lines(bufnr, line, line + 1, false, replacement)
      end)
    end
  )
end

---------------------------------------------------------------------------
-- 模板 (严格复刻)
---------------------------------------------------------------------------

local function build_template()
  local yesterday = fmt_date(-1)
  local tomorrow = fmt_date(1)

  local quote_line = -1
  local cursor_line = -1

  local lines = {}

  -- 导航 (Obsidian wiki link 格式)
  table.insert(lines, "<< [[" .. yesterday .. "]] | [[" .. tomorrow .. "]] >>")
  table.insert(lines, "")

  -- 名言占位符
  if M.config.enable_quote then
    quote_line = #lines  -- 0-indexed
    table.insert(lines, "{{QUOTE_LOADING}}")
  end

  table.insert(lines, "")

  -- 分隔线
  table.insert(lines, "---")

  -- To-do
  table.insert(lines, "## To-do")
  table.insert(lines, "")
  table.insert(lines, "AM")
  table.insert(lines, "- [ ] **ignore social interactions**")
  table.insert(lines, "- [ ] check the e-mail")
  table.insert(lines, "- [ ] check the calender")
  table.insert(lines, "- [ ] ")
  table.insert(lines, "")
  table.insert(lines, "PM")
  table.insert(lines, "- [ ] ")
  table.insert(lines, "- [ ] exercise")
  table.insert(lines, "- [ ] **review and reflection**")
  table.insert(lines, "")

  -- 分隔线
  table.insert(lines, "---")

  -- Log
  table.insert(lines, "## Log")
  cursor_line = #lines  -- Log 下一行 (0-indexed)
  table.insert(lines, "")
  table.insert(lines, "")

  return lines, quote_line, cursor_line
end

---------------------------------------------------------------------------
-- 核心
---------------------------------------------------------------------------

function M.open(offset_days)
  offset_days = offset_days or 0

  local dir = M.config.notes_dir
  vim.fn.mkdir(dir, "p")

  local t = os.time() + (offset_days * 86400)
  local filename = os.date("%Y-%m-%d %a", t) .. ".md"
  local filepath = dir .. filename

  local is_new = vim.fn.filereadable(filepath) == 0

  vim.cmd("edit " .. vim.fn.fnameescape(filepath))

  if is_new then
    local lines, quote_line, cursor_line = build_template()
    local bufnr = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)

    if quote_line >= 0 then
      fetch_quote_async(bufnr, quote_line)
    end

    if cursor_line >= 0 then
      vim.api.nvim_win_set_cursor(0, { cursor_line + 1, 0 })
    end

    -- 模拟 tp.file.cursor() — 进入插入模式
    vim.cmd("startinsert")
  end
end

function M.list()
  local ok, builtin = pcall(require, "telescope.builtin")
  if ok then
    builtin.find_files({ prompt_title = "Daily Notes", cwd = M.config.notes_dir })
    return
  end
  local ok2, fzf = pcall(require, "fzf-lua")
  if ok2 then
    fzf.files({ cwd = M.config.notes_dir })
    return
  end
  vim.cmd("edit " .. vim.fn.fnameescape(M.config.notes_dir))
end

function M.search()
  local ok, builtin = pcall(require, "telescope.builtin")
  if ok then
    builtin.live_grep({ prompt_title = "Search Daily Notes", cwd = M.config.notes_dir })
    return
  end
  local ok2, fzf = pcall(require, "fzf-lua")
  if ok2 then
    fzf.live_grep({ cwd = M.config.notes_dir })
    return
  end
  vim.notify("需要 telescope 或 fzf-lua", vim.log.levels.WARN)
end

---------------------------------------------------------------------------
-- Setup
---------------------------------------------------------------------------

function M.setup(opts)
  if opts then
    M.config = vim.tbl_deep_extend("force", M.config, opts)
  end

  vim.api.nvim_create_user_command("DailyNote", function() M.open(0) end, {})
  vim.api.nvim_create_user_command("DailyNoteYesterday", function() M.open(-1) end, {})
  vim.api.nvim_create_user_command("DailyNoteTomorrow", function() M.open(1) end, {})
  vim.api.nvim_create_user_command("DailyNoteList", function() M.list() end, {})
  vim.api.nvim_create_user_command("DailyNoteSearch", function() M.search() end, {})

  vim.keymap.set("n", "<leader>dn", function() M.open(0) end, { desc = "Daily note" })
  vim.keymap.set("n", "<leader>dy", function() M.open(-1) end, { desc = "Yesterday" })
  vim.keymap.set("n", "<leader>dt", function() M.open(1) end, { desc = "Tomorrow" })
  vim.keymap.set("n", "<leader>dl", M.list, { desc = "List notes" })
  vim.keymap.set("n", "<leader>ds", M.search, { desc = "Search notes" })
end

return M
