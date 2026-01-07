return {
  provider = function()
    return vim.fn.reg_recording()
  end,

  padding = { left = 1, right = 0 },

  variants = {
    {
      min_cols = 0, -- always
      format = function(reg)
        if reg == "" then return "" end
        return "●"
      end,
    },
    {
      min_cols = 90,
      format = function(reg)
        if reg == "" then return "" end
        return "●" .. reg
      end,
    },
  },
}
