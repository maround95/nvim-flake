return {
	{
		"mikavilpas/yazi.nvim",
		event = "VeryLazy",
    -- stylua: ignore
		keys = {
			{ "<leader>E", mode = { "n", "v" }, "<cmd>Yazi<cr>", desc = "Open yazi at the current file", },
				-- Open in the current working directory
			{ "<leader>fy", "<cmd>Yazi cwd<cr>", desc = "Open the file manager in nvim's working directory", },
			{ "<leader>e", "<cmd>Yazi toggle<cr>", desc = "Resume last yazi session", },
		},
		---@type YaziConfig
		opts = {
			keymaps = {
				open_file_in_horizontal_split = "<c-h>",
				change_working_directory = "<c-d>",
			},
		},
	},
}
