return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    name = "harpoon2",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    event = "VeryLazy",
    opts = {
      settings = {
        save_on_toggle = true,
        sync_on_ui_close = true,
      },
    },
    keys = {
      { "<leader>hh", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, desc = "Harpoon menu" },
      { "<leader>1",  function() require("harpoon"):list():select(1) end },
      { "<leader>2",  function() require("harpoon"):list():select(2) end },
      { "<leader>3",  function() require("harpoon"):list():select(3) end },
      { "<leader>4",  function() require("harpoon"):list():select(4) end },
      { "<leader>5",  function() require("harpoon"):list():select(5) end },
    },
    config = function(_, opts)
      require("harpoon"):setup(opts)
    end,
  },
}
