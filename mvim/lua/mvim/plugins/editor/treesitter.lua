return {
  {
    "nvim-treesitter/nvim-treesitter",

    version = false,
    build = Utils.nixCats.lazyAdd(":TSUpdate"),
    event = { "BufReadPost", "BufNewFile", "BufWritePre", "VeryLazy" },
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    keys = {
      { "<c-space>", desc = "Increment selection" },
      { "<bs>",      desc = "Decrement selection", mode = "x" },
    },
    lazy = vim.fn.argc(-1) == 0,

    opts_extend = Utils.nixCats.lazyAdd({ "ensure_installed" }, nil),
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
      ensure_installed = {
        "bash",
        "c",
        "cmake",
        "cpp",
        "diff",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "jsonc",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "printf",
        "python",
        "query",
        "regex",
        "rust",
        "toml",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
      },
      auto_install = Utils.nixCats.lazyAdd(true, false),
    },
    ---@param opts TSConfig
    config = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        -- nix already ensured they were installed, and we would need to change
        -- the parser_install_dir if we wanted to use it instead.
        -- so we just disable install and do it via nix.
        opts.ensure_installed = Utils.nixCats.lazyAdd(Utils.dedup(opts.ensure_installed), nil)
      end
      require("nvim-treesitter").setup(opts)
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = "VeryLazy",
    enabled = true,
    opts = {
      move = {
        set_jumps = true, -- whether to set jumps in the jumplist
      }
    },
    keys = {
      { "]f", function() require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects") end,      mode = { "n", "x", "o" } },
      { "]F", function() require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects") end,        mode = { "n", "x", "o" } },
      { "[f", function() require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects") end,  mode = { "n", "x", "o" } },
      { "[F", function() require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects") end,    mode = { "n", "x", "o" } },

      { "]c", function() require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects") end,         mode = { "n", "x", "o" } },
      { "]C", function() require("nvim-treesitter-textobjects.move").goto_next_end("@class.outer", "textobjects") end,           mode = { "n", "x", "o" } },
      { "[c", function() require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects") end,     mode = { "n", "x", "o" } },
      { "[C", function() require("nvim-treesitter-textobjects.move").goto_previous_end("@class.outer", "textobjects") end,       mode = { "n", "x", "o" } },

      { "]a", function() require("nvim-treesitter-textobjects.move").goto_next_start("@parameter.outer", "textobjects") end,     mode = { "n", "x", "o" } },
      { "]A", function() require("nvim-treesitter-textobjects.move").goto_next_end("@parameter.outer", "textobjects") end,       mode = { "n", "x", "o" } },
      { "[a", function() require("nvim-treesitter-textobjects.move").goto_previous_start("@parameter.outer",
          "textobjects") end,                                                                                                    mode = { "n", "x", "o" } },
      { "[A", function() require("nvim-treesitter-textobjects.move").goto_previous_end("@parameter.outer", "textobjects") end,   mode = { "n", "x", "o" } },
    },
  },
  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    opts = {},
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    keys = { { "<leader>uc", "<cmd>TSContext toggle<cr>", desc = "Toggle treesitter context" } },
    opts = {
      mode = "cursor",
      max_lines = 3,
    },
    config = function(_, opts)
      require("treesitter-context").setup(opts)
      vim.api.nvim_set_hl(0, "TreesitterContext", { link = "Normal" })
      vim.api.nvim_set_hl(0, "TreesitterContextBottom", { link = "Underlined" })
    end,
  },
}
