local M = {}

local IND = {
  hl = "CornerIndicator",
  buf = nil,
  win = nil,
}

local function ensure_buf()
  if IND.buf and vim.api.nvim_buf_is_valid(IND.buf) then
    return IND.buf
  end

  local buf = vim.api.nvim_create_buf(false, true) -- scratch, unlisted
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "hide" -- do NOT wipe
  vim.bo[buf].swapfile = false

  vim.bo[buf].modifiable = true
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "█" })
  vim.bo[buf].modifiable = false

  IND.buf = buf
  return buf
end

local function hide()
  if IND.win and vim.api.nvim_win_is_valid(IND.win) then
    pcall(vim.api.nvim_win_close, IND.win, true)
  end
  IND.win = nil
end

local function show_at(win, row, col)
  local buf = ensure_buf()
  assert(type(buf) == "number")

  local cfg = {
    relative = "win",
    win = win,
    row = row,
    col = col,
    width = 1,
    height = 1,
    focusable = false,
    style = "minimal",
    noautocmd = true,
    zindex = 200,
  }

  if IND.win and vim.api.nvim_win_is_valid(IND.win) then
    pcall(vim.api.nvim_win_set_config, IND.win, cfg)
    return
  end

  IND.win = vim.api.nvim_open_win(buf, false, cfg)
  vim.wo[IND.win].winhl = "Normal:" .. IND.hl
  vim.wo[IND.win].wrap = false
end

local function indicator()
  local win = vim.api.nvim_get_current_win()
  if not vim.api.nvim_win_is_valid(win) then
    hide()
    return
  end

  local h = vim.api.nvim_win_get_height(win)
  local w = vim.api.nvim_win_get_width(win)
  if h <= 0 or w <= 0 then
    hide()
    return
  end

  -- Hide when cursor is within 1 char of bottom-right screen cell
  if vim.fn.winline() == h and vim.fn.wincol() >= w - 1 then
    hide()
    return
  end

  show_at(win, h - 1, w - 1)
end

function M.setup(opts)
  opts = opts or {}
  IND.hl = opts.hl or IND.hl

  vim.api.nvim_set_hl(0, IND.hl, {
    fg = opts.fg or "#ff0000",
    bold = (opts.bold ~= false),
  })

  -- show immediately
  indicator()

  vim.api.nvim_create_autocmd(
    { "VimEnter", "BufWinEnter", "WinScrolled", "CursorMoved", "CursorMovedI", "WinResized", "WinEnter" },
    { callback = indicator }
  )

  vim.api.nvim_create_autocmd({ "WinClosed" }, {
    callback = function()
      if IND.win and not vim.api.nvim_win_is_valid(IND.win) then
        IND.win = nil
      end
    end,
  })
end

return M
