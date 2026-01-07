vim.g.mapleader = " "
vim.g.localleader = " "

vim.opt.laststatus = 0
vim.opt.cmdheight = 0
vim.opt.signcolumn = "no"

-- Wrapping options
vim.opt.wrap = true
vim.opt.smoothscroll = true
vim.opt.scrolloff = 0
vim.opt.scrolljump = 0
vim.opt.showbreak=''
vim.keymap.set({'n', 'v'}, 'j', 'gj')
vim.keymap.set({'n', 'v'}, 'k', 'gk')

vim.opt.clipboard = "unnamedplus"
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false

-- Transparent background
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })

-- Quit without asking to save
vim.keymap.set('n', 'ZZ', ':q!<CR>')
vim.api.nvim_create_user_command("Q", "q!", { bang = true })
vim.api.nvim_create_user_command("Qa", "qa!", { bang = true })
vim.cmd("cabbrev q Q")
vim.cmd("cabbrev qa Qa")

-- Indicate that we're editing scrollback
local ok, corner_indicator = pcall(require, "corner_indicator")
if ok then
  corner_indicator.setup()
end

-- Pressing enter in visual mode yanks to unnamedplus and exits nvim
vim.keymap.set("v", "<CR>", '"+y<cmd>quit!<cr>', { noremap = true })

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    (vim.hl or vim.highlight).on_yank()
  end,
})

-- Cursor on last character of first non-empty line
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    -- Only for the first buf (i.e. one that's passed on the cmdline)
    if vim.api.nvim_get_current_buf() ~= 1 then
      return
    end

    local last = vim.fn.line("$")

    -- walk backwards until you find a non-empty line
    while last > 1 do
      if vim.fn.match(vim.fn.getline(last), [[^[\r\s]*$]]) == -1 then
        break
      end
      last = last - 1
    end

    -- last line
    vim.api.nvim_win_set_cursor(0, { last, 0 })

    -- last char
    vim.api.nvim_win_set_cursor(0, { last, vim.fn.col("$") })
  end,
})

require("mvim.utils.navigation").setup()
