return {
  provider = function()
    -- TODO: Consider using vim.lsp.buf.workspace_diagnostics when 0.12 releases
    local count = vim.diagnostic.get(nil, { severity = vim.diagnostic.severity.ERROR })
    return tostring(vim.tbl_count(count))
  end,

  padding = { left = 1, right = 0 },
  color = "DiagnosticError",

  variants = {
    {
      min_cols = 0, -- always
      format = function(count)
        if count == "" or count == "0" then return "" end
        return " "
      end,
    },
    {
      min_cols = 80,
      format = function(count)
        if count == "" or count == "0" then return "" end
        return " " .. count
      end,
    },
  },
}
