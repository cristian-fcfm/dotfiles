-- Heredar configuración de markdown
vim.bo.commentstring = "<!-- %s -->"
vim.bo.comments = "fb:*,fb:-,fb:+,n:>"

-- Usar parser de markdown para treesitter
vim.treesitter.language.register("markdown", "zk")

-- Heredar sintaxis de markdown
vim.cmd("runtime! syntax/markdown.vim")

-- Configuración específica de zk si es necesario
vim.opt_local.conceallevel = 2
vim.opt_local.wrap = true
vim.opt_local.linebreak = true

-- Habits tracker autocmds (load only if module exists)
local has_habits, habits = pcall(require, "zktools.habits")

if not has_habits then
	-- Module not available, skip habits tracker setup
	return
end

-- Create augroup for zk habits
local augroup = vim.api.nvim_create_augroup("ZkHabits", { clear = true })

-- Auto-update habits table on save for weekly/monthly reviews
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	group = augroup,
	pattern = { "*/0.reviews/3.weekly/*.md", "*/0.reviews/2.monthly/*.md" },
	callback = function()
		-- Only update if habits-tracker marker exists
		local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
		for _, line in ipairs(lines) do
			if line:match("<!%-%- habits%-tracker %-%->") then
				habits.update_table_in_buffer()
				-- Save again after update
				vim.cmd("silent! write")
				break
			end
		end
	end,
	desc = "Auto-update habits tracker table on save",
})

-- Auto-update on buffer leave (optional, can be disabled if too aggressive)
vim.api.nvim_create_autocmd({ "BufLeave" }, {
	group = augroup,
	pattern = { "*/0.reviews/3.weekly/*.md", "*/0.reviews/2.monthly/*.md" },
	callback = function()
		local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
		for _, line in ipairs(lines) do
			if line:match("<!%-%- habits%-tracker %-%->") then
				habits.update_table_in_buffer()
				break
			end
		end
	end,
	desc = "Auto-update habits tracker table on buffer leave",
})

-- User commands
vim.api.nvim_buf_create_user_command(0, "ZkHabitsUpdate", function()
	habits.update_table_in_buffer()
end, { desc = "Update habits tracker table" })

vim.api.nvim_buf_create_user_command(0, "ZkHabitsInsert", function()
	habits.insert_marker_and_table()
end, { desc = "Insert habits tracker marker and table" })
