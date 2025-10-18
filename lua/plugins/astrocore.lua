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
      large_buf = { size = 1024 * 1024, lines = 50000 }, -- set global limits for large files (increased for kernel development)
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
        -- Device tree files (kernel development)
        dts = "dts",
        dtsi = "dts",
        -- Kernel config files
        defconfig = "kconfig",
      },
      filename = {
        -- Kernel build and config files
        ["Kconfig"] = "kconfig",
        ["Kbuild"] = "make",
        [".config"] = "kconfig", -- Kernel configuration
        ["MAINTAINERS"] = "maintainers", -- Kernel maintainers file
      },
      pattern = {
        -- Kernel source patterns
        [".*/arch/.*/Kconfig.*"] = "kconfig",
        [".*/drivers/.*/Kconfig.*"] = "kconfig",
        [".*/fs/.*/Kconfig.*"] = "kconfig",
        [".*/net/.*/Kconfig.*"] = "kconfig",
        [".*/kernel/.*/Kconfig.*"] = "kconfig",
      },
    },
    -- Configure autocommands
    autocmds = {
      -- Kernel development settings
      kernel_development = {
        {
          event = { "BufRead", "BufNewFile" },
          pattern = { "*.c", "*.h", "*.S", "*.dts", "*.dtsi" },
          callback = function()
            local checkpatch_utils = require("utils.checkpatch")
            if checkpatch_utils.is_kernel_source_tree() then
              -- Kernel coding style: tabs, 8-space width
              vim.opt_local.expandtab = false
              vim.opt_local.tabstop = 8
              vim.opt_local.shiftwidth = 8
              vim.opt_local.softtabstop = 8
              -- Show column guide at 80 characters (kernel line limit)
              vim.opt_local.colorcolumn = "80"
            end
          end,
          desc = "Set kernel coding style for kernel source files",
        },
        {
          event = "BufWritePre",
          pattern = { "*.c", "*.h" },
          callback = function()
            local checkpatch_utils = require("utils.checkpatch")
            if checkpatch_utils.is_kernel_source_tree() then
              -- Remove trailing whitespace (kernel requirement)
              vim.cmd([[%s/\s\+$//e]])
            end
          end,
          desc = "Remove trailing whitespace in kernel source files",
        },
      },
    },
    -- Configure commands (AstroNvim way)
    commands = {
      -- Checkpatch commands (now using none-ls)
      Checkpatch = {
        function()
          local checkpatch_util = require("utils.checkpatch")

          if checkpatch_util.is_kernel_source_tree() then
            -- Simple save to trigger none-ls
            vim.cmd("write")
            require("utils.notify").notify("Checkpatch diagnostics refreshed", {
              title = "Checkpatch",
              level = "info"
            })
          else
            require("utils.notify").notify("Not in a kernel source tree", {
              title = "Checkpatch",
              level = "warn"
            })
          end
        end,
        desc = "Manually run checkpatch on current buffer",
      },
      CheckpatchStatus = {
        function() require("utils.checkpatch").show_status() end,
        desc = "Show checkpatch configuration status",
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

        -- Clipboard: disable clipboard=unnamedplus for SSH (use OSC52 instead)
        clipboard = "", -- don't sync with system clipboard, use OSC52 autocmd

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
                require("utils.notify").notify("Frecency failed, falling back to find_files: " .. err, {
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
        ["<Leader>km"] = { "<cmd>make<cr>", desc = "Run make in current directory" },
        ["<Leader>kM"] = { "<cmd>make clean<cr>", desc = "Run make clean" },
        ["<Leader>kt"] = { "<cmd>make modules_install<cr>", desc = "Install kernel modules" },

        -- Git workflow enhancements for kernel development
        ["<Leader>gb"] = { "<cmd>BlameToggle<cr>", desc = "Toggle git blame" },
        ["<Leader>gB"] = { "<cmd>BlameToggle window<cr>", desc = "Git blame in window" },
        ["<Leader>gd"] = { "<cmd>DiffviewOpen<cr>", desc = "Open diff view" },
        ["<Leader>gD"] = { "<cmd>DiffviewClose<cr>", desc = "Close diff view" },
        ["<Leader>gh"] = { "<cmd>DiffviewFileHistory %<cr>", desc = "File history" },
        ["<Leader>gH"] = { "<cmd>DiffviewFileHistory<cr>", desc = "Repository history" },

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
