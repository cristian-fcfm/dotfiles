-- Utility functions for zk notes

local M = {}

--- Parse date string to table
--- @param date_str string Date in YYYY-MM-DD format
--- @return table|nil Date table {year, month, day} or nil
function M.parse_date(date_str)
	local year, month, day = date_str:match("^(%d%d%d%d)%-(%d%d)%-(%d%d)$")
	if not year then
		return nil
	end
	return { year = tonumber(year), month = tonumber(month), day = tonumber(day) }
end

--- Convert date table to timestamp
--- @param date_table table Date table {year, month, day}
--- @return number Unix timestamp
function M.date_to_timestamp(date_table)
	return os.time(date_table)
end

--- Format timestamp to date string
--- @param timestamp number Unix timestamp
--- @param format string? Date format (default: "%Y-%m-%d")
--- @return string Formatted date
function M.format_timestamp(timestamp, format)
	format = format or "%Y-%m-%d"
	return os.date(format, timestamp)
end

--- Get ISO week number for a date
--- @param year number Year
--- @param month number Month
--- @param day number Day
--- @return number Week number
function M.get_week_number(year, month, day)
	local timestamp = os.time({ year = year, month = month, day = day })
	return tonumber(os.date("%V", timestamp))
end

--- Get week bounds (start and end timestamps)
--- @param year number Year
--- @param week number ISO week number
--- @return number, number Start and end timestamps
function M.get_week_bounds(year, week)
	-- Calculate first and last day of ISO week
	local jan4 = os.time({ year = year, month = 1, day = 4 })
	local jan4_wday = tonumber(os.date("%w", jan4))
	local week_start = jan4 - (jan4_wday == 0 and 6 or jan4_wday - 1) * 86400

	local target_week_start = week_start + (week - 1) * 7 * 86400
	local target_week_end = target_week_start + 6 * 86400

	return target_week_start, target_week_end
end

--- Get month bounds (start and end timestamps)
--- @param year number Year
--- @param month number Month (1-12)
--- @return number, number Start and end timestamps
function M.get_month_bounds(year, month)
	local first_day = os.time({ year = year, month = month, day = 1 })

	-- Last day of month
	local next_month = month == 12 and 1 or month + 1
	local next_year = month == 12 and year + 1 or year
	local last_day = os.time({ year = next_year, month = next_month, day = 1 }) - 86400

	return first_day, last_day
end

--- Get year start timestamp
--- @param year number Year
--- @return number Year start timestamp
function M.get_year_start(year)
	return os.time({ year = year, month = 1, day = 1 })
end

--- Parse filename to extract period info (week or month)
--- @param filename string Filename (e.g., "2025-W47" or "2025-M11")
--- @return string, number, number Type ("week" or "month"), year, period_number
function M.parse_filename(filename)
	-- Remove .md extension if present
	filename = filename:gsub("%.md$", "")

	-- Try to match week format: YYYY-Www
	local year, week = filename:match("^(%d%d%d%d)%-W(%d+)$")
	if year and week then
		return "week", tonumber(year), tonumber(week)
	end

	-- Try to match month format: YYYY-Mmm
	local year2, month = filename:match("^(%d%d%d%d)%-M(%d+)$")
	if year2 and month then
		return "month", tonumber(year2), tonumber(month)
	end

	return nil, nil, nil
end

--- Get all dates in a range
--- @param start_timestamp number Start timestamp
--- @param end_timestamp number End timestamp
--- @return table List of date strings (YYYY-MM-DD)
function M.get_date_range(start_timestamp, end_timestamp)
	local dates = {}
	local current = start_timestamp

	while current <= end_timestamp do
		table.insert(dates, os.date("%Y-%m-%d", current))
		current = current + 86400 -- +1 day
	end

	return dates
end

--- Check if file exists
--- @param path string File path
--- @return boolean True if file exists
function M.file_exists(path)
	local file = io.open(path, "r")
	if file then
		file:close()
		return true
	end
	return false
end

--- Get notebook directory
--- @return string Notebook directory path
function M.get_notebook_dir()
	return vim.fn.expand("$ZK_NOTEBOOK_DIR") or vim.fn.getcwd()
end

--- Get daily notes directory
--- @return string Daily notes directory path
function M.get_daily_dir()
	return M.get_notebook_dir() .. "/0.reviews/4.daily"
end

--- Get weekly notes directory
--- @return string Weekly notes directory path
function M.get_weekly_dir()
	return M.get_notebook_dir() .. "/0.reviews/3.weekly"
end

--- Get current buffer file path
--- @return string Current file path
function M.get_current_file()
	return vim.fn.expand("%:p")
end

--- Get current buffer filename (without path or extension)
--- @return string Filename
function M.get_current_filename()
	return vim.fn.expand("%:t:r")
end

--- Insert text at current cursor position
--- @param lines table|string Lines to insert (table of strings or single string)
function M.insert_at_cursor(lines)
	if type(lines) == "string" then
		lines = vim.split(lines, "\n")
	end

	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	vim.api.nvim_buf_set_lines(0, row, row, false, lines)
end

--- Replace lines in buffer
--- @param start_line number Start line (0-indexed)
--- @param end_line number End line (0-indexed, exclusive)
--- @param lines table Lines to insert
function M.replace_lines(start_line, end_line, lines)
	vim.api.nvim_buf_set_lines(0, start_line, end_line, false, lines)
end

--- Find lines matching pattern in current buffer
--- @param pattern string Lua pattern to match
--- @return table List of {line_number, line_content}
function M.find_lines(pattern)
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local matches = {}

	for i, line in ipairs(lines) do
		if line:match(pattern) then
			table.insert(matches, { line_number = i - 1, content = line })
		end
	end

	return matches
end

return M
