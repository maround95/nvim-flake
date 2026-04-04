local plugin = require("mvim.utils.plugin")

local M = {}

local provider

local function get_provider()
  if provider then
    return provider
  end

  if plugin.has("harpoon2") then
    provider = require("mvim.utils.pins.harpoon")
  else
    vim.schedule(function()
      vim.notify("harpoon2 is not available", vim.log.levels.WARN)
    end)
    provider = require("mvim.utils.pins.stub")
  end

  return provider
end

function M.is_pinned(bufnr)
  return get_provider().is_pinned(bufnr)
end

function M.toggle(bufnr)
  return get_provider().toggle(bufnr)
end

function M.unpin_all()
  return get_provider().unpin_all()
end

function M.unpin_others(bufnr)
  return get_provider().unpin_others(bufnr)
end

function M.unpinned_bufs()
  return get_provider().unpinned_bufs()
end

function M.sorter()
  return get_provider().sorter()
end

return M
