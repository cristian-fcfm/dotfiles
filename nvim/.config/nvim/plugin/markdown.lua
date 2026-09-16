-- ============================================================================
-- Configuracion Markdown
-- ============================================================================

-- ============================================================================
-- Markdown Plugins (render-markdown + markdown-preview)
-- ============================================================================
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "zk" },
  once = true,
  callback = function()
    vim.pack.add({
      { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
      { src = "https://github.com/iamcco/markdown-preview.nvim" },
      { src = "https://github.com/zk-org/zk-nvim" },
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

    vim.g.mkdp_auto_start = 0
    vim.g.mkdp_browser = "firefox"

    -- Comandos y pickers del vault zk. Su LSP no se adjunta a los buffers:
    -- markdown-oxide es el unico LSP de markdown y `zk lsp` arranca on-demand
    -- solo cuando un comando lo necesita.
    require("zk").setup({
      picker = "snacks_picker",
      lsp = { auto_attach = { enabled = false } },
    })

    local function setup_zk_keymaps(bufnr)
      local ok, zk_util = pcall(require, "zk.util")
      if not ok or not zk_util.notebook_root(vim.api.nvim_buf_get_name(bufnr)) then
        return
      end
      local map = function(keys, rhs, desc)
        vim.keymap.set("n", keys, rhs, { buffer = bufnr, desc = desc })
      end
      map("<leader>zn", "<cmd>ZkNew { title = vim.fn.input('Title: ') }<cr>", "Zk: nueva nota")
      map("<leader>zo", "<cmd>ZkNotes { sort = { 'modified' } }<cr>", "Zk: abrir notas")
      map("<leader>zb", "<cmd>ZkBacklinks<cr>", "Zk: backlinks de esta nota")
      map("<leader>zl", "<cmd>ZkLinks<cr>", "Zk: notas enlazadas")
      vim.keymap.set(
        "v",
        "<leader>znt",
        ":ZkNewFromTitleSelection { dir = vim.fn.expand('%:p:h') }<cr>",
        { buffer = bufnr, desc = "Zk: nota nueva desde el título seleccionado" }
      )
    end

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("zk_keymaps", { clear = true }),
      pattern = "markdown",
      desc = "Keymaps del vault zk en buffers markdown",
      callback = function(ev)
        setup_zk_keymaps(ev.buf)
      end,
    })
    setup_zk_keymaps(0)
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
