local zjinfo_columns = function()
  local zellijCols = vim.fn.system('zellij pipe "zjinfo::window_width::"')
  zellijCols = vim.trim(zellijCols)
  return zellijCols:match('^%d+$') and tonumber(zellijCols) or nil
end

return {
  {
    "willothy/nvim-cokeline",
    enabled = true,
    event = "VeryLazy",
    keys = {
      { "<s-h>", "<Plug>(cokeline-focus-prev)",  desc = "Prev buffer" },
      { "<s-l>", "<Plug>(cokeline-focus-next)",  desc = "Next buffer" },
      { "[b",    "<Plug>(cokeline-focus-prev)",  desc = "Prev buffer" },
      { "]b",    "<Plug>(cokeline-focus-next)",  desc = "Next buffer" },
      { "[B",    "<Plug>(cokeline-switch-prev)", desc = "Move buffer prev" },
      { "]B",    "<Plug>(cokeline-switch-next)", desc = "Move buffer next" },
    },
    opts = function()
      local hlgroups = require("cokeline.hlgroups")
      local get_hex = hlgroups.get_hl_attr
      local num_tabs = function() return #vim.api.nvim_list_tabpages() end
      return {
        show_if_buffers_are_at_least = 1,

        buffers = {
          delete_on_right_click = false,
        },

        mappings = {
          cycle_prev_next = true,
          disable_mouse = true,
        },

        default_hl = {
          fg = function(buffer)
            if buffer.diagnostics and buffer.diagnostics.errors > 0 then
              return
                  get_hex("DiagnosticError", "fg")
                  or get_hex("LspDiagnosticsDefaultError", "fg") -- older names
                  or get_hex("ErrorMsg", "fg")
                  or "#ff0000"
            end

            return buffer.is_focused
                and get_hex("Normal", "fg")
                or get_hex("Comment", "fg")
          end,

          bg = function(_)
            return get_hex("TabLineFill", "bg")
          end,
        },

        components = {
          {
            text = function(_)
              return " "
            end,
          },
          {
            text = function(buffer)
              return buffer.is_focused and buffer.devicon.icon or ""
            end,
            fg = function(buffer)
              return buffer.is_focused and buffer.devicon.color
            end,
          },
          {
            text = function(buffer)
              return buffer.is_modified and "● " or ""
            end,
            fg = function(_)
              return get_hex("diffAdded", "fg")
            end,
          },
          {
            text = function(buffer)
              return buffer.unique_prefix .. buffer.filename .. " "
            end,
            bold = function(buffer)
              return buffer.is_focused
            end,
          },
          {
            text = function(_)
              return " "
            end,
          },
        },

        tabs = {
          placement = "left",
          components = {
            {
              text = function(tab)
                if num_tabs() <= 1 then
                  return ""
                end
                return not tab.is_first and " | " or ""
              end,
              fg = function(_)
                return get_hex("Comment", "fg")
              end,
            },
            {
              text = function(tab)
                if num_tabs() <= 1 then
                  return ""
                end
                return tostring(tab.number)
              end,
              fg = function(tab)
                return tab.is_active
                    and get_hex("Normal", "fg")
                    or get_hex("Comment", "fg")
              end,
            },
          },
        }
      }
    end,
    config = function(_, opts)
      require("cokeline").setup(opts)
      if Utils.plugin.has("transparent.nvim") then
        local transparent = require("transparent")
        transparent.clear_prefix("TabLineFill")
      end
    end
  },
  {
    "maround95/vim-tpipeline-zellij",
    branch = "zellij",
    cond = nixCats("zellijVimBridge") and vim.env.ZELLIJ_SESSION_NAME and zjinfo_columns(),
    lazy = false,
    init = function(_)
      local embed_cmd = nixCats("zellijVimBridge")
      vim.g.tpipeline_autoembed = 0
      -- vim.g.tpipeline_tabline = 1
      -- vim.g.tpipeline_statusline = "%!v:lua.nvim_bufferline()"
      vim.g.tpipeline_statusline = " "
      vim.g.tpipeline_split = 0
      vim.g.tpipeline_restore = 1
      vim.g.tpipeline_cursormoved = 1
      Utils.on_very_lazy(function()
        vim.g.tpipeline_statusline = "%!v:lua.cokeline.tabline()"
      end)

      -- Define how tpipeline gets the width
      vim.api.nvim_create_autocmd("User", {
        pattern = "TpipelineSize",
        callback = function()
          vim.g.tpipeline_size = zjinfo_columns()
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "TpipelineJobForked",
        callback = function()
          vim.system({ embed_cmd })
        end,
      })
    end

  },
}
