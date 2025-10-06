return {
  "folke/which-key.nvim",
  opts = {
    -- Fix for fast typing issues
    delay = 200, -- Delay before which-key popup appears (ms)
    timeout = true, -- Enable timeout
    timeoutlen = 500, -- Time to wait for next key in sequence (ms)

    -- Better performance for fast typing
    preset = "modern", -- Use modern preset for better performance
  },
}