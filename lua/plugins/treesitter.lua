-- Customize Treesitter - Enhanced syntax highlighting and code analysis

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      -- Core languages matching your language packs
      "lua",        -- For nvim config and lua development
      "vim",        -- For vim script
      "vimdoc",     -- For vim documentation
      "c",          -- C language support
      "cpp",        -- C++ language support
      "rust",       -- Rust language support

      -- Build systems and config files
      "cmake",      -- CMake files
      "make",       -- Makefiles
      "ninja",      -- Ninja build files

      -- Shell and scripting
      "bash",       -- Shell scripts
      "fish",       -- Fish shell

      -- Data formats and markup
      "json",       -- JSON files
      "yaml",       -- YAML files
      "toml",       -- TOML config files
      "xml",        -- XML files
      "markdown",   -- Markdown documentation
      "markdown_inline", -- Inline markdown

      -- Kernel development specific
      "kconfig",    -- Kernel configuration files

      -- Git and version control
      "git_config", -- Git config files
      "git_rebase", -- Git rebase files
      "gitcommit",  -- Git commit messages
      "gitignore",  -- Git ignore files
      "diff",       -- Diff files

      -- Other useful languages
      "python",     -- Python (common in build systems)
      "dockerfile", -- Docker files
      "sql",        -- SQL queries
      "regex",      -- Regular expressions
      "comment",    -- Comments highlighting
    },

    -- Ignore parsers that conflict with plugins
    ignore_install = { "org" }, -- nvim-orgmode handles org syntax

    -- Enable advanced treesitter features
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false, -- Disable vim regex highlighting for performance
    },

    -- Enable incremental selection
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "gnn",    -- Start selection
        node_incremental = "grn",  -- Increment selection
        scope_incremental = "grc", -- Increment to scope
        node_decremental = "grm",  -- Decrement selection
      },
    },

    -- Enable indentation based on treesitter
    indent = {
      enable = true,
      -- Disable for languages that have issues with treesitter indent
      disable = { "python", "yaml" },
    },

    -- Enable text objects
    textobjects = {
      enable = true,
    },
  },
}
