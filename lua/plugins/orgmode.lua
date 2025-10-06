return {
  "nvim-orgmode/orgmode",
  event = "VeryLazy",
  ft = { "org" },
  config = function()
    -- Setup orgmode
    require("orgmode").setup {
      org_agenda_files = "~/orgfiles/**/*",
      org_default_notes_file = "~/orgfiles/refile.org",

      -- UI improvements for popups
      win_border = "rounded", -- Pretty rounded borders
      win_split_mode = { "float", 0.8 }, -- Floating window at 80% size

      -- Keybindings for capture popup
      mappings = {
        capture = {
          org_capture_finalize = "<Esc>", -- Save and close capture with ESC
          org_capture_kill = "<C-c>", -- Discard capture with Ctrl-C if needed
        },
      },

      -- Capture templates for quick intake
      org_capture_templates = {
        t = {
          description = "Task",
          template = "* TODO %?\n  SCHEDULED: %t",
          target = "~/orgfiles/refile.org",
        },
        n = {
          description = "Note",
          template = "* %?\n  %u",
          target = "~/orgfiles/refile.org",
        },
        i = {
          description = "Inbox/Idea",
          template = "* %?\n  %u\n  %a",
          target = "~/orgfiles/inbox.org",
        },
        j = {
          description = "Journal",
          template = "* %<%Y-%m-%d %A>\n** %?",
          target = "~/orgfiles/journal.org",
        },
      },
    }
  end,
  dependencies = {
    {
      "AstroNvim/astrocore",
      opts = {
        mappings = {
          n = {
            -- Org mode menu
            ["<Leader>o"] = { desc = "󱉯 Org Mode" },
            -- Org agenda
            ["<Leader>oa"] = {
              function()
                require("orgmode").action("agenda.prompt")
              end,
              desc = "Open agenda"
            },
            -- Org capture (simple working version)
            ["<Leader>oc"] = {
              function()
                require("orgmode").action("capture.prompt")
              end,
              desc = "📝 Capture (shows template menu)"
            },
          },
        },
      },
    },
  },
}