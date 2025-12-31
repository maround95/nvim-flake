return {
  provider = function()
    return os.date("%R")
  end,

  variants = {
    {
      min_cols = 110,
      format = function(time)
        return " " .. time
      end,
    },
  },
}
