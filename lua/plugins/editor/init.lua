return {
	-- Snacks utils
	{
		"snacks.nvim",
		opts = {
			bigfile = { enabled = true },
			quickfile = { enabled = true },
		},
    -- stylua: ignore
    keys = {
      { "<leader>.",  function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
      { "<leader>S",  function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
      { "<leader>dps", function() Snacks.profiler.scratch() end, desc = "Profiler Scratch Buffer" },
    },
	},

	-- library used by other plugins
	{ "nvim-lua/plenary.nvim", lazy = true },
}
