-- You can also add or configure plugins by creating files in this `plugins/` folder
-- PLEASE REMOVE THE EXAMPLES YOU HAVE NO INTEREST IN BEFORE ENABLING THIS FILE
-- Here are some examples:

---@type LazySpec
return {
{
  "lambdalisue/vim-suda",
  cmd = { "SudaRead", "SudaWrite" },
  keys = {
    { "<Leader>kw", "<cmd>SudaWrite<cr>", desc = "Sudo write current file" },
  },
  init = function()
  end,
},
-- {
--  "ludovicchabant/vim-gutentags",
--  event = "BufRead",
--},
--
---- Gutentags_plus plugin for external tags integration
--{
--  "skywind3000/gutentags_plus",
--  event = "BufRead",
--},

-- Override neoclip configuration from astrocommunity
{
  "AckslD/nvim-neoclip.lua",
  opts = {
    history = 100000,
    enable_persistent_history = true,
    continuous_sync = true,
    preview = true,
  },
},

}
