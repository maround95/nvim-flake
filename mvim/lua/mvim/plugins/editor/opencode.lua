return {
  'sudo-tee/opencode.nvim',
  name = "opencode-nvim",
  -- enabled = function() return vim.fn.executable("opencode") == 1 end,
  enabled = false,
  dependencies = {
    -- Optional: choose a picker you already use, or keep vim.ui.select.
    -- 'folke/snacks.nvim',
    -- 'nvim-telescope/telescope.nvim',
    -- 'ibhagwan/fzf-lua',
    -- 'nvim-mini/mini.pick',
    -- Optional: use your configured completion engine, or built-in completion.
    -- 'saghen/blink.cmp',
    -- 'hrsh7th/nvim-cmp',
    {
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        anti_conceal = { enabled = false },
        file_types = { 'markdown', 'opencode_output' },
      },
      ft = { 'markdown', 'opencode_output' },
    },
  },
  opts = {},
}
