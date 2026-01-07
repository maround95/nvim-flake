local M = {}

local function in_tmux()
  return vim.env.TMUX ~= nil and vim.env.TMUX ~= ""
end

local function try_wincmd(dir)
  local before = vim.api.nvim_get_current_win()
  vim.cmd("wincmd " .. dir)
  return vim.api.nvim_get_current_win() ~= before
end

-- Cache for tmux navigation commands
local nav_cache = {}

local function get_tmux_nav_cmd(opt_name)
  if nav_cache[opt_name] then
    return nav_cache[opt_name]
  end

  -- Resolve the tmux option to get the actual command path
  local result = vim.fn.system({ "tmux", "display-message", "-p", "-F", "#{" .. opt_name .. "}" })
  local cmd = vim.trim(result)

  -- Cache it if we got a valid result
  if vim.v.shell_error == 0 and cmd ~= "" then
    nav_cache[opt_name] = cmd
    return cmd
  end

  return nil
end

local function tmux_run_nav(opt_name)
  local cmd = get_tmux_nav_cmd(opt_name)
  print(cmd)
  if cmd then
    vim.fn.system({ "tmux", "run-shell", "-b", cmd })
  end
end

-- Optional: clear cache if tmux config reloaded
local function clear_cache()
  nav_cache = {}
end

function M.nav(dir, tmux_opt)
  print("Nav!")
  if try_wincmd(dir) then return end
  print("tmux?")
  if in_tmux() then tmux_run_nav(tmux_opt) end
end

function M.setup()
  print("Hello!")
  vim.keymap.set("n", "<M-h>", function() M.nav("h", "@nav_left") end, { silent = true })
  vim.keymap.set("n", "<M-j>", function() M.nav("j", "@nav_down") end, { silent = true })
  vim.keymap.set("n", "<M-k>", function() M.nav("k", "@nav_up") end, { silent = true })
  vim.keymap.set("n", "<M-l>", function() M.nav("l", "@nav_right") end, { silent = true })

  -- Optional: provide a command to refresh cache
  vim.api.nvim_create_user_command("TmuxNavClearCache", clear_cache, {})
end

return M
