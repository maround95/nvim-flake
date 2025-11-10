vim.uv = vim.uv or vim.loop

-- Setup mock nixCats if we're not using nix.
require("boot.nixCats").setup({
	non_nix_value = true,
})

-- After this, we have lazy in the rtp
local lazy_path = require("boot.lazy").download_lazy()

-- Now we can set up utils
_G.Utils = require("utils")

-- Options and autocmds before setting lazy up
require("config.options")
require("config.autocmds")

-- Setup lazy
require("boot.lazy").setup(lazy_path, {
	spec = {
		{
			dir = nixCats.configDir, -- The "plugin" is part of this repo
			main = "config",
			name = "configPlugin",
			priority = 10000,
			lazy = false,
			opts = {},
			cond = true, -- Like enabled, but doesn't uninstall the plugin when it's disabled
		},
		{
			"folke/snacks.nvim",
			priority = 2000,
			lazy = false,
			opts = {},
			config = function(_, opts)
				local notify = vim.notify
				require("snacks").setup(opts)
				-- HACK: restore vim.notify after snacks setup and let noice.nvim take over
				-- this is needed to have early notifications show up in noice history
				vim.notify = notify
			end,
		},
		{ import = "plugins" },
	},
	performance = {
		rtp = {
			-- disable some rtp plugins
			disabled_plugins = {
				"gzip",
				-- "matchit",
				-- "matchparen",
				"netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})
