require("config.keymaps")

local map = vim.keymap.set

-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
local path_package = vim.fn.stdpath("data") .. "/site/"
local mini_path = path_package .. "pack/deps/start/mini.nvim"
if not vim.uv.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/echasnovski/mini.nvim",
    mini_path,
  }
  vim.fn.system(clone_cmd)
  vim.cmd("packadd mini.nvim | helptags ALL")
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

-- Set up 'mini.deps' (customize to your liking)
require("mini.deps").setup({ path = { package = path_package } })

-- Use 'mini.deps'. `now()` and `later()` are helpers for a safe two-stage
-- startup and are optional.
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- Safely execute immediately

-- color scheme
now(function()
  vim.o.termguicolors = true
  if not vim.o.background then
    vim.o.background = "light"
  end
  add("sainnhe/everforest")
  vim.cmd("colorscheme everforest")
  map("n", "<leader>hrT", function()
    if vim.o.background == "light" then
      vim.o.background = "dark"
    elseif vim.o.background == "dark" then
      vim.o.background = "light"
    end
  end)
end)

now(function()
  local notify = require("mini.notify")
  notify.setup()
  map("n", "<leader>nh", function()
    notify.show_history()
  end)

  vim.notify = require("mini.notify").make_notify()
end)
now(function()
  require("mini.icons").setup()
end)
now(function()
  require("mini.tabline").setup()
end)
now(function()
  require("mini.statusline").setup({ use_icons = true })
end)

now(function()
  add({ source = "ibhagwan/fzf-lua", depends = { "nvim-tree/nvim-web-devicons" } })
  local fzf_lua = require("fzf-lua")
  map("n", "<leader><leader>", function()
    fzf_lua.files({
      cmd = "fd --type f --hidden --exclude .git --exclude node_modules --exclude .venv",
    })
  end)
  map("n", "<leader>sb", function()
    fzf_lua.builtin()
  end)
  map("n", "<C-s>", function()
    fzf_lua.grep_curbuf()
  end)
  map("n", "<leader>pG", function()
    fzf_lua.live_grep()
  end)
end)

now(function()
  local miniclue = require("mini.clue")
  miniclue.setup({
    triggers = {
      -- Leader triggers
      { mode = "n", keys = "<Leader>" },
      { mode = "x", keys = "<Leader>" },

      -- Built-in completion
      { mode = "i", keys = "<C-x>" },

      -- `g` key
      { mode = "n", keys = "g" },
      { mode = "x", keys = "g" },

      -- Marks
      { mode = "n", keys = "'" },
      { mode = "n", keys = "`" },
      { mode = "x", keys = "'" },
      { mode = "x", keys = "`" },

      -- Registers
      { mode = "n", keys = '"' },
      { mode = "x", keys = '"' },
      { mode = "i", keys = "<C-r>" },
      { mode = "c", keys = "<C-r>" },

      -- Window commands
      { mode = "n", keys = "<C-w>" },

      -- `z` key
      { mode = "n", keys = "z" },
      { mode = "x", keys = "z" },
    },

    clues = {

      -- Enhance this by adding descriptions for <Leader> mapping groups
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.windows(),
      miniclue.gen_clues.z(),
    },
  })
end)

-- comment
later(function()
  require("mini.comment").setup()
  require("mini.pick").setup()
  require("mini.pairs").setup()
  require("mini.surround").setup({
    mappings = {
      add = "S", -- matching doom emacs
      delete = "ds", -- matching doom emacs
      find = "sf", -- Find surrounding (to the right)
      find_left = "sF", -- Find surrounding (to the left)
      highlight = "sh", -- Highlight surrounding
      replace = "cs", -- matching doom emacs
      update_n_lines = "sn", -- Update `n_lines`

      suffix_last = "l", -- Suffix to search with "prev" method
      suffix_next = "n", -- Suffix to search with "next" method
    },
  })
end)

now(function()
  -- Use other plugins with `add()`. It ensures plugin is available in current
  -- session (installs if absent)

  add({
    source = "neovim/nvim-lspconfig",
    -- Supply dependencies near target plugin
    depends = {
      "williamboman/mason.nvim",
      "folke/lazydev.nvim",
      {
        source = "saghen/blink.cmp",
        depends = { "rafamadriz/friendly-snippets" },
        checkout = "v0.8.0", -- required to properly download prebuilt binary
      },
    },
  })

  require("blink.cmp").setup({
    keymap = { preset = "enter" },
    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = "mono",
    },
    signature = { enabled = true },
  })

  require("mason").setup()

  ---@diagnostic disable-next-line: missing-fields
  require("lazydev").setup({
    library = {
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    },
  })

  local lspconfig = require("lspconfig")

  local servers = {
    lua_ls = {},
    basedpyright = {},
    ruff = {},
  }

  for server, config in pairs(servers) do
    config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
    lspconfig[server].setup(config)
  end

  map("n", "gd", "<C-]>")
end)

later(function()
  add({
    source = "nvim-treesitter/nvim-treesitter",
    -- Use 'master' while monitoring updates in 'main'
    checkout = "master",
    monitor = "main",
    -- Perform action after every checkout
    hooks = {
      post_checkout = function()
        vim.cmd("TSUpdate")
      end,
    },
  })
  -- Possible to immediately execute code which depends on the added plugin
  ---@diagnostic disable-next-line: missing-fields
  require("nvim-treesitter.configs").setup({
    ensure_installed = { "lua", "vimdoc", "python", "go" },
    highlight = { enable = true },
  })
end)

-- formatting
now(function()
  add("stevearc/conform.nvim")
  require("conform").setup({
    formatters_by_ft = {
      lua = { "stylua" },
      -- Conform will run multiple formatters sequentially
      python = { "ruff format", lsp_format = "fallback" },
      -- You can customize some of the format options for the filetype (:help conform.format)
      rust = { "rustfmt", lsp_format = "fallback" },
      -- Conform will run the first available formatter
      javascript = { "prettierd", "prettier", stop_after_first = true },
    },
    format_on_save = {
      -- These options will be passed to conform.format()
      timeout_ms = 500,
      lsp_format = "fallback",
    },
  })
end)

-- flash.nvim, avy in emacs replacement
now(function()
  -- TODO explore additional functionality
  add("folke/flash.nvim")
  local flash = require("flash")

  map("n", "gs/", function()
    flash.jump()
  end)
end)

-- neogit
now(function()
  vim.api.nvim_create_user_command("Emacs", function()
    vim.cmd("terminal emacsclient -nw")
  end, {})

  add({
    source = "NeogitOrg/neogit",
    depends = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
    },
  })
  local neogit = require("neogit")
  neogit.setup({
    process_spinner = false, -- caused by zellij somehow
  })
  map("n", "<leader>gg", function()
    neogit.open()
  end)
end)

-- octo.nvim
now(function()
  add({
    source = "pwntester/octo.nvim",
    depends = { "nvim-lua/plenary.nvim" },
  })
  local octo = require("octo")

  octo.setup({
    picker = "fzf-lua",
  })
end)
