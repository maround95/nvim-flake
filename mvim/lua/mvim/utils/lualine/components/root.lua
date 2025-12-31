return {
  provider = function()
    return " "
  end,

  padding = 1,

  variants = {
    {
      min_cols = 0, -- always
      format = function(_)
        return Utils.root({ abbreviate = true })
      end,
    },
    {
      min_cols = 80,
      format = function(_)
        return Utils.root()
      end,
    },
  },
}
