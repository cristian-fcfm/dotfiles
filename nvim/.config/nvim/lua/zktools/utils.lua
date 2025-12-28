-- Utility functions for zk notes

local M = {}

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
