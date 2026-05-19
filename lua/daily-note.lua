-- daily-note.lua
-- 严格复刻 Obsidian Templater 日记模板
-- 放到 ~/.config/nvim/lua/daily-note.lua
-- 在 init.lua 里 require("daily-note").setup()

local M = {}

M.config = {
  notes_dir = vim.fn.expand("$OBSIDIAN_HOME/Personal/Diary/"),
  weekly_dir = vim.fn.expand("$OBSIDIAN_HOME/Personal/Weekly/"),
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

  -- -- 导航 (Obsidian wiki link 格式)
  -- table.insert(lines, "<< [[" .. yesterday .. "]] | [[" .. tomorrow .. "]] >>")
  -- table.insert(lines, "")
  --
  -- -- 名言占位符
  -- if M.config.enable_quote then
  --   quote_line = #lines  -- 0-indexed
  --   table.insert(lines, "{{QUOTE_LOADING}}")
  -- end

  -- table.insert(lines, "")
  --
  -- -- 分隔线
  -- table.insert(lines, "---")

  -- To-do
  table.insert(lines, "## To-do")
  table.insert(lines, "")
  table.insert(lines, "AM")
  table.insert(lines, "- [ ] check the e-mail and calender")
  table.insert(lines, "- [ ] learn EN")
  table.insert(lines, "")
  table.insert(lines, "PM")
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
-- 周记 (Weekly Journal)
---------------------------------------------------------------------------

-- Get Monday of the week containing the given timestamp
local function get_monday(timestamp)
  local wday = tonumber(os.date("%w", timestamp)) -- 0=Sun, 1=Mon, ...
  if wday == 0 then wday = 7 end
  return timestamp - (wday - 1) * 86400
end

local function build_weekly_template(monday_ts)
  local lines = {}
  local sunday_ts = monday_ts + 6 * 86400
  local title = os.date("%Y-%m-%d", monday_ts) .. " ~ " .. os.date("%Y-%m-%d", sunday_ts)
  table.insert(lines, "# " .. title)
  table.insert(lines, "")

  local day_names = { "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun" }
  for i = 0, 6 do
    local day_ts = monday_ts + i * 86400
    local heading = os.date("%Y-%m-%d", day_ts) .. " " .. day_names[i + 1]
    table.insert(lines, "## " .. heading)
    table.insert(lines, "")
    table.insert(lines, "### To-do")
    table.insert(lines, "")
    table.insert(lines, "AM")
    table.insert(lines, "- [ ] check the e-mail and calender")
    table.insert(lines, "- [ ] learn EN")
    table.insert(lines, "- [ ] ")
    table.insert(lines, "")
    table.insert(lines, "PM")
    table.insert(lines, "- [ ] ")
    table.insert(lines, "- [ ] exercise")
    table.insert(lines, "- [ ] **review and reflection**")
    table.insert(lines, "")
    table.insert(lines, "---")
    table.insert(lines, "")
    table.insert(lines, "### Log")
    table.insert(lines, "")
    table.insert(lines, "")
    if i < 6 then
      table.insert(lines, "---")
      table.insert(lines, "")
    end
  end

  return lines
end

local function weekly_filepath(monday_ts)
  local year = os.date("%Y", monday_ts)
  local month = tonumber(os.date("%m", monday_ts))
  local dir = M.config.weekly_dir .. year .. "/" .. month .. "/"
  local sunday_ts = monday_ts + 6 * 86400
  local filename = os.date("%Y-%m-%d", monday_ts) .. " ~ " .. os.date("%Y-%m-%d", sunday_ts) .. ".md"
  return dir .. filename
end

function M.open_weekly(offset_weeks)
  offset_weeks = offset_weeks or 0

  local monday_ts = get_monday(os.time())

  -- If current week's file already exists, create next week's
  if offset_weeks == 0 and vim.fn.filereadable(weekly_filepath(monday_ts)) == 1 then
    monday_ts = monday_ts + 7 * 86400
  else
    monday_ts = monday_ts + offset_weeks * 7 * 86400
  end

  local filepath = weekly_filepath(monday_ts)
  local is_new = vim.fn.filereadable(filepath) == 0

  vim.fn.mkdir(vim.fn.fnamemodify(filepath, ":h"), "p")
  vim.cmd("edit " .. vim.fn.fnameescape(filepath))

  local bufnr = vim.api.nvim_get_current_buf()

  if is_new then
    local lines = build_weekly_template(monday_ts)
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  end

  -- Jump to today's Log section
  local today_str = os.date("%Y-%m-%d", os.time())
  local line_count = vim.api.nvim_buf_line_count(bufnr)
  local found_today = false
  for i = 0, line_count - 1 do
    local line = vim.api.nvim_buf_get_lines(bufnr, i, i + 1, false)[1]
    if not found_today then
      if line and line:find(today_str, 1, true) and line:match("^## ") then
        found_today = true
      end
    else
      if line and line:match("^### Log") then
        local target = math.min(i + 2, line_count - 1)
        vim.api.nvim_win_set_cursor(0, { target + 1, 0 })
        vim.cmd("startinsert")
        return
      end
    end
  end
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
  vim.api.nvim_create_user_command("WeeklyNote", function() M.open_weekly(0) end, {})
  vim.api.nvim_create_user_command("WeeklyNotePrev", function() M.open_weekly(-1) end, {})
  vim.api.nvim_create_user_command("WeeklyNoteNext", function() M.open_weekly(1) end, {})

  vim.keymap.set("n", "<leader>dn", function() M.open(0) end, { desc = "Daily note" })
  vim.keymap.set("n", "<leader>dy", function() M.open(-1) end, { desc = "Yesterday" })
  vim.keymap.set("n", "<leader>dt", function() M.open(1) end, { desc = "Tomorrow" })
  vim.keymap.set("n", "<leader>dl", M.list, { desc = "List notes" })
  vim.keymap.set("n", "<leader>ds", M.search, { desc = "Search notes" })
  vim.keymap.set("n", "<leader>dw", function() M.open_weekly(0) end, { desc = "Weekly note" })
end

return M
