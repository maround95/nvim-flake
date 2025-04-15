---@param config {type?:string, args?:string[]|fun():string[]?}
local function get_args(config)
  local args = type(config.args) == "function" and (config.args() or {}) or config.args or
  {} --[[@as string[] | string ]]
  local args_str = type(args) == "table" and table.concat(args, " ") or args --[[@as string]]

  config = vim.deepcopy(config)
  ---@cast args string[]
  config.args = function()
    local new_args = vim.fn.expand(vim.fn.input("Run with args: ", args_str)) --[[@as string]]
    if config.type and config.type == "java" then
      ---@diagnostic disable-next-line: return-type-mismatch
      return new_args
    end
    return require("dap.utils").splitstr(new_args)
  end
  return config
end

return {
  {
    "mfussenegger/nvim-dap",
    recommended = true,
    desc = "Debugging support. Requires language specific adapters to be configured. (see lang extras)",

    dependencies = {
      "rcarriga/nvim-dap-ui",
      -- virtual text for the debugger
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {},
      },
    },

    -- stylua: ignore
    keys = {
      {
        "<leader>dB",
        function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end,
        desc = "Breakpoint Condition"
      },
      { "<leader>db", function() require("dap").toggle_breakpoint() end,             desc = "Toggle Breakpoint" },
      { "<leader>dc", function() require("dap").continue() end,                      desc = "Run/Continue" },
      { "<leader>da", function() require("dap").continue({ before = get_args }) end, desc = "Run with Args" },
      { "<leader>dC", function() require("dap").run_to_cursor() end,                 desc = "Run to Cursor" },
      { "<leader>dg", function() require("dap").goto_() end,                         desc = "Go to Line (No Execute)" },
      { "<leader>di", function() require("dap").step_into() end,                     desc = "Step Into" },
      { "<leader>dj", function() require("dap").down() end,                          desc = "Down" },
      { "<leader>dk", function() require("dap").up() end,                            desc = "Up" },
      { "<leader>dl", function() require("dap").run_last() end,                      desc = "Run Last" },
      { "<leader>do", function() require("dap").step_out() end,                      desc = "Step Out" },
      { "<leader>dO", function() require("dap").step_over() end,                     desc = "Step Over" },
      { "<leader>dP", function() require("dap").pause() end,                         desc = "Pause" },
      { "<leader>dr", function() require("dap").repl.toggle() end,                   desc = "Toggle REPL" },
      { "<leader>ds", function() require("dap").session() end,                       desc = "Session" },
      { "<leader>dt", function() require("dap").terminate() end,                     desc = "Terminate" },
      { "<leader>dw", function() require("dap.ui.widgets").hover() end,              desc = "Widgets" },
    },

    config = function()
      -- load mason-nvim-dap here, after all adapters have been setup
      local mason_dap = require("lazy.core.config").spec.plugins["mason-nvim-dap.nvim"]
      if mason_dap then
        local mason_dap_opts = require("lazy.core.plugin").values(mason_dap, "opts", false)
        require("mason-nvim-dap").setup(mason_dap_opts)
      end

      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

      local dap_signs = {
        DapBreakpoint = { text = " ", texthl = "DiagnosticInfo" },
        DapBreakpointCondition = { text = " ", texthl = "DiagnosticInfo" },
        DapBreakpointRejected = { text = " ", texthl = "DiagnosticError" },
        DapLogPoint = { text = ".>", texthl = "DiagnosticInfo" },
        DapStopped = { linehl = "DapStoppedLine", text = "󰁕 ", texthl = "DiagnosticWarn" },
      }
      for name, sign in pairs(dap_signs) do
        vim.fn.sign_define(name, sign)
      end

      -- setup dap config by VsCode launch.json file
      local vscode = require("dap.ext.vscode")
      local json = require("plenary.json")
      vscode.json_decode = function(str)
        return vim.json.decode(json.json_strip_comments(str))
      end
    end,
  },

  -- fancy UI for the debugger
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "nvim-neotest/nvim-nio" },
    -- stylua: ignore
    keys = {
      { "<leader>du", function() require("dapui").toggle({}) end, desc = "Dap UI" },
      { "<leader>de", function() require("dapui").eval() end,     desc = "Eval",  mode = { "n", "v" } },
    },
    opts = {},
    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup(opts)
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({})
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close({})
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close({})
      end
    end,
  },

  -- mason.nvim integration
  {
    "jay-babu/mason-nvim-dap.nvim",
    enabled = require("nixCatsUtils").lazyAdd(true, false),
    dependencies = "mason.nvim",
    cmd = { "DapInstall", "DapUninstall" },
    opts = {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
      },
    },
    -- mason-nvim-dap is loaded when nvim-dap loads
    config = function() end,
  },
}
