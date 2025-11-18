-- Frontmatter parsing utilities using zk CLI
-- Uses `zk list` command to access YAML frontmatter efficiently

local M = {}

--- Get frontmatter fields from a note using zk list
--- @param file_path string Path to the note file
--- @param fields table List of fields to extract (e.g., {"meditar", "entrenar"})
--- @return table|nil Frontmatter data or nil if error
function M.get_fields(file_path, fields)
	if not file_path then
		return nil
	end

	-- Construir formato de selección para zk list
	local format_parts = {}
	for _, field in ipairs(fields) do
		table.insert(format_parts, string.format('"%s": "{{%s}}"', field, field))
	end
	local format = "{" .. table.concat(format_parts, ", ") .. "}"

	-- Ejecutar zk list con formato JSON
	local cmd = string.format('zk list --format "%s" --match-strategy exact "%s" 2>/dev/null', format, file_path)
	local handle = io.popen(cmd)
	if not handle then
		return nil
	end

	local result = handle:read("*a")
	handle:close()

	if not result or result == "" then
		return nil
	end

	-- Parsear JSON simple (asumiendo formato conocido)
	local data = {}
	for key, value in result:gmatch('"([^"]+)":%s*"([^"]*)"') do
		-- Convertir valores booleanos y numéricos
		if value == "true" then
			data[key] = true
		elseif value == "false" then
			data[key] = false
		elseif value:match("^%-?%d+$") then
			data[key] = tonumber(value)
		elseif value:match("^%-?%d+%.%d+$") then
			data[key] = tonumber(value)
		else
			data[key] = value
		end
	end

	return data
end

--- Get a single field value from frontmatter
--- @param file_path string Path to the note file
--- @param field string Field name to extract
--- @return any|nil Field value or nil if not found
function M.get_field(file_path, field)
	local data = M.get_fields(file_path, { field })
	return data and data[field] or nil
end

--- Get all frontmatter from a note
--- Uses direct file parsing for complete frontmatter
--- @param file_path string Path to the note file
--- @return table|nil Frontmatter data or nil if error
function M.get_all(file_path)
	local file = io.open(file_path, "r")
	if not file then
		return nil
	end

	local content = file:read("*all")
	file:close()

	-- Extract YAML frontmatter
	local frontmatter = content:match("^%-%-%-\n(.-)\n%-%-%-")
	if not frontmatter then
		return {}
	end

	local data = {}
	for line in frontmatter:gmatch("[^\n]+") do
		-- Parse YAML key: value pairs
		local key, value = line:match("^(%w+):%s*(.+)$")
		if key and value then
			-- Remove quotes if present
			value = value:gsub('^"(.*)"$', "%1"):gsub("^'(.*)'$", "%1")

			-- Convert boolean values
			if value == "true" then
				data[key] = true
			elseif value == "false" then
				data[key] = false
			elseif value:match("^%-?%d+$") then
				data[key] = tonumber(value)
			elseif value:match("^%-?%d+%.%d+$") then
				data[key] = tonumber(value)
			elseif value:match("^%[.*%]$") then
				-- Simple array parsing
				local array = {}
				for item in value:gmatch("[^,%[%]%s]+") do
					table.insert(array, item)
				end
				data[key] = array
			else
				data[key] = value
			end
		end
	end

	return data
end

--- Update frontmatter field in a note
--- @param file_path string Path to the note file
--- @param field string Field name to update
--- @param value any New value for the field
--- @return boolean Success status
function M.update_field(file_path, field, value)
	local file = io.open(file_path, "r")
	if not file then
		return false
	end

	local content = file:read("*all")
	file:close()

	-- Find and replace field in frontmatter
	local pattern = string.format("(%-%-%-\n.-)(%s:%s*)[^\n]+(.-\n%-%-%-)", field)
	local formatted_value = value
	if type(value) == "boolean" then
		formatted_value = tostring(value)
	elseif type(value) == "string" then
		formatted_value = value
	elseif type(value) == "number" then
		formatted_value = tostring(value)
	end

	local new_content = content:gsub(pattern, "%1%2" .. formatted_value .. "%3")

	-- Write back to file
	file = io.open(file_path, "w")
	if not file then
		return false
	end

	file:write(new_content)
	file:close()

	return true
end

--- Get daily notes in a date range with specific fields
--- @param start_date string Start date (YYYY-MM-DD)
--- @param end_date string End date (YYYY-MM-DD)
--- @param fields table List of fields to extract
--- @return table List of notes with their data
function M.get_daily_range(start_date, end_date, fields)
	local daily_dir = vim.fn.expand("$ZK_NOTEBOOK_DIR") .. "/0.reviews/4.daily"

	-- Construir comando zk list para buscar notas en el rango
	local format_parts = { '"path": "{{path}}"', '"date": "{{filename-stem}}"' }
	for _, field in ipairs(fields) do
		table.insert(format_parts, string.format('"%s": "{{%s}}"', field, field))
	end
	local format = "{" .. table.concat(format_parts, ", ") .. "}"

	local cmd = string.format(
		'zk list --format "%s" --sort path %s --match-strategy partial 2>/dev/null | head -500',
		format,
		daily_dir
	)

	local handle = io.popen(cmd)
	if not handle then
		return {}
	end

	local result = handle:read("*a")
	handle:close()

	-- Parse results (simple JSON parsing for each line)
	local notes = {}
	for line in result:gmatch("[^\n]+") do
		local note = {}
		for key, value in line:gmatch('"([^"]+)":%s*"([^"]*)"') do
			if value == "true" then
				note[key] = true
			elseif value == "false" then
				note[key] = false
			elseif value:match("^%-?%d+$") then
				note[key] = tonumber(value)
			elseif value:match("^%-?%d+%.%d+$") then
				note[key] = tonumber(value)
			else
				note[key] = value
			end
		end

		-- Filter by date range
		if note.date and note.date >= start_date and note.date <= end_date then
			table.insert(notes, note)
		end
	end

	return notes
end

return M
