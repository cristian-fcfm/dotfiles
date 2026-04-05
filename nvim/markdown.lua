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
          todo = { raw = "[-]", rendered = "󰅖 ", highlight = "RenderMarkdownTodo", scope_highlight = "@markup.strikethrough" },
          progress = { raw = "[>]", rendered = "󰦕 ", highlight = "RenderMarkdownProgress" },
          important = { raw = "[!]", rendered = "󰀪 ", highlight = "DiagnosticWarn" },
          question = { raw = "[?]", rendered = "󰋗 ", highlight = "RenderMarkdownQuestion" },
          waiting = { raw = "[=]", rendered = "󰥔 ", highlight = "RenderMarkdownWaiting" },
          partial = { raw = "[~]", rendered = "󰄿 ", highlight = "RenderMarkdownPartial" },
        },
      },
    })

    vim.pack.add({
      { src = "https://github.com/bullets-vim/bullets.vim" },
    })

    vim.g.bullets_enabled_file_types = { "markdown", "zk", "text" }
    vim.g.bullets_enable_in_empty_buffers = 0
    vim.g.bullets_set_mappings = 1
    vim.g.bullets_checkbox_markers = " .oOx"
    vim.g.bullets_renumber_on_change = 1
    vim.g.bullets_pad_right = 0
    vim.g.bullets_outline_levels = { "ROM", "ABC", "num", "abc", "rom", "std-" }
  end,
})

vim.api.nvim_create_autocmd("PackChanged", { callback = function(ev)
  if ev.data.spec.name == "markdown-preview.nvim" and ev.data.kind ~= "delete" then
    if not ev.data.active then vim.cmd.packadd("markdown-preview.nvim") end
    vim.fn.system({ "sh", "-c", "cd " .. vim.fn.stdpath("data") .. "/site/pack/core/opt/markdown-preview.nvim/app && npm install" })
  end
end })

vim.api.nvim_create_user_command("MarkdownPreview", function()
  vim.pack.add({
    { src = "https://github.com/iamcco/markdown-preview.nvim" },
  })
  vim.fn["mkdp#util#install"]()
  vim.cmd("MarkdownPreview")
end, { desc = "Preview markdown in browser" })

vim.api.nvim_create_user_command("MarkdownPreviewStop", function()
  vim.cmd("MarkdownPreviewStop")
end, { desc = "Stop markdown preview" })
