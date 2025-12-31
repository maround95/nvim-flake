local function diff_source()
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed,
    }
  end
end

--symbols = {
--  added = " ",
--  modified = " ",
--  removed = " ",
--},

return {
  provider = "diff",
  source = diff_source,
  padding = { left = 0, right = 1 },

  variants = {
    {
      min_cols = 65,
      format = function(str)
        if not str or str == "" then return "" end
        local d = diff_source()
        if not d then return "" end

        local total = (d.added or 0) + (d.modified or 0) + (d.removed or 0)
        if total == 0 then return "" end
        return "±" .. total
      end,
    },
    {
      min_cols = 80,
      format = function(str)
        return str or ""
      end,
    },
  },
}
