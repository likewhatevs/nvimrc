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

      local function copy(lines, _)
        require('osc52').copy(table.concat(lines, '\n'))
      end

      local function paste(register)
        -- Use the specified register ('+' or '*'), falling back to unnamed register
        local reg = register or '+'
        return { vim.fn.split(vim.fn.getreg(reg), '\n'), vim.fn.getregtype(reg) }
      end

      vim.g.clipboard = {
        name = 'osc52',
        copy = { ['+'] = copy, ['*'] = copy },
        paste = { ['+'] = paste, ['*'] = paste },
      }

      -- Optional: Automatically use OSC52 for SSH sessions
      if vim.env.SSH_CONNECTION then
        vim.api.nvim_create_autocmd("TextYankPost", {
          callback = function()
            -- Add error handling and skip if register is empty or invalid
            local ok, err = pcall(function()
              local reg_contents = vim.fn.getreg('+')
              -- Only copy if register has valid contents
              if reg_contents and reg_contents ~= '' then
                require('osc52').copy_register('+')
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

