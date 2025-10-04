-- Safe notification utility with AstroNvim integration
local M = {}

-- Convert level strings to vim.log.levels
local function get_log_level(level)
  if level == "error" then return vim.log.levels.ERROR
  elseif level == "warn" then return vim.log.levels.WARN
  elseif level == "info" then return vim.log.levels.INFO
  elseif level == "debug" then return vim.log.levels.DEBUG
  else return vim.log.levels.INFO end
end

function M.notify(message, opts)
  opts = opts or {}
  local title = opts.title or "Neovim"
  local level = opts.level or "info"

  local vim_log_level = get_log_level(level)
  vim.notify(message, vim_log_level, { title = title })
end

return M
