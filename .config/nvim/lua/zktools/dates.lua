-- Date utilities for zk notes
-- Handles date calculations for daily and weekly notes

local M = {}

--- Spanish month names
local SPANISH_MONTHS = {
	"Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio",
	"Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"
}

--- Calculate ISO week number
--- @param year number Year
--- @param month number Month (1-12)
--- @param day number Day of month
--- @return number Week number
local function get_iso_week(year, month, day)
	local timestamp = os.time({ year = year, month = month, day = day })
	return tonumber(os.date("%V", timestamp))
end

--- Get Monday of ISO week
--- @param year number Year
--- @param week number ISO week number
--- @return number Timestamp of Monday
local function get_week_monday(year, week)
	local jan4 = os.time({ year = year, month = 1, day = 4 })
	local jan4_wday = tonumber(os.date("%w", jan4))
	local week1_monday = jan4 - (jan4_wday == 0 and 6 or jan4_wday - 1) * 86400
	return week1_monday + (week - 1) * 7 * 86400
end

--- Get Spanish month name
--- @param month_num number Month number (1-12)
--- @return string Spanish month name
local function get_spanish_month(month_num)
	return SPANISH_MONTHS[month_num] or ""
end

--- Get extra variables for daily note
--- @param offset number? Day offset from today (default: 0)
--- @return table Extra variables for template
function M.get_daily_extra(offset)
	offset = offset or 0
	local today = os.time() + (offset * 86400)
	local yesterday = today - 86400
	local tomorrow = today + 86400

	return {
		yesterday = os.date("%Y-%m-%d", yesterday),
		tomorrow = os.date("%Y-%m-%d", tomorrow),
	}
end

--- Get extra variables for weekly note
--- @param year number? Year (defaults to current)
--- @param week number? ISO week number (defaults to current)
--- @return table Extra variables for template
function M.get_weekly_extra(year, week)
	local now = os.time()
	year = year or tonumber(os.date("%Y", now))
	week = week or tonumber(os.date("%V", now))

	-- Get Monday of the week
	local monday_ts = get_week_monday(year, week)

	-- Calculate all days of the week
	local days = {}
	local day_names = { "monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday" }

	for i = 0, 6 do
		local day_ts = monday_ts + (i * 86400)
		local date_str = os.date("%Y-%m-%d", day_ts)
		local day_num = os.date("%d", day_ts)

		days[day_names[i + 1]] = date_str
		days[day_names[i + 1] .. "_day"] = day_num
	end

	-- Week start/end formatted
	local week_start = os.date("%d de %B", monday_ts)
	local week_end_ts = monday_ts + (6 * 86400)
	local week_end = os.date("%d de %B, %Y", week_end_ts)

	-- Month for navigation
	local monday_date = os.date("*t", monday_ts)
	local month_link = string.format("%d-M%02d", monday_date.year, monday_date.month)
	local month_name = get_spanish_month(monday_date.month) .. " " .. monday_date.year

	-- Previous week
	local prev_week_num = week - 1
	local prev_week_year = year
	if prev_week_num < 1 then
		prev_week_year = year - 1
		prev_week_num = get_iso_week(prev_week_year, 12, 28)
	end

	-- Next week
	local next_week_num = week + 1
	local next_week_year = year
	local last_week = get_iso_week(year, 12, 28)
	if next_week_num > last_week then
		next_week_year = year + 1
		next_week_num = 1
	end

	local prev_week = string.format("%d-W%02d", prev_week_year, prev_week_num)
	local next_week = string.format("%d-W%02d", next_week_year, next_week_num)

	-- Combine all variables
	local extra = {
		year = tostring(year),
		week_num = string.format("W%02d", week),
		week_start_formatted = week_start,
		week_end_formatted = week_end,
		month_link = month_link,
		month_name = month_name,
		prev_week = prev_week,
		next_week = next_week,
	}

	-- Add all day variables
	for k, v in pairs(days) do
		extra[k] = v
	end

	return extra
end

