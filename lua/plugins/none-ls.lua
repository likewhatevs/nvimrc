-- Customize None-ls sources for kernel development

---@type LazySpec
return {
  "nvimtools/none-ls.nvim",
  opts = function(_, opts)
    local h = require("null-ls.helpers")
    local methods = require("null-ls.methods")
    local checkpatch_utils = require("checkpatch_utils")

    -- Custom checkpatch source using proper none-ls builtin pattern
    local checkpatch = h.make_builtin({
      name = "checkpatch",
      meta = {
        url = "https://www.kernel.org/doc/html/latest/dev-tools/checkpatch.html",
        description = "Linux kernel checkpatch script for coding style validation.",
      },
      method = methods.internal.DIAGNOSTICS,
      filetypes = { "c", "h", "S", "dts", "dtsi" },
      generator_opts = {
        command = function()
          return checkpatch_utils.find_checkpatch_script() or "checkpatch.pl"
        end,
        args = { "--strict", "--terse", "--file", "$FILENAME" },
        to_stdin = false,
        format = "line",
        check_exit_code = function(code)
          return code <= 1
        end,
        runtime_condition = function(params)
          return checkpatch_utils.is_kernel_source_tree()
        end,
        to_temp_file = true,  -- Like cppcheck - write buffer to temp file
        on_output = h.diagnostics.from_pattern(
          [=[([^:]+):(%d+): (%w+): (.*)]=],  -- pattern: path:line: severity: message
          { "filename", "row", "severity", "message" },  -- groups
          {
            severities = {
              ERROR = h.diagnostics.severities["error"],
              WARNING = h.diagnostics.severities["warning"],
              CHECK = h.diagnostics.severities["information"],
            },
          }
        ),
      },
      factory = h.generator_factory,
    })

    -- Use AstroCore method to add source
    opts.sources = require("astrocore").list_insert_unique(opts.sources, {
      checkpatch,
    })

    return opts
  end,
}
