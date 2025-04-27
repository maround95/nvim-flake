return {
	"xiyaowong/transparent.nvim",
	lazy = false,
	init = function()
		vim.g.transparent_enabled = true
	end,
	opts = {
    extra_groups = {
      "LspInlayHint"
    },
    exclude_groups = {
      "StatusLine"
    }
  },
	keys = {
		{ "<leader>ut", "<cmd>TransparentToggle<cr>", desc = "Transparent toggle" },
	},
}
