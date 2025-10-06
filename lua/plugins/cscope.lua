-- Cscope Integration for AstroNvim v5 - Comprehensive code navigation
-- Features:
-- - Manual cscope database management (no auto-generation)
-- - Telescope integration for better search results display
-- - Comprehensive keybindings for all cscope search capabilities
-- - Call stack visualization
-- - Smart project root detection

---@type LazySpec
return {
  "dhananjaylatkar/cscope_maps.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim", -- required for telescope picker
  },
  event = "BufRead", -- load on buffer read for better performance

  -- Plugin-specific keybindings using lazy.nvim keys (AstroNvim-like)
  keys = {
    -- Helper function to check database
    -- Basic searches
    { "<Leader>cs", function()
        if not vim.loop.fs_stat("cscope.out") then
          require("utils.notify").notify("Cscope database not found. Build it first with <Leader>cb", {
            title = "Cscope",
            level = "warn"
          })
          return
        end
        local ok, err = pcall(vim.cmd, "Cs f s")
        if not ok then
          require("utils.notify").notify("Cscope error: " .. err, { title = "Cscope", level = "error" })
        end
      end, desc = "Find symbol" },
    { "<Leader>cg", function()
        local ok, err = pcall(vim.cmd, "Cs f g")
        if not ok then
          require("utils.notify").notify("Cscope error: " .. err, { title = "Cscope", level = "error" })
        end
      end, desc = "Find global definition" },
    { "<Leader>cc", function()
        local ok, err = pcall(vim.cmd, "Cs f c")
        if not ok then
          require("utils.notify").notify("Cscope error: " .. err, { title = "Cscope", level = "error" })
        end
      end, desc = "Find calls to function" },
    { "<Leader>ct", function()
        local ok, err = pcall(vim.cmd, "Cs f t")
        if not ok then
          require("utils.notify").notify("Cscope error: " .. err, { title = "Cscope", level = "error" })
        end
      end, desc = "Find text string" },
    { "<Leader>ce", function()
        local ok, err = pcall(vim.cmd, "Cs f e")
        if not ok then
          require("utils.notify").notify("Cscope error: " .. err, { title = "Cscope", level = "error" })
        end
      end, desc = "Find egrep pattern" },
    { "<Leader>cF", function()
        local ok, err = pcall(vim.cmd, "Cs f f")
        if not ok then
          require("utils.notify").notify("Cscope error: " .. err, { title = "Cscope", level = "error" })
        end
      end, desc = "Find file" },
    { "<Leader>ci", function()
        local ok, err = pcall(vim.cmd, "Cs f i")
        if not ok then
          require("utils.notify").notify("Cscope error: " .. err, { title = "Cscope", level = "error" })
        end
      end, desc = "Find files including file" },
    { "<Leader>cd", function()
        local ok, err = pcall(vim.cmd, "Cs f d")
        if not ok then
          require("utils.notify").notify("Cscope error: " .. err, { title = "Cscope", level = "error" })
        end
      end, desc = "Find functions called by function" },
    { "<Leader>ca", function()
        local ok, err = pcall(vim.cmd, "Cs f a")
        if not ok then
          require("utils.notify").notify("Cscope error: " .. err, { title = "Cscope", level = "error" })
        end
      end, desc = "Find assignments to symbol" },

    -- Database management
    { "<Leader>cb", function()
        local ok, err = pcall(vim.cmd, "Cs db build")
        if not ok then
          require("utils.notify").notify("Database build failed: " .. err, { title = "Cscope", level = "error" })
        else
          require("utils.notify").notify("Cscope database built successfully", { title = "Cscope", level = "info" })
        end
      end, desc = "Build cscope database" },
    { "<Leader>cB", function()
        local ok, err = pcall(vim.cmd, "Cs db build")
        if not ok then
          require("utils.notify").notify("Database rebuild failed: " .. err, { title = "Cscope", level = "error" })
        else
          require("utils.notify").notify("Cscope database rebuilt successfully", { title = "Cscope", level = "info" })
        end
      end, desc = "Rebuild cscope database" },
    { "<Leader>cS", function()
        local ok, err = pcall(vim.cmd, "Cs db show")
        if not ok then
          require("utils.notify").notify("Failed to show database: " .. err, { title = "Cscope", level = "error" })
        end
      end, desc = "Show cscope database connections" },

    -- Stack view (with database check)
    { "<Leader>cv", function()
        -- Check if cscope database exists first
        if not vim.loop.fs_stat("cscope.out") then
          require("utils.notify").notify("Cscope database not found. Build it first with <Leader>cb", {
            title = "Cscope",
            level = "warn"
          })
          return
        end
        local word = vim.fn.expand("<cword>")
        if word == "" then
          require("utils.notify").notify("No word under cursor for stack view", { title = "Cscope", level = "warn" })
          return
        end
        local ok, err = pcall(vim.cmd, "CsStackView open down " .. word)
        if not ok then
          require("utils.notify").notify("Stack view failed: " .. err, { title = "Cscope", level = "error" })
        end
      end, desc = "View downward call stack (who calls this)" },
    { "<Leader>cV", function()
        -- Check if cscope database exists first
        if not vim.loop.fs_stat("cscope.out") then
          require("utils.notify").notify("Cscope database not found. Build it first with <Leader>cb", {
            title = "Cscope",
            level = "warn"
          })
          return
        end
        local ok, err = pcall(vim.cmd, "CsStackView toggle")
        if not ok then
          require("utils.notify").notify("Stack view toggle failed: " .. err, { title = "Cscope", level = "error" })
        end
      end, desc = "Toggle last call stack view" },
    { "<Leader>cu", function()
        -- Check if cscope database exists first
        if not vim.loop.fs_stat("cscope.out") then
          require("utils.notify").notify("Cscope database not found. Build it first with <Leader>cb", {
            title = "Cscope",
            level = "warn"
          })
          return
        end
        local word = vim.fn.expand("<cword>")
        if word == "" then
          require("utils.notify").notify("No word under cursor for stack view", { title = "Cscope", level = "warn" })
          return
        end
        local ok, err = pcall(vim.cmd, "CsStackView open up " .. word)
        if not ok then
          require("utils.notify").notify("Stack view failed: " .. err, { title = "Cscope", level = "error" })
        end
      end, desc = "View upward call stack (what this calls)" },

    -- Advanced searches (word under cursor)
    { "<Leader>Cs", function()
        local word = vim.fn.expand("<cword>")
        if word == "" then
          require("utils.notify").notify("No word under cursor", { title = "Cscope", level = "warn" })
          return
        end
        local ok, err = pcall(vim.cmd, "Cs f s " .. word)
        if not ok then
          require("utils.notify").notify("Symbol search failed: " .. err, { title = "Cscope", level = "error" })
        end
      end, desc = "Find symbol under cursor" },
    { "<Leader>Cg", function()
        local word = vim.fn.expand("<cword>")
        if word == "" then
          require("utils.notify").notify("No word under cursor", { title = "Cscope", level = "warn" })
          return
        end
        local ok, err = pcall(vim.cmd, "Cs f g " .. word)
        if not ok then
          require("utils.notify").notify("Global definition search failed: " .. err, { title = "Cscope", level = "error" })
        end
      end, desc = "Find global definition under cursor" },
    { "<Leader>Cc", function()
        local word = vim.fn.expand("<cword>")
        if word == "" then
          require("utils.notify").notify("No word under cursor", { title = "Cscope", level = "warn" })
          return
        end
        local ok, err = pcall(vim.cmd, "Cs f c " .. word)
        if not ok then
          require("utils.notify").notify("Function calls search failed: " .. err, { title = "Cscope", level = "error" })
        end
      end, desc = "Find calls to function under cursor" },
    { "<Leader>Cd", function()
        local word = vim.fn.expand("<cword>")
        if word == "" then
          require("utils.notify").notify("No word under cursor", { title = "Cscope", level = "warn" })
          return
        end
        local ok, err = pcall(vim.cmd, "Cs f d " .. word)
        if not ok then
          require("utils.notify").notify("Called functions search failed: " .. err, { title = "Cscope", level = "error" })
        end
      end, desc = "Find functions called by function under cursor" },
    { "<Leader>Ca", function()
        local word = vim.fn.expand("<cword>")
        if word == "" then
          require("utils.notify").notify("No word under cursor", { title = "Cscope", level = "warn" })
          return
        end
        local ok, err = pcall(vim.cmd, "Cs f a " .. word)
        if not ok then
          require("utils.notify").notify("Assignments search failed: " .. err, { title = "Cscope", level = "error" })
        end
      end, desc = "Find assignments to symbol under cursor" },

    -- File-related searches (file under cursor)
    { "<Leader>Cf", function()
        local file = vim.fn.expand("<cfile>")
        if file == "" then
          require("utils.notify").notify("No file under cursor", { title = "Cscope", level = "warn" })
          return
        end
        local ok, err = pcall(vim.cmd, "Cs f f " .. file)
        if not ok then
          require("utils.notify").notify("File search failed: " .. err, { title = "Cscope", level = "error" })
        end
      end, desc = "Find file under cursor" },
    { "<Leader>Ci", function()
        local file = vim.fn.expand("<cfile>")
        if file == "" then
          require("utils.notify").notify("No file under cursor", { title = "Cscope", level = "warn" })
          return
        end
        local ok, err = pcall(vim.cmd, "Cs f i " .. file)
        if not ok then
          require("utils.notify").notify("Include search failed: " .. err, { title = "Cscope", level = "error" })
        end
      end, desc = "Find files including file under cursor" },
  },

  opts = {
    -- Disable default keymaps - we define them above in keys
    disable_maps = true,

    cscope = {
      -- Database configuration
      db_file = "./cscope.out", -- default database file
      exec = "cscope", -- cscope executable (can also use "gtags-cscope")

      -- Use telescope for better integration with AstroNvim
      picker = "telescope",

      -- Telescope picker options
      picker_opts = {
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = {
            width = 0.9,
            height = 0.8,
            preview_width = 0.6,
          },
        },
        sorting_strategy = "ascending",
        prompt_position = "top",
      },

      -- Project rooter configuration
      project_rooter = {
        enable = true, -- enable automatic project root detection
        change_cwd = false, -- don't change working directory
      },
    },
  },

  -- Setup function for manual database management only
  -- Note: Automatic database generation is disabled
  config = function(_, opts)
    require("cscope_maps").setup(opts)
  end,
}