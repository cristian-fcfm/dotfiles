-- Habits tracking for zk weekly/monthly reviews
-- Generates habit tracking tables based on daily notes

local frontmatter = require("zktools.frontmatter")
local utils = require("zktools.utils")

local M = {}

-- Habit icons
local ICONS = {
  meditar = "󱅻",
  entrenar = "󰶏",
  leer = "󱉟",
  escribir = "",
  dormir = "󰒲",
}

local DONE = "󱓻"
local SKIP = ""

--- Get habit data for a single daily note
--- @param date string Date in YYYY-MM-DD format
--- @param weekly_file string? Path to weekly review file for targets
--- @return table Habit data {date, meditar, entrenar, leer, escribir, dormir}
local function get_daily_habit_data(date, weekly_file)
  local daily_dir = utils.get_daily_dir()
  local file_path = daily_dir .. "/" .. date .. ".md"

  local data = {
    date = date,
    meditar = false,
    entrenar = false,
    leer = false,
    escribir = false,
    dormir = false,
  }

  if not utils.file_exists(file_path) then
    return data
  end

  -- Get frontmatter from daily note
  local daily_fm = frontmatter.get_all(file_path)

  data.meditar = daily_fm.meditar or false
  data.entrenar = daily_fm.entrenar or false
  data.escribir = daily_fm.escribir or false

  -- For leer and dormir, compare with weekly targets
  local daily_target_read = 30
  local daily_target_sleep = 6

  if weekly_file and utils.file_exists(weekly_file) then
    local weekly_fm = frontmatter.get_all(weekly_file)
    daily_target_read = weekly_fm.daily_target_read or 30
    daily_target_sleep = weekly_fm.daily_target_sleep or 6
  end

  data.leer = (daily_fm.leer or 0) >= daily_target_read
  data.dormir = (daily_fm.dormir or 0) >= daily_target_sleep

  return data
end

--- Calculate streak for a habit (from most recent backwards)
--- @param notes table List of habit data (in chronological order)
--- @param habit string Habit name
--- @return number Streak count
local function calculate_streak(notes, habit)
  local count = 0
  -- Iterate backwards (from most recent)
  for i = #notes, 1, -1 do
    if notes[i][habit] then
      count = count + 1
    else
      break
    end
  end
  return count
end

--- Calculate record streak for a habit
--- @param notes table List of habit data
--- @param habit string Habit name
--- @return number Record streak count
local function calculate_record(notes, habit)
  local record = 0
  local count = 0

  for _, note in ipairs(notes) do
    if note[habit] then
      count = count + 1
      record = math.max(record, count)
    else
      count = 0
    end
  end

  return record
end

