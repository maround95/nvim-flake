return {
	{
		"folke/snacks.nvim",
		---@type snacks.Config
		opts = {
			dashboard = {
				preset = {
					keys = {
						{ icon = " ", key = "n", desc = "New File", action = ":ene" },
						{ icon = " ", key = "s", desc = "Restore Session", section = "session" },
						{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
					},
				},
        -- stylua: ignore
				sections = {
					{ section = "header" },
					{ section = "keys", padding = 1 },
					{ icon = " ", title = "Recent Files", section = "recent_files", limit = 8, indent = 2, padding = 1, },
					{ icon = " ", title = "Projects", section = "projects", limit = 6, indent = 2, padding = 1 },
					{ section = "startup" },
				},
			},
		},
	},
}
