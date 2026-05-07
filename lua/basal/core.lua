local config = require("basal.config")
local M = {}

-- Get the plugin root directory
local function get_plugin_root()
  local str = debug.getinfo(1).source:sub(2)
  -- Remove lua/basal/core.lua
  return vim.fn.fnamemodify(str, ":h:h:h")
end

function M.check()
  local errors = {}
  if vim.fn.executable("rg") == 0 then
    table.insert(errors, "ripgrep (rg) not found in PATH")
  end
  
  -- Check for fzf-lua
  local has_fzf, _ = pcall(require, "fzf-lua")
  if not has_fzf then
    table.insert(errors, "fzf-lua not found or not loaded")
  end

  if not vim.env.BASAL or vim.env.BASAL == "" then
    table.insert(errors, "$BASAL (config.path) is not set")
  end

  if #errors > 0 then
    for _, err in ipairs(errors) do
      vim.notify("Basal: " .. err, vim.log.levels.ERROR)
    end
    return false
  end
  vim.notify("Basal: Environment OK", vim.log.levels.INFO)
  return true
end

function M.init()
  if not M.check() then return end

  local target_dir = vim.fn.expand(config.options.path)
  if vim.fn.isdirectory(target_dir) == 1 then
    vim.notify("Basal: Directory " .. target_dir .. " already exists.", vim.log.levels.ERROR)
    return
  end

  local skeleton_dir = get_plugin_root() .. "/skeleton"
  if vim.fn.isdirectory(skeleton_dir) == 0 then
    vim.notify("Basal: Skeleton source not found at " .. skeleton_dir, vim.log.levels.ERROR)
    return
  end

  -- Create parent directory if it doesn't exist
  local parent_dir = vim.fn.fnamemodify(target_dir, ":h")
  if vim.fn.isdirectory(parent_dir) == 0 then
    vim.fn.mkdir(parent_dir, "p")
  end

  -- Copy skeleton to target
  local cmd = string.format("cp -R %s %s", vim.fn.shellescape(skeleton_dir), vim.fn.shellescape(target_dir))
  vim.fn.system(cmd)

  if vim.v.shell_error ~= 0 then
    vim.notify("Basal: Copy failed. Check permissions for " .. parent_dir, vim.log.levels.ERROR)
  else
    vim.notify("Basal: Brain initialized at " .. target_dir, vim.log.levels.INFO)
    vim.cmd("e " .. target_dir .. "/index.md")
  end
end

function M.process_template(lines, title)
  local processed = {}
  local date = os.date("%Y-%m-%d")
  local title_only = vim.fn.fnamemodify(title, ":t:r")

  for _, line in ipairs(lines) do
    local tmp = line:gsub("YYYY%-MM%-DD", date)
    tmp = tmp:gsub("TITLE", title_only)
    table.insert(processed, tmp)
  end
  return processed
end

function M.daily()
  local date = os.date("%Y-%m-%d")
  local daily_dir = vim.env.BASAL .. "/" .. config.options.daily_dir
  local path = daily_dir .. "/" .. date .. ".md"

  if vim.fn.filereadable(path) == 0 then
    local template_path = vim.env.BASAL .. "/" .. config.options.templates_dir .. "/daily.md"
    local content
    if vim.fn.filereadable(template_path) == 1 then
      content = vim.fn.readfile(template_path)
    else
      content = { "# Daily Log: " .. date }
    end

    if vim.fn.isdirectory(daily_dir) == 0 then
      vim.fn.mkdir(daily_dir, "p")
    end

    local processed = M.process_template(content, date)
    vim.fn.writefile(processed, path)
  end

  vim.cmd("e " .. path)
end

function M.create_from_template(template_name)
  local name = vim.fn.input("Note Name (e.g., area/topic): ")
  if name == "" then return end

  local path = vim.env.BASAL .. "/" .. config.options.notes_dir .. "/" .. name .. ".md"
  if vim.fn.filereadable(path) == 1 then
    vim.notify("Basal: File already exists: " .. path, vim.log.levels.ERROR)
    return
  end

  local template_path = vim.env.BASAL .. "/" .. config.options.templates_dir .. "/" .. template_name
  if vim.fn.filereadable(template_path) == 0 then
    vim.notify("Basal: Template not found: " .. template_path, vim.log.levels.ERROR)
    return
  end

  local content = vim.fn.readfile(template_path)
  
  -- Create parent directories if needed
  local parent = vim.fn.fnamemodify(path, ":h")
  if vim.fn.isdirectory(parent) == 0 then
    vim.fn.mkdir(parent, "p")
  end

  local processed = M.process_template(content, name)
  vim.fn.writefile(processed, path)
  vim.cmd("e " .. path)
end

return M
