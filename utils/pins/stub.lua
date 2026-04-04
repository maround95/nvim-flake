local M = {}

function M.is_pinned()
  return false
end

function M.toggle() end

function M.unpin_all() end

function M.unpin_others() end

function M.unpinned_bufs()
  return {}
end

function M.sorter()
  return function(a, b)
    return a._valid_index < b._valid_index
  end
end

return M
