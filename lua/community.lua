-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",

  -- Language packs
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.cpp" },
  { import = "astrocommunity.pack.rust" },

  -- Enhanced search and navigation
  { import = "astrocommunity.motion.leap-nvim" }, -- Enhanced motion and navigation plugin
  -- telescope-fzf-native not available in astrocommunity, added manually in plugins/

  -- Enhanced git workflow
  { import = "astrocommunity.git.diffview-nvim" }, -- Better diff viewing and git file history
  { import = "astrocommunity.git.blame-nvim" }, -- Git blame integration
  { import = "astrocommunity.git.octo-nvim" }, -- GitHub integration

  -- Productivity and utility tools
  { import = "astrocommunity.register.nvim-neoclip-lua" }, -- Clipboard manager
  { import = "astrocommunity.quickfix.nvim-bqf" }, -- Better quickfix

  -- import/override with your plugins folder
}
