local M = {}

M.defaults = {
  path = vim.fn.expand("~/Basal"),
  disable_mappings = false,
  templates_dir = "4_Templates",
  notes_dir = "6_Notes",
  daily_dir = "5_Daily",
}

M.options = {}

function M.setup(opts)
  M.options = vim.tbl_deep_extend("force", M.defaults, opts or {})
  -- Set environment variable for backward compatibility or scripts if needed
  vim.env.BASAL = vim.fn.expand(M.options.path)
  
  -- Add to path and suffixesadd for 'gf' support
  vim.opt.path:append(vim.env.BASAL .. "/**")
  vim.opt.suffixesadd:append(".md")
end

return M
