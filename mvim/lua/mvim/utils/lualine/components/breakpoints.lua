-- Available?
if not Utils.plugin.has("nvim-dap") then return nil end

return {
  -- NOTE: Something like this to refresh lualine?
  --       OTOH doesn't have to show instantly.

  --  local dap = require("dap")
  -- local function refresh()
  --   local ok, lualine = pcall(require, "lualine")
  --   if ok then lualine.refresh() end
  -- end
  --
  -- dap.listeners.after.setBreakpoints["lualine_bp_refresh"] = function()
  --   refresh()
  -- end
  --

  provider = function()
    local breakpoints = require("dap.breakpoints").get()
    local breakpointSum = 0
    for buf, _ in pairs(breakpoints) do
      breakpointSum = breakpointSum + #breakpoints[buf]
    end
    if breakpointSum == 0 then return "" end
    return tostring(breakpointSum)
  end,

  padding = { left = 0, right = 1 },
  color = "Keyword",

  variants = {
    {
      min_cols = 0, -- always
      format = function(bps)
        if bps == "" then return "" end
        return ""
      end,
    },
    {
      min_cols = 65,
      format = function(bps)
        if bps == "" then return "" end
        return " " .. bps
      end,
    },
  },
}
