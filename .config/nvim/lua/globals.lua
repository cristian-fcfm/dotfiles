local utils = require("utils")

-- Detección de sistema operativo
vim.g.is_win = (utils.has("win32") or utils.has("win64")) and true or false
vim.g.is_linux = (utils.has("unix") and (not utils.has("macunix"))) and true or false
vim.g.is_mac = utils.has("macunix") and true or false

-- Desactivar providers innecesarios
vim.g.loaded_perl_provider = 0 -- Desactivar provider de Perl
vim.g.loaded_ruby_provider = 0 -- Desactivar provider de Ruby
vim.g.loaded_node_provider = 0 -- Desactivar provider de Node.js

-- Desactivar netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Desactivar plugins de archivos comprimidos
vim.g.loaded_zipPlugin = 1 -- No editar dentro de archivos ZIP
vim.g.loaded_gzip = 1 -- No editar archivos gzip
vim.g.loaded_tarPlugin = 1 -- No editar archivos tar

-- Desactivar otros plugins builtin innecesarios
vim.g.loaded_2html_plugin = 1 -- No convertir a HTML
vim.g.loaded_tutor_mode_plugin = 1 -- No usar tutor integrado
vim.g.loaded_matchit = 1 -- Usar treesitter o plugins modernos
vim.g.loaded_matchparen = 1 -- Usar mini.pairs o similar
vim.g.loaded_sql_completion = 1 -- SQL omni completion (buggy)
vim.g.did_install_default_menus = 1 -- No cargar menús por defecto
