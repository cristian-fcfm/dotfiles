-- Project management utilities for zk notes
-- Handles hierarchical project structure

local M = {}

--- Create a new project with hierarchical structure
--- Creates: 1-projects/<area><letter>-<name>/<area><letter>0-<name>.md
--- @param area string Area number (e.g., "1", "2", "3", "4")
--- @param letter string Project letter within area (e.g., "a", "b", "c")
--- @param name string Project name
function M.create_project(area, letter, name)
	if not area or area == "" then
		vim.notify("Area number is required", vim.log.levels.ERROR)
		return
	end
	if not letter or letter == "" then
		vim.notify("Project letter is required", vim.log.levels.ERROR)
		return
	end
	if not name or name == "" then
		vim.notify("Project name is required", vim.log.levels.ERROR)
		return
	end

	-- Slugify name for filesystem
	local slug_name = name:lower():gsub("%s+", "-"):gsub("[^%w%-]", "")

	-- Format: "1a-desarrollo-web"
	local folder_name = string.format("%s%s-%s", area, letter, slug_name)
	local project_dir = "1-projects/" .. folder_name

	-- Format: "1a0-desarrollo-web"
	local file_name = string.format("%s%s0-%s", area, letter, slug_name)

	-- Create the project directory first
	local notebook_path = vim.fn.expand("$HOME/Documents/notes")
	local full_project_dir = notebook_path .. "/" .. project_dir
	vim.fn.mkdir(full_project_dir, "p")

	-- Setup autocmd to rename file after creation
	local augroup = vim.api.nvim_create_augroup("ZkProjectRename", { clear = false })
	vim.api.nvim_create_autocmd("BufEnter", {
		group = augroup,
		pattern = full_project_dir .. "/*.md",
		once = true,
		callback = function(ev)
			local current_file = ev.file
			local expected_name = full_project_dir .. "/" .. file_name .. ".md"

			if current_file ~= expected_name then
				vim.fn.rename(current_file, expected_name)
				vim.cmd("edit! " .. vim.fn.fnameescape(expected_name))
			end
		end,
	})

	-- Create the project using zk
	require("zk").new({
		title = name,
		dir = project_dir,
		template = "project.md",
		notebookPath = notebook_path,
		edit = true,
		extra = {
			project_id = string.format("%s%s", area, letter),
			project_area = area,
			project_letter = letter,
		},
	})
end

--- Create a new project interactively
function M.create_project_interactive()
	-- Ask for area
	vim.ui.input({ prompt = "Area number (1-4): " }, function(area)
		if not area or area == "" then
			return
		end

		-- Ask for project letter
		vim.ui.input({ prompt = "Project letter (a, b, c...): " }, function(letter)
			if not letter or letter == "" then
				return
			end

			-- Ask for project name
			vim.ui.input({ prompt = "Project name: " }, function(name)
				if not name or name == "" then
					return
				end

				M.create_project(area, letter, name)
			end)
		end)
	end)
end

--- Create a meeting note within a project directory
--- @param meeting_title string Title of the meeting
function M.create_meeting_in_project(meeting_title)
	-- Get current buffer directory
	local current_file = vim.api.nvim_buf_get_name(0)
	local current_dir = vim.fn.fnamemodify(current_file, ":h")

	-- Check if we're inside a project directory
	if not string.match(current_dir, "1%-projects") then
		vim.notify("Not in a project directory", vim.log.levels.WARN)
		return
	end

	-- Extract project directory (should be the folder containing the note)
	local project_dir = current_dir
	-- If we're in a subdirectory, go up
	if not string.match(vim.fn.fnamemodify(current_dir, ":t"), "^%d+%w+%-") then
		project_dir = vim.fn.fnamemodify(current_dir, ":h")
	end

	-- Create meeting with date prefix
	local date_prefix = os.date("%Y-%m-%d")
	local meeting_filename = string.format("%s-%s", date_prefix, meeting_title:gsub("%s+", "-"):lower())

	-- Use relative path from notebook root
	local notebook_path = vim.fn.expand("$HOME/Documents/notes")
	local relative_dir = project_dir:gsub("^" .. notebook_path .. "/", "")

	require("zk").new({
		title = meeting_title,
		dir = relative_dir,
		template = "meeting.md",
		extra = {
			meeting_type = "project",
		},
	})

	-- Rename the file with date prefix
	vim.defer_fn(function()
		local current = vim.api.nvim_buf_get_name(0)
		if current and current ~= "" then
			local dir = vim.fn.fnamemodify(current, ":h")
			local new_path = dir .. "/" .. meeting_filename .. ".md"
			if current ~= new_path then
				vim.cmd("saveas " .. vim.fn.fnameescape(new_path))
				vim.fn.delete(current)
			end
		end
	end, 500)
