return {
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      options = {
        -- transparent = true,
      },
      groups = {
        all = {
          FloatBorder = { fg = "fg3", bg = "bg0" },
          FloatTitle = { fg = "syntax.func", bg = "bg0" },
        },
      },
    },
    config = function(_, opts)
      require("nightfox").setup(opts)
      vim.cmd.colorscheme("nightfox")
    end,
  },
}
