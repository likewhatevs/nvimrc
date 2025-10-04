-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics = { virtual_text = true, virtual_lines = false }, -- diagnostic settings on startup
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- passed to `vim.filetype.add`
    filetypes = {
      -- see `:h vim.filetype.add` for usage
      extension = {
        foo = "fooscript",
      },
      filename = {
        [".foorc"] = "fooscript",
      },
      pattern = {
        [".*/etc/foo/.*"] = "fooscript",
      },
    },
    -- Configure autocommands
    autocmds = {},
    -- Configure commands (AstroNvim way)
    commands = {
      -- Checkpatch commands (now using none-ls)
      Checkpatch = {
        function()
          local checkpatch_util = require("checkpatch_utils")

          if checkpatch_util.is_kernel_source_tree() then
            -- Simple save to trigger none-ls
            vim.cmd("write")
            require("notify_utils").notify("Checkpatch diagnostics refreshed", {
              title = "Checkpatch",
              level = "info"
            })
          else
            require("notify_utils").notify("Not in a kernel source tree", {
              title = "Checkpatch",
              level = "warn"
            })
          end
        end,
        desc = "Manually run checkpatch on current buffer",
      },
      CheckpatchStatus = {
        function() require("checkpatch_utils").show_status() end,
        desc = "Show checkpatch configuration status",
      },

      -- Mason cleanup commands for codelldb conflicts
      MasonCleanCodelldb = {
        function()
          local mason_registry = require("mason-registry")
          local codelldb_pkg = mason_registry.get_package("codelldb")

          if codelldb_pkg:is_installed() then
            require("notify_utils").notify("Uninstalling codelldb via Mason...", { title = "Mason", level = "info" })
            codelldb_pkg:uninstall():once("closed", function()
              require("notify_utils").notify("Codelldb uninstalled successfully", { title = "Mason", level = "info" })
            end)
          else
            require("notify_utils").notify("Codelldb not installed via Mason", { title = "Mason", level = "info" })
          end
        end,
        desc = "Uninstall codelldb if installed via Mason",
      },

      MasonCleanCache = {
        function()
          -- Clear Mason cache directory
          local mason_path = vim.fn.stdpath("data") .. "/mason"
          local cmd = "rm -rf " .. mason_path .. "/packages/codelldb* " .. mason_path .. "/bin/codelldb*"

          require("notify_utils").notify("Cleaning Mason codelldb cache...", { title = "Mason", level = "info" })

          vim.fn.system(cmd)
          require("notify_utils").notify("Mason codelldb cache cleaned. Restart nvim for full effect.", {
            title = "Mason",
            level = "info"
          })
        end,
        desc = "Clean Mason cache for codelldb",
      },
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = true, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        signcolumn = "yes", -- sets vim.opt.signcolumn to yes
        wrap = true, -- sets vim.opt.wrap

        -- Undo persistence across restarts
        undofile = true, -- enable persistent undo
        undolevels = 10000, -- maximum number of changes that can be undone
        undoreload = 10000, -- maximum number lines to save for undo on buffer reload
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      -- first key is the mode
      n = {
        -- second key is the lefthand side of the map

        -- navigate buffer tabs
        ["]b"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["[b"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },
        ["<leader>G"] = {
          function()
            require("gitsigns").change_base('main')
            require('neo-tree.command').execute({ source = 'git_status', git_base = 'main' })
          end,
          desc = "Gitsigns/neotree: Change base to main" },
        ["<Leader>bP"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Pick buffer to close from tabline",
        },

        -- tables with just a `desc` key will be registered with which-key if it's installed
        -- this is useful for naming menus
        ["<Leader>c"] = { desc = "󰒺 Cscope" },
        ["<Leader>C"] = { desc = "󰒺 Cscope Advanced" },
        ["<Leader>f"] = { desc = " Find" },
        ["<Leader>k"] = { desc = " Kernel Tools" },
        ["<Leader>K"] = { desc = "󰌌 Keymaps" },
        ["<Leader>x"] = { desc = "󰒭 Diagnostics/Trouble" },

        -- Override default telescope mappings with frecency
        ["<Leader>ff"] = {
          function()
            -- Check if frecency extension is loaded, fallback to default if not
            local ok, telescope = pcall(require, "telescope")
            if ok and telescope.extensions and telescope.extensions.frecency then
              local frecency_ok, err = pcall(vim.cmd, "Telescope frecency")
              if not frecency_ok then
                require("notify_utils").notify("Frecency failed, falling back to find_files: " .. err, {
                  title = "Telescope",
                  level = "warn"
                })
                require("telescope.builtin").find_files()
              end
            else
              require("telescope.builtin").find_files()
            end
          end,
          desc = "Find files (frecency)"
        },

        -- Kernel development tools (checkpatch)
        ["<Leader>kc"] = { "<cmd>Checkpatch<cr>", desc = "Run checkpatch on current file" },
        ["<Leader>ks"] = { "<cmd>CheckpatchStatus<cr>", desc = "Show checkpatch status" },

        -- Keymap viewing tools
        ["<Leader>Kk"] = { "<cmd>Telescope keymaps<cr>", desc = "Search all keymaps" },
        ["<Leader>KK"] = { "<cmd>WhichKey<cr>", desc = "Show all keymaps (which-key)" },
        ["<Leader>Kl"] = { "<cmd>WhichKey <Leader><cr>", desc = "Show leader keymaps" },
        ["<Leader>Kg"] = { "<cmd>WhichKey g<cr>", desc = "Show g-prefixed keymaps" },
        ["<Leader>Kz"] = { "<cmd>WhichKey z<cr>", desc = "Show z-prefixed keymaps" },
        ["<Leader>Kw"] = { "<cmd>WhichKey <C-w><cr>", desc = "Show window keymaps" },
        ["<Leader>Kn"] = { "<cmd>nmap<cr>", desc = "Show normal mode mappings" },
        ["<Leader>Ki"] = { "<cmd>imap<cr>", desc = "Show insert mode mappings" },
        ["<Leader>Kv"] = { "<cmd>vmap<cr>", desc = "Show visual mode mappings" },

        -- Buffer management (restore AstroNvim close buffer functionality)
        ["<Leader>bx"] = { function() require("astrocore.buffer").close() end, desc = "Close buffer" },

        -- ["<Leader>b"] = { desc = "Buffers" },

        -- setting a mapping to false will disable it
        -- ["<C-S>"] = false,
      },
    },
  },
}
