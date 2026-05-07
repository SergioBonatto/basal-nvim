if vim.g.loaded_basal then
  return
end
vim.g.loaded_basal = 1

-- Set default config if not already set by user's setup()
local config = require("basal.config")
if not config.options or vim.tbl_isempty(config.options) then
  config.setup({})
end

local function basal_cmd(name, fn, opts)
  vim.api.nvim_create_user_command(name, fn, opts or {})
end

-- Commands
basal_cmd("BasalInit", function() require("basal").init() end, { desc = "Initialize Basal brain structure" })
basal_cmd("BasalCheck", function() require("basal").check() end, { desc = "Check Basal dependencies" })
basal_cmd("BasalDaily", function() require("basal").daily() end, { desc = "Open/Create today's daily log" })
basal_cmd("BasalNew", function() require("basal").new_note() end, { desc = "Create new note from template" })
basal_cmd("BasalBacklinks", function() require("basal").backlinks() end, { desc = "Find backlinks for current note" })
basal_cmd("BasalSearch", function(opts) require("basal").search(opts.args) end, { 
  nargs = "?", 
  desc = "Global search in Basal brain" 
})

-- Mappings
if not config.options.disable_mappings then
  local map = function(lhs, rhs, desc)
    vim.keymap.set("n", lhs, rhs, { desc = "Basal: " .. desc, silent = true })
  end

  map("<leader>bb", function() vim.cmd("e " .. vim.env.BASAL .. "/index.md") end, "Open Index")
  map("<leader>bt", function() vim.cmd("e " .. vim.env.BASAL .. "/TODO.md") end, "Open TODO")
  map("<leader>bd", ":BasalDaily<CR>", "Daily Log")
  map("<leader>bn", ":BasalNew<CR>", "New Note")
  map("<leader>bs", ":BasalSearch ", "Search")
  map("<leader>bl", ":BasalBacklinks<CR>", "Backlinks")
  map("F", function() require("basal").search(vim.fn.expand("<cWORD>")) end, "Search word under cursor")
end

-- Highlight setup
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = "*.md",
  callback = function()
    local path = vim.fn.expand("%:p")
    local basal_path = vim.fn.expand(config.options.path)
    if path:find(basal_path, 1, true) then
      -- Link Treesitter captures to standard groups
      vim.api.nvim_set_hl(0, "@basal_tag", { link = "Tag", default = true })
      vim.api.nvim_set_hl(0, "@basal_link", { link = "Underlined", default = true })
    end
  end,
})
