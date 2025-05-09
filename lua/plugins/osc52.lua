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

      local function paste()
        return { vim.fn.split(vim.fn.getreg(''), '\n'), vim.fn.getregtype('') }
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
            require('osc52').copy_register('+')
          end,
        })
      end
    end,
  },
}

