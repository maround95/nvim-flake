return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = { ensure_installed = { "nix" } },
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				nixd = {
					settings = {
						nixd = {
							formatting = {
								command = { "nixfmt" },
							},
						},
					},
				},
			},
		},
	},
	{
		"nvimtools/none-ls.nvim",
		optional = true,
		opts = {
			sources = {
				require("null-ls").builtins.diagnostics.deadnix,
				require("null-ls").builtins.diagnostics.statix,
				require("null-ls").builtins.code_actions.statix,
			},
		},
	},
	{
		"stevearc/conform.nvim",
		optional = true,
		opts = {
			formatters_by_ft = {
				nix = { "nixfmt" },
			},
		},
	},
	{
		"mfussenegger/nvim-lint",
		optional = true,
		opts = {
			linters_by_ft = {
				nix = { "statix" },
			},
		},
	},
}
