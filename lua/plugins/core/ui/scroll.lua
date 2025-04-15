return {
  {
    "folke/snacks.nvim",
    opts = {
      scroll = {
        enabled = not vim.g.neovide,
        animate = {
          duration = { step = 15, total = 150 },
          easing = "linear",
        },
        -- faster animation when repeating scroll after delay
        animate_repeat = {
          delay = 50, -- delay in ms before using the repeat animation
          duration = { step = 5, total = 50 },
          easing = "linear",
        },
      },
    },
  },
}
