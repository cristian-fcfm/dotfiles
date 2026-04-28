-- =============================================================================
-- Configuracion Markdown
-- =============================================================================

-- ===========================================================================
-- Render Markdown
-- ===========================================================================
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "zk" },
  once = true,
  callback = function()
    vim.pack.add({
      { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
    })

    require("render-markdown").setup({
      file_types = { "markdown", "zk" },
      code = { sign = false, width = "block", right_pad = 1 },
      heading = { sign = false, icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " } },
      checkbox = {
        enabled = true,
        unchecked = { icon = "󰄱 ", highlight = "RenderMarkdownUnchecked" },
        checked = { icon = "󰄲 ", highlight = "RenderMarkdownChecked" },
        custom = {
          todo = {
            raw = "[-]",
            rendered = "󰅖 ",
            highlight = "RenderMarkdownTodo",
            scope_highlight = "@markup.strikethrough",
          },
          progress = { raw = "[>]", rendered = "󰦕 ", highlight = "RenderMarkdownProgress" },
          important = { raw = "[!]", rendered = "󰀪 ", highlight = "DiagnosticWarn" },
          question = { raw = "[?]", rendered = "󰋗 ", highlight = "RenderMarkdownQuestion" },
          waiting = { raw = "[=]", rendered = "󰥔 ", highlight = "RenderMarkdownWaiting" },
          partial = { raw = "[~]", rendered = "󰄿 ", highlight = "RenderMarkdownPartial" },
        },
      },
    })
  end,
})

-- ===========================================================================
-- Markdown Preview
-- ===========================================================================
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "zk" },
  once = true,
  callback = function()
    vim.pack.add({
      { src = "https://github.com/iamcco/markdown-preview.nvim" },
    })

    vim.g.mkdp_auto_start = 0
    vim.g.mkdp_open_with = ""
  end,
})

vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    if ev.data.spec.name == "markdown-preview.nvim" and ev.data.kind ~= "delete" then
      if not ev.data.active then
        vim.cmd.packadd("markdown-preview.nvim")
      end
      vim.fn.system({
        "sh",
        "-c",
        "cd " .. vim.fn.stdpath("data") .. "/site/pack/core/opt/markdown-preview.nvim/app && npm install",
      })
    end
  end,
})
