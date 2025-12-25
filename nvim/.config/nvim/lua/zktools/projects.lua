-- Project management utilities for zk notes
-- Handles hierarchical project structure (PARA method)

local M = {}
local utils = require("zktools.utils")

-- ============================================================================
-- Constants
-- ============================================================================

local DIRS = {
	PROJECTS = "1-projects",
	AREAS = "3-areas",
	RESOURCES = "4-resources",
}

-- ============================================================================
-- Projects (1-projects/)
-- ============================================================================

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

	local notebook_path = utils.get_notebook_dir()
	local project_id = string.format("%s%s", area, letter)
	local slug = name:lower():gsub("%s+", "-"):gsub("[^%w%-]", "")
	local folder_name = string.format("%s-%s", project_id, slug)
	local project_dir = DIRS.PROJECTS .. "/" .. folder_name

	vim.fn.mkdir(notebook_path .. "/" .. project_dir, "p")

	require("zk").new({
		title = string.format("%s0 %s", project_id, name),
		dir = project_dir,
		edit = true,
		extra = {
			project_id = project_id,
			project_area = area,
			project_letter = letter,
		},
	})
end

--- Create a new project interactively
function M.create_project_interactive()
	vim.ui.input({ prompt = "Area number (1, 2, 3...): " }, function(area)
		if not area or area == "" then
			return
		end

		vim.ui.input({ prompt = "Project letter (a, b, c...): " }, function(letter)
			if not letter or letter == "" then
				return
			end

			vim.ui.input({ prompt = "Project name: " }, function(name)
				if not name or name == "" then
					return
				end
				M.create_project(area, letter, name)
			end)
		end)
	end)
end

--- Open projects list
function M.open_projects()
	require("zk").edit({ tags = { "project" } }, { multi_select = false })
end

-- ============================================================================
-- Areas (3-areas/)
-- ============================================================================

--- Create a new area
function M.create_area()
	vim.ui.input({ prompt = "Area number (1, 2, 3...): " }, function(area_id)
		if not area_id or area_id == "" then
			return
		end

		vim.ui.input({ prompt = "Area name: " }, function(name)
			if not name or name == "" then
				return
			end

			local types = { "personal", "work", "health", "finance", "learning", "relationships" }
			vim.ui.select(types, { prompt = "Area type:" }, function(area_type)
				if not area_type then
					return
				end

				require("zk").new({
					title = string.format("%s %s", area_id, name),
					dir = DIRS.AREAS,
					edit = true,
					extra = {
						area_id = area_id,
						area_type = area_type,
					},
				})
			end)
		end)
	end)
end

--- Open areas list
function M.open_areas()
	require("zk").edit({ tags = { "area" } }, { multi_select = false })
end

-- ============================================================================
-- Resources (4-resources/)
-- ============================================================================

--- Create a new resource
function M.create_resource()
	vim.ui.input({ prompt = "Resource name: " }, function(title)
		if not title or title == "" then
			return
		end

		local types = { "reference", "course", "book", "article", "tutorial", "research" }
		vim.ui.select(types, { prompt = "Resource type:" }, function(resource_type)
			if not resource_type then
				return
			end

			require("zk").new({
				title = title,
				dir = DIRS.RESOURCES,
				edit = true,
				extra = { resource_type = resource_type },
			})
		end)
	end)
end

--- Open resources list
function M.open_resources()
	require("zk").edit({ hrefs = { DIRS.RESOURCES } }, { multi_select = false })
end

return M
