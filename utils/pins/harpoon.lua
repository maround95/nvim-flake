local M = {}

local function current_path(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  if name == "" then
    return nil
  end
  return vim.fn.fnamemodify(name, ":.")
end

local function refresh_bufferline()
  vim.schedule(function()
    vim.cmd("redrawtabline")
  end)
end

local ok, harpoon = pcall(require, "harpoon")
if not ok then
  return require("mvim.utils.pins.stub")
end

local list = harpoon:list()
if type(list) ~= "table" then
  return require("mvim.utils.pins.stub")
end

if type(list.display) ~= "function" then
  return require("mvim.utils.pins.stub")
end

if type(list.add) ~= "function" then
  return require("mvim.utils.pins.stub")
end

if type(list.clear) ~= "function" then
  return require("mvim.utils.pins.stub")
end

if type(list.remove_at) ~= "function" then
  return require("mvim.utils.pins.stub")
end

local function get_list()
  return harpoon:list()
end

local function index_for_buf(bufnr)
  local path = current_path(bufnr)
  if not path then
    return nil
  end

  for i, mark in ipairs(get_list():display()) do
    if mark == path then
      return i
    end
  end

  return nil
end

function M.is_pinned(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  return index_for_buf(bufnr) ~= nil
end

function M.toggle(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  local idx = index_for_buf(bufnr)
  if idx then
    get_list():remove_at(idx)
  else
    get_list():add()
  end

  refresh_bufferline()
end

function M.unpin_all()
  get_list():clear()
  refresh_bufferline()
end

function M.unpin_others(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local was_pinned = M.is_pinned(bufnr)

  get_list():clear()

  if was_pinned then
    get_list():add()
  end

  refresh_bufferline()
end

function M.unpinned_bufs()
  local pinned = {}
  for _, mark in ipairs(get_list():display()) do
    pinned[mark] = true
  end

  local bufs = {}
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buflisted then
      local path = current_path(bufnr)
      if path and not pinned[path] then
        table.insert(bufs, bufnr)
      end
    end
  end

  return bufs
end

function M.sorter()
  local cache = {}
  local setup = false

  local function marknum(buf, force)
    local b = cache[buf.number]

    if b == nil or force then
      b = false

      -- NOTE: Original recipe did this with plenary, there might be differences vs vim.fn.fnamemodify(buf.path, ":.")
      -- local path = require("plenary.path"):new(buf.path):make_relative(vim.uv.cwd())
      local path = vim.fn.fnamemodify(buf.path, ":.")

      for i, mark in ipairs(get_list():display()) do
        if mark == path then
          b = i
          break
        end
      end
      cache[buf.number] = b
    end

    return b or nil
  end

  return function(a, b)
    if not setup then
      local refresh = function()
        cache = {}
        -- refresh_bufferline() -- TODO: maybe?
      end

      harpoon:extend({
        ADD = refresh,
        REMOVE = refresh,
        REORDER = refresh,
        LIST_CHANGE = refresh,
      })

      setup = true
    end

    local ma = marknum(a)
    local mb = marknum(b)

    if ma and not mb then
      return true
    elseif mb and not ma then
      return false
    elseif ma == nil and mb == nil then
      ma = a._valid_index
      mb = b._valid_index
    end

    return ma < mb
  end
end

return M
