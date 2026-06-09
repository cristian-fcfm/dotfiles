-- =============================================================================
-- DAP: Debug Adapter Protocol (Python)
-- =============================================================================
vim.pack.add({
  { src = "https://github.com/mfussenegger/nvim-dap", opt = true },
  { src = "https://github.com/mfussenegger/nvim-dap-python", opt = true },
  { src = "https://github.com/nvim-neotest/nvim-nio", opt = true },
  { src = "https://github.com/rcarriga/nvim-dap-ui", opt = true },
  { src = "https://github.com/theHamsta/nvim-dap-virtual-text", opt = true },
})

local function setup_dap()
  vim.cmd.packadd("nvim-dap")
  vim.cmd.packadd("nvim-dap-python")
  vim.cmd.packadd("nvim-nio")
  vim.cmd.packadd("nvim-dap-ui")
  vim.cmd.packadd("nvim-dap-virtual-text")

  local dap = require("dap")
  local dapui = require("dapui")
  local dap_python = require("dap-python")

  -- Usa el python del venv del proyecto si existe, sino el del sistema
  local python_path = vim.fn.getcwd() .. "/.venv/bin/python"
  if vim.fn.executable(python_path) == 0 then
    python_path = "python3"
  end

  dap_python.setup(python_path)

  -- Configuraciones para APIs (FastAPI + LangGraph)
  dap.configurations.python = {
    {
      type = "python",
      request = "launch",
      name = "FastAPI debug (my code)",
      module = "uvicorn",
      args = { "app.main:app", "--port", "8000", "--host", "127.0.0.1", "--workers", "1" },
      console = "integratedTerminal",
      env = { PYTHONUNBUFFERED = "1" },
      justMyCode = true,
    },
    {
      type = "python",
      request = "launch",
      name = "FastAPI debug (deep)",
      module = "uvicorn",
      args = { "app.main:app", "--port", "8000", "--host", "127.0.0.1", "--workers", "1" },
      console = "integratedTerminal",
      env = { PYTHONUNBUFFERED = "1" },
      justMyCode = false,
    },
    {
      type = "python",
      request = "launch",
      name = "Launch current file",
      program = "${file}",
      console = "integratedTerminal",
      justMyCode = true,
    },
  }

  -- DAP Virtual Text
  require("nvim-dap-virtual-text").setup()

  -- DAP UI
  dapui.setup()
  dap.listeners.after.event_initialized["dapui"] = function() dapui.open() end
  dap.listeners.before.event_terminated["dapui"] = function() dapui.close() end
  dap.listeners.before.event_exited["dapui"] = function() dapui.close() end
end

-- Keymaps (carga lazy al primer uso)
local loaded = false
local function ensure_loaded()
  if not loaded then
    setup_dap()
    loaded = true
  end
end

local map = vim.keymap.set
map("n", "<leader>db", function() ensure_loaded(); require("dap").toggle_breakpoint() end, { desc = "DAP: Toggle breakpoint" })
map("n", "<leader>dB", function() ensure_loaded(); require("dap").set_breakpoint(vim.fn.input("Condition: ")) end, { desc = "DAP: Conditional breakpoint" })
map("n", "<leader>dc", function() ensure_loaded(); require("dap").continue() end, { desc = "DAP: Continue" })
map("n", "<leader>do", function() ensure_loaded(); require("dap").step_over() end, { desc = "DAP: Step over" })
map("n", "<leader>di", function() ensure_loaded(); require("dap").step_into() end, { desc = "DAP: Step into" })
map("n", "<leader>dO", function() ensure_loaded(); require("dap").step_out() end, { desc = "DAP: Step out" })
map("n", "<leader>dr", function() ensure_loaded(); require("dap").repl.open() end, { desc = "DAP: REPL" })
map("n", "<leader>du", function() ensure_loaded(); require("dapui").toggle() end, { desc = "DAP: Toggle UI" })
map("n", "<leader>dx", function() ensure_loaded(); require("dap").terminate() end, { desc = "DAP: Terminate" })
