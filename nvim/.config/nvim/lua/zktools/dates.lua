-- Date utilities for zk notes
-- Handles date calculations for periodic notes

local M = {}
local utils = require("zktools.utils")

-- ============================================================================
-- Constants
-- ============================================================================

local DIRS = {
	DAILY = "0-reviews/4-daily",
	WEEKLY = "0-reviews/3-weekly",
	MONTHLY = "0-reviews/2-monthly",
	YEARLY = "0-reviews/1-yearly",
}

local DAY_NAMES = { "monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday" }
local SECONDS_PER_DAY = 86400

-- ============================================================================
-- Daily Notes
-- ============================================================================

--- Get extra variables for daily note
--- @param offset number? Day offset from today (default: 0)
--- @return table Extra variables for template
function M.get_daily_extra(offset)
	offset = offset or 0
	local today = os.time() + (offset * SECONDS_PER_DAY)

	return {
		yesterday = os.date("%Y-%m-%d", today - SECONDS_PER_DAY),
		tomorrow = os.date("%Y-%m-%d", today + SECONDS_PER_DAY),
	}
end

--- Create daily note
--- @param offset number? Day offset from today (default: 0)
function M.create_daily_note(offset)
	offset = offset or 0
	local opts = {
		dir = DIRS.DAILY,
		extra = M.get_daily_extra(offset),
	}

	if offset ~= 0 then
		opts.date = os.date("%Y-%m-%d", os.time() + (offset * SECONDS_PER_DAY))
	end

	require("zk").new(opts)
end

-- ============================================================================
-- Weekly Notes
-- ============================================================================

--- Get extra variables for weekly note
--- @param year number? Year (defaults to current)
--- @param week number? ISO week number (defaults to current)
--- @return table Extra variables for template
function M.get_weekly_extra(year, week)
	local now = os.time()
	year = year or tonumber(os.date("%Y", now))
	week = week or tonumber(os.date("%V", now))

	local monday_ts = utils.get_week_monday(year, week)
	local monday_date = os.date("*t", monday_ts)

	-- Calculate week days
	local extra = {
		year = tostring(year),
		week_num = string.format("W%02d", week),
		week_start_formatted = os.date("%d de %B", monday_ts),
		week_end_formatted = os.date("%d de %B, %Y", monday_ts + 6 * SECONDS_PER_DAY),
		month_link = string.format("%d-M%02d", monday_date.year, monday_date.month),
		month_name = utils.get_spanish_month(monday_date.month) .. " " .. monday_date.year,
	}

	-- Add day links
	for i = 0, 6 do
		local day_ts = monday_ts + (i * SECONDS_PER_DAY)
		local day_name = DAY_NAMES[i + 1]
		extra[day_name] = os.date("%Y-%m-%d", day_ts)
		extra[day_name .. "_day"] = os.date("%d", day_ts)
	end

	-- Previous/next week navigation
	local prev_week_num, prev_week_year = week - 1, year
	if prev_week_num < 1 then
		prev_week_year = year - 1
		prev_week_num = utils.get_iso_week(prev_week_year, 12, 28)
	end

	local next_week_num, next_week_year = week + 1, year
	local last_week = utils.get_iso_week(year, 12, 28)
	if next_week_num > last_week then
		next_week_year = year + 1
		next_week_num = 1
	end

	extra.prev_week = string.format("%d-W%02d", prev_week_year, prev_week_num)
	extra.next_week = string.format("%d-W%02d", next_week_year, next_week_num)

	return extra
end

--- Create weekly note
--- @param year number? Year (defaults to current)
--- @param week number? ISO week number (defaults to current)
function M.create_weekly_note(year, week)
	require("zk").new({
		dir = DIRS.WEEKLY,
		group = "weekly",
		extra = M.get_weekly_extra(year, week),
	})
end

-- ============================================================================
-- Monthly Notes
-- ============================================================================

--- Get extra variables for monthly note
--- @param year number? Year (defaults to current)
--- @param month number? Month (1-12, defaults to current)
--- @return table Extra variables for template
function M.get_monthly_extra(year, month)
	local now = os.time()
	year = year or tonumber(os.date("%Y", now))
	month = month or tonumber(os.date("%m", now))

	-- Previous/next month navigation
	local prev_month, prev_year = month - 1, year
	if prev_month < 1 then
		prev_month, prev_year = 12, year - 1
	end

	local next_month, next_year = month + 1, year
	if next_month > 12 then
		next_month, next_year = 1, year + 1
	end

	-- Get all weeks in this month
	local last_day_num = tonumber(os.date("%d", os.time({ year = year, month = month + 1, day = 0 })))
	local weeks_set = {}

	for day = 1, last_day_num do
		local day_ts = os.time({ year = year, month = month, day = day })
		local week_num = utils.get_iso_week(year, month, day)
		local week_year = tonumber(os.date("%Y", day_ts))
		weeks_set[string.format("%d-W%02d", week_year, week_num)] = true
	end

	-- Convert to sorted list
	local weeks_list = {}
	for week_str in pairs(weeks_set) do
		table.insert(weeks_list, week_str)
	end
	table.sort(weeks_list)

	-- Format as markdown
	local weeks_md = ""
	for _, week_str in ipairs(weeks_list) do
		weeks_md = weeks_md .. string.format("- [[%s|Semana %s]]\n", week_str, week_str:match("W%d+"))
	end

	return {
		year = tostring(year),
		prev_month = string.format("%d-M%02d", prev_year, prev_month),
		next_month = string.format("%d-M%02d", next_year, next_month),
		weeks_list = weeks_md,
	}
end

--- Create monthly note
--- @param year number? Year (defaults to current)
--- @param month number? Month (1-12, defaults to current)
function M.create_monthly_note(year, month)
	require("zk").new({
		dir = DIRS.MONTHLY,
		group = "monthly",
		extra = M.get_monthly_extra(year, month),
	})
end

-- ============================================================================
-- Yearly Notes
-- ============================================================================

--- Get extra variables for yearly note
--- @param year number? Year (defaults to current)
--- @return table Extra variables for template
function M.get_yearly_extra(year)
	year = year or tonumber(os.date("%Y"))

	-- Generate months list
	local months_md = ""
	for month = 1, 12 do
		months_md = months_md
			.. string.format("- [[%d-M%02d|%s]]\n", year, month, utils.get_spanish_month(month))
	end

	return {
		year = tostring(year),
		prev_year = tostring(year - 1),
		next_year = tostring(year + 1),
		months_list = months_md,
	}
end

--- Create yearly note
--- @param year number? Year (defaults to current)
function M.create_yearly_note(year)
	require("zk").new({
		dir = DIRS.YEARLY,
		group = "yearly",
		extra = M.get_yearly_extra(year),
	})
end

return M
