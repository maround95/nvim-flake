local M = {}

local function columns()
  return vim.o.columns
end

local function make_responsive(opts)
  local variants = opts.variants or {}

  local c = {
    opts.provider,

    -- Should this component show at all?
    cond = function()
      local cols = columns()
      for _, v in ipairs(variants) do
        local min_cols = v.min_cols or 0
        if cols >= min_cols then
          return true
        end
      end
      return false
    end,

    -- Choose best variant for current width
    fmt = function(str)
      local cols = columns()
      local best_variant = nil
      local best_cols = -1

      for _, v in ipairs(variants) do
        local min_cols = v.min_cols or 0
        if cols >= min_cols and min_cols > best_cols and v.format then
          best_variant = v
          best_cols = min_cols
        end
      end

      if best_variant then
        return best_variant.format(str, cols) or ""
      end

      return str
    end,
  }

  -- copy these keys from opts if present
  local passthrough = {
    "padding",
    "separator",
    "color",
    "on_click",
    "source",
    "symbols",
    "icon",
  }
  for _, key in ipairs(passthrough) do
    if opts[key] ~= nil then
      c[key] = opts[key]
    end
  end

  return c
end

local make_component = function(name)
  local component = require("mvim.utils.lualine.components." .. name)
  if component == nil then return nil end -- Unavailable, see trouble component
  return make_responsive(component)
end

M.component_mode = make_component("mode")
M.component_git_branch = make_component("git_branch")
M.component_diff = make_component("diff")
M.component_recording = make_component("recording")
M.component_breakpoints = make_component("breakpoints")
M.component_clock = make_component("clock")
M.component_root = make_component("root")
M.component_workspace_errors = make_component("workspace_errors")

-- Wrapper to apply any needed behavior for a section
M.make_section = function(components)
  local out = {}

  -- Filter nil components, can happen if component is not enabled.
  for _, component in ipairs(components) do
    if component ~= nil then
      out[#out + 1] = component
    end
  end

  return out
end

return M
