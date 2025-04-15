return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "bibtex", "latex" } },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        texlab = {
          settings = {
          },
        },
      },
    },
  },
}
