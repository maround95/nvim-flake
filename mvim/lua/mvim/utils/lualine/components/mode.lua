local mode_abbreviation = {
  COMMAND       = 'C',
  CONFIRM       = '?',
  EX            = 'E',
  FZF           = 'F',
  INSERT        = 'I',
  MORE          = 'M',
  NORMAL        = 'N',
  ["O-PENDING"] = 'O',
  REPLACE       = 'R',
  ["S-BLOCK"]   = 'SB',
  SELECT        = 'S',
  SHELL         = 'SH',
  ["S-LINE"]    = 'SL',
  TERMINAL      = 'T',
  ["V-BLOCK"]   = 'VB',
  VISUAL        = 'V',
  ["V-LINE"]    = 'VL',
  ["V-REPLACE"] = 'VR',
}

return {
  provider = "mode",
  padding = 0,
  separator = "",

  variants = {
    {
      min_cols = 0, -- always
      format = function()
        return " "
      end,
    },
    {
      min_cols = 95,
      format = function(str)
        local abbr = mode_abbreviation[str] or str
        return " " .. abbr .. " "
      end,
    },
    {
      min_cols = 120,
      format = function(str)
        return " " .. str .. " "
      end,
    },
  },
}
