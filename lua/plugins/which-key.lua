return {
  "folke/which-key.nvim",
  opts = {
    -- Fix for fast typing issues
    delay = 200, -- Delay before which-key popup appears (ms)
    timeout = true, -- Enable timeout
    timeoutlen = 500, -- Time to wait for next key in sequence (ms)

    -- Use modern preset for better styling
    preset = "modern",

    -- Enable built-in plugins to show Vim's native keybindings
    -- These provide help for existing Vim functionality without creating new bindings
    plugins = {
      marks = true, -- shows marks on ' and `
      registers = true, -- shows registers on " in NORMAL or <C-r> in INSERT
      spelling = {
        enabled = true, -- show WhichKey when pressing z= for spelling suggestions
        suggestions = 20, -- number of suggestions to show
      },
      presets = {
        operators = true, -- help for operators like d, y, gq, gu, gU, etc.
        motions = true, -- help for motions
        text_objects = true, -- help for text objects after entering an operator
        windows = true, -- default bindings on <c-w>
        nav = true, -- misc bindings to work with windows
        z = true, -- bindings for folds, spelling, etc. prefixed with z
        g = true, -- bindings prefixed with g (includes gq, gu, gU, gw, etc.)
      },
    },

    -- WORKAROUND: plugins.presets doesn't fully work in v3 for visual mode operators
    -- Manually add specs for built-in Vim operators (no new keymaps, just descriptions)
    spec = {
      -- Visual mode g-prefix operators
      { "gq", desc = "Format/reflow lines", mode = "v" },
      { "gu", desc = "Lowercase", mode = "v" },
      { "gU", desc = "Uppercase", mode = "v" },
      { "g~", desc = "Toggle case", mode = "v" },
      { "gw", desc = "Format lines (keep cursor)", mode = "v" },
      { "gJ", desc = "Join without spaces", mode = "v" },
    },
  },
}