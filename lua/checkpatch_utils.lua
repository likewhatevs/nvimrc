-- Checkpatch utilities - shared functions for AstroCore integration
local M = {}

-- Function to detect if we're in a Linux kernel source tree
function M.is_kernel_source_tree(bufnr)
  local bufname = vim.api.nvim_buf_get_name(bufnr or 0)
  if bufname == "" then return false end

  -- Get the directory of the current file
  local file_dir = vim.fn.fnamemodify(bufname, ":h")

  -- Walk up the directory tree to find git root
  local git_root = nil
  local current_dir = file_dir

  while current_dir ~= "/" and current_dir ~= "" do
    if vim.fn.isdirectory(current_dir .. "/.git") == 1 then
      git_root = current_dir
      break
    end
    current_dir = vim.fn.fnamemodify(current_dir, ":h")
  end

  if not git_root then return false end

  -- Check for kernel source tree indicators
  local kernel_indicators = {
    "scripts/checkpatch.pl",  -- Most reliable indicator
    "MAINTAINERS",            -- Kernel maintainers file
    "Kconfig",                -- Kernel config file
    "COPYING",                -- Kernel license file
  }

  -- Additional directory structure checks
  local kernel_dirs = {
    "arch", "drivers", "kernel", "mm", "fs", "net",
  }

  -- Check for primary indicators
  for _, indicator in ipairs(kernel_indicators) do
    if vim.fn.filereadable(git_root .. "/" .. indicator) == 1 then
      return true
    end
  end

  -- Check for kernel directory structure (need at least 3 to be sure)
  local dir_count = 0
  for _, kdir in ipairs(kernel_dirs) do
    if vim.fn.isdirectory(git_root .. "/" .. kdir) == 1 then
      dir_count = dir_count + 1
    end
  end

  return dir_count >= 3
end

-- Function to find checkpatch.pl script
function M.find_checkpatch_script(bufnr)
  local bufname = vim.api.nvim_buf_get_name(bufnr or 0)
  if bufname == "" then return nil end

  local file_dir = vim.fn.fnamemodify(bufname, ":h")
  local current_dir = file_dir

  -- Walk up to find git root and look for scripts/checkpatch.pl
  while current_dir ~= "/" and current_dir ~= "" do
    if vim.fn.isdirectory(current_dir .. "/.git") == 1 then
      local checkpatch_path = current_dir .. "/scripts/checkpatch.pl"
      if vim.fn.filereadable(checkpatch_path) == 1 then
        return checkpatch_path
      end
      break
    end
    current_dir = vim.fn.fnamemodify(current_dir, ":h")
  end

  -- Fallback to system checkpatch.pl if available
  if vim.fn.executable("checkpatch.pl") == 1 then
    return "checkpatch.pl"
  end

  return nil
end

-- Smart linting that only runs in kernel source trees
function M.smart_lint()
  local bufnr = vim.api.nvim_get_current_buf()

  -- Only proceed if we're in a kernel source tree
  if not M.is_kernel_source_tree(bufnr) then
    return
  end

  -- Check if checkpatch script is available
  if not M.find_checkpatch_script(bufnr) then
    -- Only show this message once per session
    if not vim.g.checkpatch_warning_shown then
      require("notify_utils").notify(
        "Checkpatch script not found. Install checkpatch.pl or ensure you're in a kernel source tree with scripts/checkpatch.pl",
        { title = "Checkpatch", level = "warn" }
      )
      vim.g.checkpatch_warning_shown = true
    end
    return
  end

  -- Run the linter
  require("lint").try_lint()
end

-- Show checkpatch status
function M.show_status()
  local bufnr = vim.api.nvim_get_current_buf()
  local is_kernel = M.is_kernel_source_tree(bufnr)
  local checkpatch_path = M.find_checkpatch_script(bufnr)

  local status_lines = {
    "Checkpatch Status:",
    "  Kernel source tree: " .. (is_kernel and "✓ Yes" or "✗ No"),
    "  Checkpatch script: " .. (checkpatch_path and ("✓ " .. checkpatch_path) or "✗ Not found"),
    "  Current file type: " .. vim.bo.filetype,
  }

  require("notify_utils").notify(table.concat(status_lines, "\n"), {
    title = "Checkpatch",
    level = "info"
  })
end

return M