--- Generate habits tracking table for current file
--- @return table Lines of the markdown table
function M.generate_table()
  local filename = utils.get_current_filename()
  local current_file = utils.get_current_file()

  -- Parse filename to get period type and bounds
  local period_type, year, period_num = utils.parse_filename(filename)

  if not period_type then
    vim.notify("Invalid filename format. Expected YYYY-Www or YYYY-Mmm", vim.log.levels.ERROR)
    return {}
  end

  local init_timestamp, end_timestamp
  if period_type == "week" then
    init_timestamp, end_timestamp = utils.get_week_bounds(year, period_num)
  elseif period_type == "month" then
    init_timestamp, end_timestamp = utils.get_month_bounds(year, period_num)
  else
    return {}
  end

  local year_start = utils.get_year_start(year)

  -- Get all dates from year start to period end (for record calculation)
  local all_dates = utils.get_date_range(year_start, end_timestamp)

  -- Get habit data for all dates
  local all_notes = {}
  for _, date in ipairs(all_dates) do
    table.insert(all_notes, get_daily_habit_data(date, current_file))
  end

  -- Filter period dates (for display)
  local period_dates = utils.get_date_range(init_timestamp, end_timestamp)
  local period_notes = {}
  for _, date in ipairs(period_dates) do
    table.insert(period_notes, get_daily_habit_data(date, current_file))
  end

  -- Generate table lines
  local lines = {}

  -- Header
  table.insert(
    lines,
    "| Date | "
      .. ICONS.meditar
      .. " | "
      .. ICONS.entrenar
      .. " | "
      .. ICONS.leer
      .. " | "
      .. ICONS.escribir
      .. " | "
      .. ICONS.dormir
      .. " |"
  )
  table.insert(lines, "|------|:---:|:---:|:---:|:---:|:---:|")

  -- Data rows
  for _, note in ipairs(period_notes) do
    local row = string.format(
      "| [[%s]] | %s | %s | %s | %s | %s |",
      note.date,
      note.meditar and DONE or SKIP,
      note.entrenar and DONE or SKIP,
      note.leer and DONE or SKIP,
      note.escribir and DONE or SKIP,
      note.dormir and DONE or SKIP
    )
    table.insert(lines, row)
  end

  -- Calculate stats
  local habits = { "meditar", "entrenar", "leer", "escribir", "dormir" }
  local streaks = {}
  local records = {}

  for _, habit in ipairs(habits) do
    streaks[habit] = calculate_streak(all_notes, habit)
    records[habit] = calculate_record(all_notes, habit)
  end

  -- Streak row
  table.insert(
    lines,
    string.format(
      "| **Streak** | %d | %d | %d | %d | %d |",
      streaks.meditar,
      streaks.entrenar,
      streaks.leer,
      streaks.escribir,
      streaks.dormir
    )
  )

  -- Record row
  table.insert(
    lines,
    string.format(
      "| **Record** | %d | %d | %d | %d | %d |",
      records.meditar,
      records.entrenar,
      records.leer,
      records.escribir,
      records.dormir
    )
  )

  -- Empty line after table
  table.insert(lines, "")

  return lines
end

--- Find and replace habits table in current buffer
--- Looks for a marker comment or existing table
--- @return boolean Success status
function M.update_table_in_buffer()
  local lines = M.generate_table()
  if #lines == 0 then
    return false
  end

  -- Find the marker comment: <!-- habits-tracker -->
  local marker_matches = utils.find_lines("<!%-%- habits%-tracker %-%->")

  if #marker_matches > 0 then
    -- Found marker, insert table after it
    local marker_line = marker_matches[1].line_number

    -- Find end of existing table (if any)
    local buffer_lines = vim.api.nvim_buf_get_lines(0, marker_line + 1, -1, false)
    local table_end = marker_line + 1

    -- Look for table end (empty line or non-table line after table)
    local in_table = false
    for i, line in ipairs(buffer_lines) do
      if line:match("^|") then
        in_table = true
        table_end = marker_line + i
      elseif in_table and line:match("^%s*$") then
        table_end = marker_line + i
        break
      elseif in_table then
        table_end = marker_line + i - 1
        break
      end
    end

    -- Replace lines
    utils.replace_lines(marker_line + 1, table_end, lines)

    vim.notify("Habits table updated", vim.log.levels.INFO)
    return true
  else
    vim.notify("Marker '<!-- habits-tracker -->' not found in buffer", vim.log.levels.WARN)
    return false
  end
end

--- Insert habits table at cursor position
function M.insert_table_at_cursor()
  local lines = M.generate_table()
  if #lines == 0 then
    return
  end

  utils.insert_at_cursor(lines)
  vim.notify("Habits table inserted", vim.log.levels.INFO)
end

--- Insert marker and table at cursor
function M.insert_marker_and_table()
  local marker = { "<!-- habits-tracker -->", "" }
  local table_lines = M.generate_table()

  local all_lines = {}
  vim.list_extend(all_lines, marker)
  vim.list_extend(all_lines, table_lines)

  utils.insert_at_cursor(all_lines)
  vim.notify("Habits tracker inserted", vim.log.levels.INFO)
end

return M
