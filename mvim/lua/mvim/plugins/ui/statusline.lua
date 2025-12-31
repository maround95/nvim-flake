return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    init = function()
      vim.g.lualine_laststatus = vim.o.laststatus
      if vim.fn.argc(-1) > 0 then
        -- set an empty statusline till lualine loads
        vim.o.statusline = " "
      else
        -- hide the statusline on the starter page
        vim.o.laststatus = 0
      end
    end,
    opts = function()
      -- PERF: we don't need this lualine require madness 🤷
      local lualine_require = require("lualine_require")
      lualine_require.require = require

      local u = Utils.lualine

      vim.o.laststatus = vim.g.lualine_laststatus

      local opts = {
        options = {
          theme = "auto",
          globalstatus = vim.o.laststatus == 3,
          disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
          component_separators = {},
          section_separators = {},
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
            refresh_time = 16, -- ~60fps
            events = {
              'WinEnter',
              'BufEnter',
              'BufWritePost',
              'SessionLoadPost',
              'FileChangedShellPost',
              'VimResized',
              'Filetype',
              'CursorMoved',
              'CursorMovedI',
              'ModeChanged',
              'RecordingEnter',
              'RecordingLeave',
            },
          },
        },
        extensions = { "neo-tree", "lazy", "fzf" },

        sections = {

          lualine_a = u.make_section({
            u.component_mode
          }),
          lualine_b = u.make_section({
            u.component_root,
          }),
          lualine_c = u.make_section({
            u.component_workspace_errors,
            u.component_recording,
          }),

          lualine_x = u.make_section({
            u.component_breakpoints,
          }),
          lualine_y = u.make_section({
            u.component_git_branch,
            u.component_diff,
          }),
          lualine_z = u.make_section({
            u.component_clock
          }),
        },
      }

      if Utils.plugin.has("transparent.nvim") then
        local transparent = require("transparent")
        transparent.clear_prefix("lualine_c")
        transparent.clear_prefix("lualine_x")
      end

      return opts
    end,
  },
}