end

--- Create meeting interactively
function M.create_meeting_interactive()
	vim.ui.input({ prompt = "Meeting title: " }, function(title)
		if not title or title == "" then
			return
		end
		M.create_meeting_in_project(title)
	end)
end

--- Open projects list
function M.open_projects()
	require("zk").edit({ hrefs = { "1-projects" } }, { multi_select = false })
end

--- Search projects
function M.search_projects()
	vim.ui.input({ prompt = "Search projects: " }, function(search)
		if search and search ~= "" then
			require("zk").edit({ hrefs = { "1-projects" }, match = { search } }, { multi_select = false })
		end
	end)
end

--- Create a new area
function M.create_area()
	vim.ui.input({ prompt = "Area name: " }, function(title)
		if not title or title == "" then
			return
		end

		vim.ui.select({ "personal", "work", "health", "finance", "learning", "relationships" }, {
			prompt = "Area type:",
		}, function(area_type)
			if not area_type then
				area_type = "personal"
			end

			require("zk").new({
				title = title,
				dir = "3-areas",
				template = "area.md",
				extra = {
					area_type = area_type,
				},
			})
		end)
	end)
end

--- Open areas list
function M.open_areas()
	require("zk").edit({ hrefs = { "3-areas" } }, { multi_select = false })
end

--- Create a new resource
function M.create_resource()
	vim.ui.input({ prompt = "Resource name: " }, function(title)
		if not title or title == "" then
			return
		end

		vim.ui.select({ "reference", "course", "book", "article", "tutorial", "research" }, {
			prompt = "Resource type:",
		}, function(resource_type)
			if not resource_type then
				resource_type = "reference"
			end

			require("zk").new({
				title = title,
				dir = "4-resources",
				template = "resource.md",
				extra = {
					resource_type = resource_type,
				},
			})
		end)
	end)
end

--- Create a new zettelkasten note
function M.create_zettel()
	vim.ui.input({ prompt = "Zettel title: " }, function(title)
		if not title or title == "" then
			return
		end

		require("zk").new({
			title = title,
			dir = "4-resources",
			template = "zettel.md",
		})
	end)
end

--- Open resources list
function M.open_resources()
	require("zk").edit({ hrefs = { "4-resources" } }, { multi_select = false })
end

--- Archive a note (move to archives)
--- This is a manual process in zk, just opens the archives folder
function M.open_archives()
	require("zk").edit({ hrefs = { "5-archives" } }, { multi_select = false })
end

--- Move current note to archives
function M.archive_current_note()
	local current_file = vim.api.nvim_buf_get_name(0)
	if not current_file or current_file == "" then
		vim.notify("No file to archive", vim.log.levels.WARN)
		return
	end

	-- Get the notebook path
	local notebook_path = vim.fn.expand("$HOME/Documents/notes")

	-- Check if file is in projects or areas
	if not (string.match(current_file, "1%-projects") or string.match(current_file, "3%-areas")) then
		vim.notify("Can only archive projects or areas", vim.log.levels.WARN)
		return
	end

	-- Confirm archive
	vim.ui.input({ prompt = "Archive this note? (y/n): " }, function(confirm)
		if confirm ~= "y" and confirm ~= "Y" then
			return
		end

		-- Get relative path
		local rel_path = current_file:gsub("^" .. notebook_path .. "/", "")
		local filename = vim.fn.fnamemodify(current_file, ":t")

		-- Determine archive subfolder
		local archive_subfolder
		if string.match(rel_path, "1%-projects") then
			archive_subfolder = "5-archives/projects"
		else
			archive_subfolder = "5-archives/areas"
		end

		-- Create archive directory if needed
		local archive_dir = notebook_path .. "/" .. archive_subfolder
		vim.fn.mkdir(archive_dir, "p")

		-- Move file
		local new_path = archive_dir .. "/" .. filename
		local success = vim.fn.rename(current_file, new_path)

		if success == 0 then
			vim.notify("Note archived successfully", vim.log.levels.INFO)
			-- Close the buffer
			vim.cmd("bdelete!")
			-- Open the archived note
			vim.cmd("edit " .. new_path)
		else
			vim.notify("Failed to archive note", vim.log.levels.ERROR)
		end
	end)
end

return M
