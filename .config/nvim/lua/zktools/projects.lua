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
  ARCHIVES = "5-archives",
}

-- ============================================================================
-- Helper Functions
-- ============================================================================

--- Validate and get user input
--- @param input any Input to validate
--- @param error_msg string Error message if validation fails
--- @return boolean Valid or not
local function validate_input(input, error_msg)
  if not input or input == "" then
    vim.notify(error_msg, vim.log.levels.ERROR)
    return false
  end
  return true
end

--- Get current project directory from buffer
--- @return string|nil Project directory path or nil if not in project
local function get_current_project_dir()
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir = vim.fn.fnamemodify(current_file, ":h")

  -- Check if we're inside a project directory
  if not string.match(current_dir, "1%-projects") then
    return nil
  end

  -- If we're in a subdirectory, go up to project root
  if not string.match(vim.fn.fnamemodify(current_dir, ":t"), "^%d+%w+%-") then
    return vim.fn.fnamemodify(current_dir, ":h")
  end

  return current_dir
end

--- List all available projects
--- @return table List of {name, path, project_id}
local function list_projects()
  local notebook_path = utils.get_notebook_dir()
  local projects_dir = notebook_path .. "/" .. DIRS.PROJECTS

  local projects = {}
  local handle = vim.loop.fs_scandir(projects_dir)

  if handle then
    while true do
      local name, type = vim.loop.fs_scandir_next(handle)
      if not name then
        break
      end

      if type == "directory" then
        -- Extract project_id from folder name (e.g., "1a-proyecto-nombre" -> "1a")
        local project_id = name:match("^(%d+%w+)%-")
        if project_id then
          table.insert(projects, {
            name = name,
            path = DIRS.PROJECTS .. "/" .. name,
            project_id = project_id,
          })
        end
      end
    end
  end

  -- Sort projects by name
  table.sort(projects, function(a, b)
    return a.name < b.name
  end)

  return projects
end

-- ============================================================================
-- Projects (1-projects/)
-- ============================================================================

