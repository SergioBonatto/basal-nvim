local config = require("basal.config")
local core = require("basal.core")
local M = {}

function M.search(query)
  local fzf = require("fzf-lua")
  local opts = {
    cwd = vim.env.BASAL,
    prompt = "Basal Search> ",
  }
  
  if query and query ~= "" then
    opts.search = query
    fzf.grep(opts)
  else
    fzf.live_grep(opts)
  end
end

function M.backlinks()
  local filename = vim.fn.fnamemodify(vim.fn.expand("%"), ":t:r")
  if filename == "" then return end

  -- Pattern for [[filename]], (filename.md), or (filename)
  local pattern = string.format("\\[\\[%s\\]\\]|\\(%s\\.md\\)|\\(%s\\)", filename, filename, filename)
  
  require("fzf-lua").grep({
    search = pattern,
    cwd = vim.env.BASAL,
    prompt = "Backlinks> ",
    exec_empty_query = true,
  })
end

function M.new_note()
  local template_dir = vim.env.BASAL .. "/" .. config.options.templates_dir
  if vim.fn.isdirectory(template_dir) == 0 then
    vim.notify("Basal: Template directory not found at " .. template_dir, vim.log.levels.ERROR)
    return
  end

  local templates = vim.fn.globpath(template_dir, "*.md", false, true)
  if #templates == 0 then
    vim.notify("Basal: No templates found in " .. template_dir, vim.log.levels.ERROR)
    return
  end

  local template_names = {}
  for _, path in ipairs(templates) do
    table.insert(template_names, vim.fn.fnamemodify(path, ":t"))
  end

  require("fzf-lua").fzf_exec(template_names, {
    prompt = "Select Template> ",
    actions = {
      ["default"] = function(selected)
        if selected and #selected > 0 then
          core.create_from_template(selected[1])
        end
      end
    }
  })
end

return M
