-- Telescope Configuration - Consolidates all telescope extensions
-- This replaces multiple telescope.setup() calls in user.lua

---@type LazySpec
return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-telescope/telescope-fzf-native.nvim",
    "debugloop/telescope-undo.nvim",
    "nvim-telescope/telescope-frecency.nvim",
    "kkharji/sqlite.lua",
  },
  keys = {
    -- Telescope extensions (keep plugin-specific keys here)
    { "<leader>fu", "<cmd>Telescope undo<cr>", desc = "Find in undo history" },
    { "<leader>fo", "<cmd>Telescope oldfiles<cr>", desc = "Find old files (simple)" },
  },
  opts = function(_, opts)
    -- Extend telescope configuration using AstroNvim pattern
    return require("astrocore").extend_tbl(opts, {
      defaults = {
        dynamic_preview_title = true,
      },
      extensions = {
        -- FZF Native extension
        fzf = {
          fuzzy = true,                    -- Enable fuzzy matching
          override_generic_sorter = true, -- Override generic sorter
          override_file_sorter = true,    -- Override file sorter
          case_mode = "smart_case",       -- Smart case matching
        },

        -- Undo extension
        undo = {
          use_delta = true,        -- Use delta for better diff display
          use_custom_command = nil, -- Use default command
          side_by_side = false,    -- Show diffs side by side
          vim_diff_opts = {
            ctxlen = 8,            -- Context lines in diff
          },
          entry_format = "state #$ID, $STAT, $TIME",
          time_format = "",
          saved_only = false,      -- Show all undo states, not just saved ones
        },

        -- Frecency extension
        frecency = {
          show_scores = false,           -- Don't show frecency scores in picker
          show_unindexed = true,         -- Show files not yet indexed
          ignore_patterns = {            -- Ignore these patterns
            "*.git/*",
            "*/tmp/*",
            "*/node_modules/*",
            "*/.cache/*",
            "*/build/*",
            "*/target/*",
          },
          disable_devicons = false,      -- Show file icons
          workspaces = {                 -- Define workspaces for better organization
            ["conf"] = vim.env.HOME .. "/.config",
            ["nvim"] = vim.env.HOME .. "/.config/nvim",
            ["project"] = vim.fn.getcwd(), -- Current project
          },
          -- Database configuration
          db_root = vim.fn.stdpath("data"), -- Where to store frecency database
          auto_validate = true,          -- Auto-validate database entries
        }
      }
    })
  end,
  config = function(_, opts)
    local telescope = require("telescope")
    telescope.setup(opts)

    -- Load extensions
    telescope.load_extension("fzf")
    telescope.load_extension("undo")
    telescope.load_extension("frecency")
  end,
}