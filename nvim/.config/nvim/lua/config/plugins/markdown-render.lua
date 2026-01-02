return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  ft = { "markdown", "zk" },
  opts = {
    file_types = { "markdown", "zk" },
    code = {
      sign = false,
      width = "block",
      right_pad = 1,
    },
    heading = {
      sign = false,
      icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
    },
    checkbox = {
      enabled = true,
      unchecked = {
        icon = "󰄱 ",
        highlight = "RenderMarkdownUnchecked",
      },
      checked = {
        icon = "󰄲 ",
        highlight = "RenderMarkdownChecked",
      },
      custom = {
        -- Cancelado/Rechazado
        todo = {
          raw = "[-]",
          rendered = "󰅖 ",
          highlight = "RenderMarkdownTodo",
          scope_highlight = "@markup.strikethrough",
        },
        -- En progreso
        progress = {
          raw = "[>]",
          rendered = "󰦕 ",
          highlight = "RenderMarkdownProgress",
        },
        -- Importante/Urgente
        important = {
          raw = "[!]",
          rendered = "󰀪 ",
          highlight = "DiagnosticWarn",
        },
        -- Pregunta/Necesita información
        question = {
          raw = "[?]",
          rendered = "󰋗 ",
          highlight = "RenderMarkdownQuestion",
        },
        -- En espera/Bloqueado
        waiting = {
          raw = "[=]",
          rendered = "󰥔 ",
          highlight = "RenderMarkdownWaiting",
        },
        -- Parcialmente completado
        partial = {
          raw = "[~]",
          rendered = "󰄿 ",
          highlight = "RenderMarkdownPartial",
        },
      },
    },
  },
}
