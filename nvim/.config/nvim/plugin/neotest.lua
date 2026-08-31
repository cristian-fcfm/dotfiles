-- ============================================================================
-- Neotest: ejecutar y debuggear tests (pytest vía neotest-python)
-- ============================================================================
local loaded = false

local function load_neotest()
  if loaded then
    return
  end
  vim.pack.add({
    { src = "https://github.com/nvim-neotest/neotest" },
    { src = "https://github.com/nvim-neotest/nvim-nio" },
    { src = "https://github.com/nvim-neotest/neotest-python" },
  })

  require("neotest").setup({
    adapters = {
      require("neotest-python")({ dap = { justMyCode = true } }),
    },
  })

  loaded = true
end

local map = vim.keymap.set

map("n", "<leader>rr", function()
  load_neotest()
  require("neotest").run.run()
end, { desc = "Test: ejecutar el más cercano" })

map("n", "<leader>rf", function()
  load_neotest()
  require("neotest").run.run(vim.fn.expand("%"))
end, { desc = "Test: ejecutar archivo" })

map("n", "<leader>rd", function()
  load_neotest()
  -- La estrategia dap de neotest necesita nvim-dap cargado y configurado
  if vim.g.ensure_dap then
    vim.g.ensure_dap()
  end
  require("neotest").run.run({ strategy = "dap" })
end, { desc = "Test: debuggear el más cercano" })

map("n", "<leader>rs", function()
  load_neotest()
  require("neotest").summary.toggle()
end, { desc = "Test: panel resumen" })

map("n", "<leader>ro", function()
  load_neotest()
  require("neotest").output.open({ enter = true })
end, { desc = "Test: salida del test" })
