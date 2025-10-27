return {
  "akinsho/git-conflict.nvim",
  version = "*",
  event = { "User InGitRepo" },
  config = function()
    require("git-conflict").setup({
      default_mappings = false, -- Desactivar mappings por defecto, usamos los nuestros
      default_commands = true, -- Habilitar comandos por defecto
      disable_diagnostics = false, -- Mostrar diagnósticos en conflictos
      list_opener = "copen", -- Comando para abrir quickfix list
      highlights = {
        incoming = "DiffAdd",
        current = "DiffText",
        ancestor = "DiffChange",
      },
    })
  end,
}
