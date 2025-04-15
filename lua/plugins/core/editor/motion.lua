return {
  -- {
  --   "swaits/zellij-nav.nvim",
  --   enabled = vim.env.ZELLIJ ~= nil,
  --   -- lazy = false,
  --   init = function()
  --     vim.g.zellij_nav_default_mappings = false -- Disable default mappings
  --   end,
  --   opts = {},
  --   keys = {
  --     { "<m-h>", "<cmd>ZellijNavigateLeftTab<cr>" },
  --     { "<m-j>", "<cmd>ZellijNavigateDown<cr>" },
  --     { "<m-k>", "<cmd>ZellijNavigateUp<cr>" },
  --     { "<m-l>", "<cmd>ZellijNavigateRightTab<cr>" },
  --   },
  -- },
-- {
--   "swaits/zellij-nav.nvim",
--   lazy = true,
--   event = "VeryLazy",
--   keys = {
--     { "<M-h>", "<cmd>ZellijNavigateLeftTab<cr>",  { silent = true, desc = "navigate left or tab"  } },
--     { "<M-j>", "<cmd>ZellijNavigateDown<cr>",  { silent = true, desc = "navigate down"  } },
--     { "<M-k>", "<cmd>ZellijNavigateUp<cr>",    { silent = true, desc = "navigate up"    } },
--     { "<M-l>", "<cmd>ZellijNavigateRightTab<cr>", { silent = true, desc = "navigate right or tab" } },
--   },
--   opts = {},
-- },
  {
    "swaits/zellij-nav.nvim",
    cond = vim.env.ZELLIJ ~= nil,
    lazy = false,
    init = function()
      vim.g.zellij_nav_default_mappings = false -- Default: true
    end,
    opts = {},
    config = function(_, opts)
      local nav = require('zellij-nav')
      nav.setup(opts)

      vim.keymap.set({'n', 'v', 'c'}, "<m-h>", function() nav.left_tab() end, {silent=true, desc="Zellij navigate left"})
      vim.keymap.set({'n', 'v', 'c'}, "<m-j>", function() nav.down() end, {silent=true, desc="Zellij navigate down"})
      vim.keymap.set({'n', 'v', 'c'}, "<m-k>", function() nav.up() end, {silent=true, desc="Zellij navigate up"})
      vim.keymap.set({'n', 'v', 'c'}, "<m-l>", function() nav.right_tab() end, {silent=true, desc="Zellij navigate right"})
    end,
  },
  {
    "christoomey/vim-tmux-navigator",
    enabled = vim.env.TMUX ~= nil,
    init = function()
      vim.g.tmux_navigator_no_mappings = 1 -- Disable default mappings
    end,
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<m-h>", "<cmd>TmuxNavigateLeft<cr>" },
      { "<m-j>", "<cmd>TmuxNavigateDown<cr>" },
      { "<m-k>", "<cmd>TmuxNavigateUp<cr>" },
      { "<m-l>", "<cmd>TmuxNavigateRight<cr>" },
    },
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    vscode = true,
    opts = {
      ---@type table<string, Flash.Config>
      modes = {
        char = {
          keys = { "f", "F", "t", "T" },
        },
      },
    },
    -- stylua: ignore
    keys = {
      { "gs",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
      { "S",     mode = { "n", "o", "x" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
      { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
      { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
    },
  },
}
