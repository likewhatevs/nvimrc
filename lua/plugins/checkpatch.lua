-- Linux Kernel Checkpatch Integration via nvim-lint
--
-- EASY DISABLE: Add this line at the top to disable: if true then return {} end
if true then return {} end -- DISABLED: Now using none-ls integration
--
-- Features:
-- - Only runs on files within Linux kernel source trees
-- - Auto-detects kernel trees via scripts/checkpatch.pl, MAINTAINERS, etc.
-- - Uses kernel's own checkpatch.pl script when available
-- - Supports C, header, assembly, and device tree files
-- - Provides manual commands: :Checkpatch and :CheckpatchStatus
-- - Keybindings: <Leader>kc (run checkpatch), <Leader>ks (status)
--
-- Requirements:
-- - Either: scripts/checkpatch.pl in kernel source tree
-- - Or: checkpatch.pl installed system-wide

---@type LazySpec
return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")
    local checkpatch_utils = require("checkpatch_utils")

    -- Configure checkpatch linter with kernel-specific settings
    lint.linters.checkpatch = {
      cmd = function()
        local checkpatch = checkpatch_utils.find_checkpatch_script()
        return checkpatch or "checkpatch.pl"
      end,
      stdin = false,
      args = {
        "--no-tree",        -- Don't check for kernel tree (we do our own check)
        "--emacs",          -- Emacs-style output format
        "--show-types",     -- Show the type of each message
        "--strict",         -- Enable additional checks
        "--file",           -- Check a file (not a patch)
      },
      stream = "stderr",    -- checkpatch outputs to stderr
      ignore_exitcode = true, -- checkpatch returns non-zero for warnings
      parser = function(output, bufnr)
        local diagnostics = {}
        local lines = vim.split(output, "\n", { plain = true })

        for _, line in ipairs(lines) do
          -- Parse checkpatch output format: filename:line:column: type: message
          local filename, row, col, severity, message = line:match("^([^:]+):(%d+):(%d*):?%s*(%w+):%s*(.+)$")

          if filename and row and message then
            -- Convert checkpatch severity to LSP severity
            local lsp_severity
            if severity == "ERROR" then
              lsp_severity = vim.diagnostic.severity.ERROR
            elseif severity == "WARNING" then
              lsp_severity = vim.diagnostic.severity.WARN
            elseif severity == "CHECK" then
              lsp_severity = vim.diagnostic.severity.INFO
            else
              lsp_severity = vim.diagnostic.severity.HINT
            end

            table.insert(diagnostics, {
              lnum = tonumber(row) - 1,  -- Convert to 0-based
              col = col ~= "" and (tonumber(col) - 1) or 0,
              message = string.format("[%s] %s", severity, message),
              severity = lsp_severity,
              source = "checkpatch",
            })
          end
        end

        return diagnostics
      end,
    }

    -- Configure linters by filetype - only for kernel-relevant files
    lint.linters_by_ft = {
      c = { "checkpatch" },
      h = { "checkpatch" },       -- Header files
      S = { "checkpatch" },       -- Assembly files
      dts = { "checkpatch" },     -- Device tree files
      dtsi = { "checkpatch" },    -- Device tree include files
    }

    -- Autocommands and commands are now handled by AstroCore (see astrocore.lua)
    -- This keeps the plugin focused on just the linter configuration
  end,
}