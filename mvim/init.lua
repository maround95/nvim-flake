vim.uv = vim.uv or vim.loop

-- Setup mock nixCats if we're not using nix.
require("mvim.boot.nixCats").setup({
  non_nix_value = false,
})

-- After this, we have lazy in the rtp
local lazy_path = require("mvim.boot.lazy").download_lazy()

-- Now we can set up utils
_G.Utils = require("mvim.utils")

-- Options and autocmds before setting lazy up
require("mvim.config.options")
require("mvim.config.autocmds")
require("mvim.config.filetypes")

-- Setup lazy
require("mvim.boot.lazy").setup(lazy_path, {
  spec = {
    {
      dir = nixCats.configDir, -- The "plugin" is part of this repo
      main = "mvim.config",
      name = "configPlugin",
      priority = 10000,
      lazy = false,
      opts = {},
      cond = true, -- Like enabled, but doesn't uninstall the plugin when it's disabled
    },
    {
      "folke/snacks.nvim",
      priority = 2000,
      lazy = false,
      opts = {},
      config = function(_, opts)
        local notify = vim.notify
        require("snacks").setup(opts)
        -- HACK: restore vim.notify after snacks setup and let noice.nvim take over
        -- this is needed to have early notifications show up in noice history
        if Utils.plugin.has("noice.nvim") then
          vim.notify = notify
        end
      end,
    },
    { import = "mvim.plugins" },
  },
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
