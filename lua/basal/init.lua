local M = {}

function M.setup(opts)
  require("basal.config").setup(opts)
  -- Commands and mappings are usually handled in plugin/basal.lua
  -- but we can trigger them here if we want them to be dynamically set
end

-- Export core functions for easy access
function M.init()
  require("basal.core").init()
end

function M.daily()
  require("basal.core").daily()
end

function M.new_note()
  require("basal.core").new_note()
end

function M.search(query)
  require("basal.fzf").search(query)
end

function M.backlinks()
  require("basal.fzf").backlinks()
end

function M.check()
  require("basal.core").check()
end

return M
