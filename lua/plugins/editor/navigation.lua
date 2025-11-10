return {
	{
		"swaits/zellij-nav.nvim",
		cond = vim.env.ZELLIJ ~= nil,
		lazy = false,
		init = function()
			vim.g.zellij_nav_default_mappings = false -- Default: true
		end,
		opts = {},
    -- stylua: ignore
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
}
