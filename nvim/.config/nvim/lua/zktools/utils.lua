-- Utility functions for zk notes

local M = {}

-- ============================================================================
-- Spanish Localization
-- ============================================================================

local SPANISH_MONTHS = {
	"Enero",
	"Febrero",
	"Marzo",
	"Abril",
	"Mayo",
	"Junio",
	"Julio",
	"Agosto",
	"Septiembre",
	"Octubre",
	"Noviembre",
	"Diciembre",
}

--- Get Spanish month name
--- @param month_num number Month number (1-12)
--- @return string Spanish month name
function M.get_spanish_month(month_num)
	return SPANISH_MONTHS[month_num] or ""
end

-- ============================================================================
-- Date Utilities
-- ============================================================================

--- Calculate ISO week number
--- @param year number Year
--- @param month number Month (1-12)
--- @param day number Day of month
--- @return number Week number
function M.get_iso_week(year, month, day)
	return tonumber(os.date("%V", os.time({ year = year, month = month, day = day })))
end

--- Get Monday of ISO week
--- @param year number Year
--- @param week number ISO week number
--- @return number Timestamp of Monday
function M.get_week_monday(year, week)
	local jan4 = os.time({ year = year, month = 1, day = 4 })
	local jan4_wday = tonumber(os.date("%w", jan4))
	local week1_monday = jan4 - (jan4_wday == 0 and 6 or jan4_wday - 1) * 86400
	return week1_monday + (week - 1) * 7 * 86400
end

-- ============================================================================
-- Path Utilities
-- ============================================================================

--- Get notebook directory from ZK_NOTEBOOK_DIR env var
--- @return string Notebook directory path
function M.get_notebook_dir()
	local notebook_dir = vim.env.ZK_NOTEBOOK_DIR
	if notebook_dir and notebook_dir ~= "" then
		return vim.fn.expand(notebook_dir)
	end

	local cwd = vim.fn.getcwd()
	local zk_root = vim.fs.find(".zk", { path = cwd, upward = true, type = "directory" })[1]
	if zk_root then
		return vim.fn.fnamemodify(zk_root, ":h")
	end

	return cwd
end

return M
