-- lua/plugins/osc52.lua
return {
  {
    "ojroques/nvim-osc52",
    config = function()
      require("osc52").setup {
        max_length = 0, -- Maximum length of selection (0 for no limit)
        silent = false, -- Disable message on successful copy
        trim = false, -- Disable trimming of surrounding whitespace
      }

      -- Automatically use OSC52 for SSH sessions to copy to local clipboard
      if vim.env.SSH_CONNECTION then
        vim.api.nvim_create_autocmd("TextYankPost", {
          callback = function()
            -- Copy yanked text to local clipboard via OSC52
            local ok, err = pcall(function()
              if vim.v.event.operator == 'y' then
                require('osc52').copy(table.concat(vim.v.event.regcontents, '\n'))
              end
            end)
            if not ok then
              -- Silently ignore errors to prevent disrupting workflow
              -- vim.notify("OSC52 copy failed: " .. tostring(err), vim.log.levels.DEBUG)
            end
          end,
        })
      end
    end,
  },
}