--- Create daily note with zk.nvim
--- @param offset number? Day offset from today (default: 0)
function M.create_daily_note(offset)
	offset = offset or 0
	local extra = M.get_daily_extra(offset)
	local date = offset == 0 and nil or os.date("%Y-%m-%d", os.time() + (offset * 86400))

	local opts = {
		dir = "0-reviews/4-daily",
		extra = extra,
	}

	if date then
		opts.date = date
	end

	require("zk").new(opts)
end

--- Create weekly note with zk.nvim
--- @param year number? Year (defaults to current)
--- @param week number? ISO week number (defaults to current)
function M.create_weekly_note(year, week)
	local extra = M.get_weekly_extra(year, week)

	require("zk").new({
		dir = "0-reviews/3-weekly",
		group = "weekly",
		extra = extra,
	})
end

--- Get extra variables for monthly note
--- @param year number? Year (defaults to current)
--- @param month number? Month (1-12, defaults to current)
--- @return table Extra variables for template
function M.get_monthly_extra(year, month)
	local now = os.time()
	year = year or tonumber(os.date("%Y", now))
	month = month or tonumber(os.date("%m", now))

	-- Previous month calculation
	local prev_month = month - 1
	local prev_year = year
	if prev_month < 1 then
		prev_month = 12
		prev_year = year - 1
	end

	-- Next month calculation
	local next_month = month + 1
	local next_year = year
	if next_month > 12 then
		next_month = 1
		next_year = year + 1
	end

	-- Format month links
	local prev_month_link = string.format("%d-M%02d", prev_year, prev_month)
	local next_month_link = string.format("%d-M%02d", next_year, next_month)

	-- Get all weeks in this month
	local first_day = os.time({ year = year, month = month, day = 1 })
	local last_day_num = tonumber(os.date("%d", os.time({ year = year, month = month + 1, day = 0 })))

	local weeks_set = {}
	for day = 1, last_day_num do
		local day_ts = os.time({ year = year, month = month, day = day })
		local week_num = get_iso_week(year, month, day)
		local week_year = tonumber(os.date("%Y", day_ts))
		local week_str = string.format("%d-W%02d", week_year, week_num)
		weeks_set[week_str] = true
	end

	-- Convert set to sorted list for display
	local weeks_list = {}
	for week in pairs(weeks_set) do
		table.insert(weeks_list, week)
	end
	table.sort(weeks_list)

	-- Format weeks list as markdown bullets
	local weeks_md = ""
	for _, week in ipairs(weeks_list) do
		weeks_md = weeks_md .. string.format("- [[%s|Semana %s]]\n", week, week:match("W%d+"))
	end

	return {
		year = tostring(year),
		prev_month = prev_month_link,
		next_month = next_month_link,
		weeks_list = weeks_md,
	}
end

--- Create monthly note with zk.nvim
--- @param year number? Year (defaults to current)
--- @param month number? Month (1-12, defaults to current)
function M.create_monthly_note(year, month)
	local extra = M.get_monthly_extra(year, month)

	require("zk").new({
		dir = "0-reviews/2-monthly",
		group = "monthly",
		extra = extra,
	})
end

--- Get extra variables for yearly note
--- @param year number? Year (defaults to current)
--- @return table Extra variables for template
function M.get_yearly_extra(year)
	local now = os.time()
	year = year or tonumber(os.date("%Y", now))

	-- Previous and next year
	local prev_year = tostring(year - 1)
	local next_year = tostring(year + 1)

	-- Generate list of months
	local months_md = ""
	for month = 1, 12 do
		local month_link = string.format("%d-M%02d", year, month)
		local month_name = get_spanish_month(month)
		months_md = months_md .. string.format("- [[%s|%s]]\n", month_link, month_name)
	end

	return {
		year = tostring(year),
		prev_year = prev_year,
		next_year = next_year,
		months_list = months_md,
	}
end

--- Create yearly note with zk.nvim
--- @param year number? Year (defaults to current)
function M.create_yearly_note(year)
	local extra = M.get_yearly_extra(year)

	require("zk").new({
		dir = "0-reviews/1-yearly",
		group = "yearly",
		extra = extra,
	})
end

return M
