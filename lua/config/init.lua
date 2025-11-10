local M = {}

-- This function is run by lazy as the first plugin, i.e. it can load other plugins if need be.
function M.setup(opts)
	-- HACK: lazy.nvim autoloader doesn't initialize properly without this
	-- TODO: Check the actual reason why this works
	require("lazy.core.cache").find("my.NonExistentMod")

	vim.api.nvim_create_autocmd("User", {
		pattern = "VeryLazy",
		callback = function()
			-- Keymaps are lazily loaded
			require("config.keymaps")

			vim.api.nvim_create_user_command("LazyHealth", function()
				vim.cmd([[Lazy! load all]])
				vim.cmd([[checkhealth]])
			end, { desc = "Load all plugins and run :checkhealth" })
		end,
	})

	local colorscheme = require("config.colorscheme")
	Utils.try(function()
		if type(colorscheme) == "function" then
			colorscheme()
		else
			vim.cmd.colorscheme(colorscheme)
		end
	end, {
		msg = "Could not load your colorscheme",
		on_error = function(msg)
			Utils.error(msg)
			vim.cmd.colorscheme("habamax")
		end,
	})
end

return M