--- Create a new project with hierarchical structure
--- Creates: 1-projects/<area><letter>-<name>/<area><letter>0-<name>.md
--- @param area string Area number (e.g., "1", "2", "3", "4")
--- @param letter string Project letter within area (e.g., "a", "b", "c")
--- @param name string Project name
function M.create_project(area, letter, name)
  if not validate_input(area, "Area number is required") then
    return
  end
  if not validate_input(letter, "Project letter is required") then
    return
  end
  if not validate_input(name, "Project name is required") then
    return
  end

  local notebook_path = utils.get_notebook_dir()
  local project_id = string.format("%s%s", area, letter)

  -- Slugify name manually (same as zk does)
  local slug = name:lower():gsub("%s+", "-"):gsub("[^%w%-]", "")

  -- Create project directory with final name
  local folder_name = string.format("%s-%s", project_id, slug)
  local project_dir = DIRS.PROJECTS .. "/" .. folder_name
  vim.fn.mkdir(notebook_path .. "/" .. project_dir, "p")

  -- Include project_id in title so zk generates: 1a0-proyecto-name.md
  local title_with_id = string.format("%s0 %s", project_id, name)

  -- Create project note
  require("zk").new({
    title = title_with_id,
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

--- Create a meeting note in a specific project
--- @param project table Project info {name, path, project_id}
--- @param meeting_title string Title of the meeting
function M.create_meeting_in_project(project, meeting_title)
  if not project or not meeting_title then
    return
  end

  local date_str = os.date("%Y%m%d")

  -- Format: {project_id}-YYYYMMDD-meeting-{title}
  -- Example: "1a-20251126-meeting Daily Standup"
  local title_with_format = string.format("%s-%s-meeting %s", project.project_id, date_str, meeting_title)

  require("zk").new({
    title = title_with_format,
    dir = project.path,
    template = "meeting.md",
    extra = {
      meeting_type = "project",
      project_id = project.project_id,
    },
  })
end

--- Create meeting interactively
function M.create_meeting_interactive()
  local projects = list_projects()

  if #projects == 0 then
    vim.notify("No projects found. Create a project first.", vim.log.levels.WARN)
    return
  end

  -- Create display names for projects
  local project_names = {}
  for _, project in ipairs(projects) do
    table.insert(project_names, project.name)
  end

  vim.ui.select(project_names, {
    prompt = "Select project:",
  }, function(choice, idx)
    if not choice then
      return
    end

    local selected_project = projects[idx]

    vim.ui.input({ prompt = "Meeting title: " }, function(title)
      if not title or title == "" then
        return
      end
      M.create_meeting_in_project(selected_project, title)
    end)
  end)
end

--- Open projects list
function M.open_projects()
  require("zk").edit({ hrefs = { DIRS.PROJECTS } }, { multi_select = false })
end

--- Search projects
function M.search_projects()
  vim.ui.input({ prompt = "Search projects: " }, function(search)
    if search and search ~= "" then
      require("zk").edit({ hrefs = { DIRS.PROJECTS }, match = { search } }, { multi_select = false })
    end
  end)
end

-- ============================================================================
-- Areas (3-areas/)
-- ============================================================================

--- Create a new area
function M.create_area()
  vim.ui.input({ prompt = "Area name: " }, function(title)
    if not title or title == "" then
      return
    end

    local types = { "personal", "work", "health", "finance", "learning", "relationships" }
    vim.ui.select(types, { prompt = "Area type:" }, function(area_type)
      require("zk").new({
        title = title,
        dir = DIRS.AREAS,
        extra = { area_type = area_type or "personal" },
      })
    end)
  end)
end

--- Open areas list
function M.open_areas()
  require("zk").edit({ hrefs = { DIRS.AREAS } }, { multi_select = false })
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
      require("zk").new({
        title = title,
        dir = DIRS.RESOURCES,
        extra = { resource_type = resource_type or "reference" },
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
      dir = DIRS.RESOURCES,
      template = "zettel.md",
    })
  end)
end

--- Open resources list
function M.open_resources()
  require("zk").edit({ hrefs = { DIRS.RESOURCES } }, { multi_select = false })
end

-- ============================================================================
-- Archives (5-archives/)
-- ============================================================================

--- Open archives list
function M.open_archives()
  require("zk").edit({ hrefs = { DIRS.ARCHIVES } }, { multi_select = false })
end

--- Move current note to archives
function M.archive_current_note()
  local current_file = vim.api.nvim_buf_get_name(0)
  if not current_file or current_file == "" then
    vim.notify("No file to archive", vim.log.levels.WARN)
    return
  end

  local notebook_path = utils.get_notebook_dir()

  -- Check if file is in projects or areas
  local is_project = string.match(current_file, "1%-projects")
  local is_area = string.match(current_file, "3%-areas")

  if not (is_project or is_area) then
    vim.notify("Can only archive projects or areas", vim.log.levels.WARN)
    return
  end

  -- Confirm archive
  vim.ui.input({ prompt = "Archive this note? (y/n): " }, function(confirm)
    if confirm ~= "y" and confirm ~= "Y" then
      return
    end

    local filename = vim.fn.fnamemodify(current_file, ":t")
    local archive_subfolder = is_project and "5-archives/projects" or "5-archives/areas"
    local archive_dir = notebook_path .. "/" .. archive_subfolder

    -- Create archive directory and move file
    vim.fn.mkdir(archive_dir, "p")
    local new_path = archive_dir .. "/" .. filename
    local success = vim.fn.rename(current_file, new_path)

    if success == 0 then
      vim.notify("Note archived successfully", vim.log.levels.INFO)
      vim.cmd("bdelete!")
      vim.cmd("edit " .. new_path)
    else
      vim.notify("Failed to archive note", vim.log.levels.ERROR)
    end
  end)
end

return M
