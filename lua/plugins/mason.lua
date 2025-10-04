-- Customize Mason - LSP servers, formatters, linters, and debuggers

---@type LazySpec
return {
  -- Override astrocommunity.pack.cpp DAP configuration to prevent codelldb conflicts
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = function(_, opts)
      -- Remove codelldb from ensure_installed if astrocommunity added it
      opts.ensure_installed = opts.ensure_installed or {}

      -- Filter out codelldb from the ensure_installed list
      local filtered = {}
      for _, adapter in ipairs(opts.ensure_installed) do
        if adapter ~= "codelldb" then
          table.insert(filtered, adapter)
        end
      end
      opts.ensure_installed = filtered

      -- Also disable automatic installation for codelldb
      opts.automatic_installation = { exclude = { "codelldb" } }

      return opts
    end,
  },

  -- Override astrocommunity.pack.cpp mason-tool-installer to prevent codelldb conflicts
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = function(_, opts)
      -- Remove codelldb from ensure_installed if astrocommunity added it
      opts.ensure_installed = opts.ensure_installed or {}

      -- Filter out codelldb from the ensure_installed list
      local filtered = {}
      for _, tool in ipairs(opts.ensure_installed) do
        if tool ~= "codelldb" then
          table.insert(filtered, tool)
        end
      end
      opts.ensure_installed = filtered

      -- Set other configuration
      opts.auto_update = false
      opts.run_on_start = true

      return opts
    end,
  },

  -- Additional Mason configuration to prevent codelldb installation
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      -- Ensure codelldb is never installed
      opts = opts or {}
      opts.ui = opts.ui or {}
      opts.ui.check_outdated_packages_on_open = false

      -- Add custom registry configuration to ignore codelldb
      opts.registries = {
        "github:mason-org/mason-registry",
      }

      return opts
    end,
  },
}
