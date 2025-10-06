-- Kernel documentation and help system
-- Provides quick access to kernel documentation and man pages

---@type LazySpec
return {
  -- Enhanced man page integration for kernel development
  {
    "paretje/nvim-man",
    event = "VeryLazy",
    config = function()
      -- Configure man pages with kernel-specific sections
      vim.g.man_default_sections = "3,2,1,8,5,7,4,6,9" -- Prioritize syscalls and library calls
    end,
    keys = {
      { "<Leader>kh", "<cmd>Man<cr>", desc = "Open man page under cursor" },
      { "<Leader>kH", ":Man ", desc = "Search man pages" },
    },
  },

  -- Markdown preview for kernel documentation
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
    keys = {
      { "<Leader>kp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Toggle markdown preview" },
    },
  },

  -- Enhanced help system
  {
    "anuvyklack/help-vsplit.nvim",
    event = "CmdlineEnter",
    config = function()
      require("help-vsplit").setup()
    end,
  },
}