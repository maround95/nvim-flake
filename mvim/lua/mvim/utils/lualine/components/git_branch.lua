return {
  provider = "branch",
  icon = "",
  padding = { left = 0, right = 1 },

  variants = {
    {
      min_cols = 0, -- always
      format = function(branch)
        if branch == "" then return "" end
        return "" -- I'm in a git repo
      end,
    },
    {
      min_cols = 50,
      format = function(branch)
        if branch == "" then return "" end
        return branch:sub(1, 4)
      end,
    },
    {
      min_cols = 54,
      format = function(branch)
        if branch == "" then return "" end
        return branch:sub(1, 6)
      end,
    },
    {
      min_cols = 60,
      format = function(branch)
        if branch == "" then return "" end
        return branch:sub(1, 9)
      end,
    },
    {
      min_cols = 64,
      format = function(branch)
        if branch == "" then return "" end
        return branch:sub(1, 10)
      end,
    },
    {
      min_cols = 95,
      format = function(branch)
        if branch == "" then return "" end
        return branch:sub(1, 15)
      end,
    },
    {
      min_cols = 120,
      format = function(branch)
        if branch == "" then return "" end
        return branch:sub(1, 18)
      end,
    },
    {
      min_cols = 150,
      format = function(branch)
        if branch == "" then return "" end
        return " " .. branch
      end,
    },
  },
}
