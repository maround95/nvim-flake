return {
  {
    "EdenEast/nightfox.nvim",
    lazy = true,
    opts = {
      options = {
        -- transparent = true,
      },
      groups = {
        all = {
          FloatBorder = { fg = "fg3", bg = "bg0" },
          FloatTitle = { fg = "syntax.func", bg = "bg0" },
          Visual = { bg = "palette.orange.dim" },
        },
      },
    },
  },
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = { style = "moon" },
  },
}
