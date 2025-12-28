-- Date utilities for zk notes
-- Handles date calculations for periodic notes

local M = {}
local date = require("date")

-- ============================================================================
-- Constants
-- ============================================================================

local DIRS = {
  DAILY = "0-reviews/4-daily",
  WEEKLY = "0-reviews/3-weekly",
  MONTHLY = "0-reviews/2-monthly",
  YEARLY = "0-reviews/1-yearly",
}

-- ============================================================================
-- Daily Notes
-- ============================================================================

--- Get extra variables for daily note
--- @param offset number? Day offset from today (default: 0)
--- @return table Extra variables for template
function M.get_daily_extra(offset)
  offset = offset or 0
  local today = date():adddays(offset)

  -- Get ISO week information
  local year = today:getisoyear()
  local week = today:getisoweeknumber()

  return {
    yesterday = today:adddays(-1):fmt("%Y-%m-%d"),
    tomorrow = today:adddays(1):fmt("%Y-%m-%d"),
    week_link = string.format("%d-W%02d", year, week),
  }
end

--- Create daily note
--- @param offset number? Day offset from today (default: 0)
function M.create_daily_note(offset)
  offset = offset or 0
  local today = date():adddays(offset)

  local opts = {
    dir = DIRS.DAILY,
    extra = M.get_daily_extra(offset),
    date = today:fmt("%Y-%m-%d"),
  }

  require("zk").new(opts)
end

-- ============================================================================
-- Weekly Notes
-- ============================================================================

--- Get extra variables for weekly note
--- @param offset number? Week offset from current week (default: 0)
--- @return table Extra variables for template
function M.get_weekly_extra(offset)
  offset = offset or 0

  -- Get target date based on offset
  local target_date = date():adddays(offset * 7)
  local year = target_date:getisoyear()
  local week = target_date:getisoweeknumber()

  -- Get Monday and Sunday of the week
  local monday = target_date:copy():setisoweekday(1)
  local sunday = target_date:copy():setisoweekday(7)

  -- Get next and prev week
  local prev_week = target_date:copy():adddays(-7)
  local next_week = target_date:copy():adddays(7)

  -- Calculate week days
  local extra = {
    year = tostring(year),
    week_num = string.format("W%02d", week),
    week_start_formatted = monday:fmt("%d de %B"),
    week_end_formatted = sunday:fmt("%d de %B, %Y"),
    month_link = string.format("%d-M%02d", tonumber(monday:fmt("%Y")), tonumber(monday:fmt("%m"))),
    month_name = monday:fmt("%B %Y"),
    prev_week = string.format("%d-W%02d", prev_week:getisoyear(), prev_week:getisoweeknumber()),
    next_week = string.format("%d-W%02d", next_week:getisoyear(), next_week:getisoweeknumber()),
  }

  -- Add day links
  for i = 0, 6 do
    local day = monday:copy():adddays(i)
    local day_name = day:fmt("%A"):lower()
    extra[day_name] = day:fmt("%Y-%m-%d")
    extra[day_name .. "_day"] = day:fmt("%A %d")
  end

  return extra
end

--- Create weekly note
--- @param offset number? Week offset from current week (default: 0)
function M.create_weekly_note(offset)
  offset = offset or 0
  local target_date = date():adddays(offset * 7)

  local opts = {
    dir = DIRS.WEEKLY,
    group = "weekly",
    extra = M.get_weekly_extra(offset),
    date = target_date:fmt("%Y-%m-%d"),
  }

  require("zk").new(opts)
end

-- ============================================================================
-- Monthly Notes
-- ============================================================================

--- Get extra variables for monthly note
--- @param offset number? Month offset from current month (default: 0)
--- @return table Extra variables for template
function M.get_monthly_extra(offset)
  offset = offset or 0

  -- Get target month based on offset
  local target_month = date():setday(1):addmonths(offset)
  local year = target_month:getyear()
  local month = target_month:getmonth()

  -- Previous/next month navigation
  local prev_month = target_month:copy():addmonths(-1)
  local next_month = target_month:copy():addmonths(1)

  -- Find first Monday in or after the month starts
  local current = target_month:copy():setisoweekday(1)
  if current:getmonth() ~= month then
    current = current:adddays(7)
  end

  -- Collect all Mondays that belong to this month
  local weeks_list = {}
  while current:getmonth() == month do
    local week_year = current:getisoyear()
    local week_num = current:getisoweeknumber()
    table.insert(weeks_list, string.format("%d-W%02d", week_year, week_num))
    current = current:adddays(7)
  end

  -- Format as markdown
  local weeks_md = ""
  for _, week_str in ipairs(weeks_list) do
    weeks_md = weeks_md .. string.format("- [[%s|Semana %s]]\n", week_str, week_str:match("W%d+"))
  end

  return {
    year = tostring(year),
    prev_month = string.format("%d-M%02d", prev_month:getyear(), prev_month:getmonth()),
    next_month = string.format("%d-M%02d", next_month:getyear(), next_month:getmonth()),
    weeks_list = weeks_md,
  }
end

--- Create monthly note
--- @param offset number? Month offset from current month (default: 0)
function M.create_monthly_note(offset)
  offset = offset or 0
  local target_month = date():setday(1):addmonths(offset)

  local opts = {
    dir = DIRS.MONTHLY,
    group = "monthly",
    extra = M.get_monthly_extra(offset),
    date = target_month:fmt("%Y-%m-%d"),
  }

  require("zk").new(opts)
end

-- ============================================================================
-- Yearly Notes
-- ============================================================================

--- Get extra variables for yearly note
--- @param offset number? Year offset from current year (default: 0)
--- @return table Extra variables for template
function M.get_yearly_extra(offset)
  offset = offset or 0

  -- Get target year based on offset
  local target_year = date():addyears(offset)
  local year = target_year:getyear()

  -- Generate months list
  local months_md = ""
  for month = 1, 12 do
    local month_name = date(year, month, 1):fmt("%B")
    months_md = months_md .. string.format("- [[%d-M%02d|%s]]\n", year, month, month_name)
  end

  return {
    year = tostring(year),
    prev_year = tostring(year - 1),
    next_year = tostring(year + 1),
    months_list = months_md,
  }
end

--- Create yearly note
--- @param offset number? Year offset from current year (default: 0)
function M.create_yearly_note(offset)
  offset = offset or 0
  local target_year = date():addyears(offset)

  local opts = {
    dir = DIRS.YEARLY,
    group = "yearly",
    extra = M.get_yearly_extra(offset),
    date = target_year:fmt("%Y-%m-%d"),
  }

  require("zk").new(opts)
end

return M
