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
