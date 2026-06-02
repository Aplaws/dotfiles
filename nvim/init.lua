-- ~/.config/nvim/init.lua

-- ========================
-- Leader
-- ========================
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ========================
-- Basic settings
-- ========================
local opt = vim.opt

opt.number = true
opt.relativenumber = true

opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true

opt.wrap = false
opt.scrolloff = 10
opt.sidescrolloff = 8

opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true

opt.splitright = true
opt.splitbelow = true

opt.ignorecase = true
opt.smartcase = true

opt.updatetime = 250
opt.timeoutlen = 400

opt.undofile = true

opt.completeopt = { "menu", "menuone", "noselect" }

-- ========================
-- lazy bootstrap
-- ========================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local uv = vim.uv or vim.loop

if not uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

-- ========================
-- Plugins
-- ========================
require("lazy").setup({
  -- Theme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- Statusline unten
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup({
        options = {
          theme = "auto",
          icons_enabled = false,
          component_separators = "|",
          section_separators = "",
        },
      })
    end,
  },

  -- Zeigt dir mögliche Space-Tasten an
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- Dateien suchen
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local builtin = require("telescope.builtin")

      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-c>"] = actions.close,
            },
            n = {
              ["j"] = actions.move_selection_next,
              ["k"] = actions.move_selection_previous,
              ["q"] = actions.close,
            },
          },
        },
      })

      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Dateien suchen" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Text suchen" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Offene Dateien" })
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Hilfe suchen" })
    end,
  },

  -- LSP configs: Python, Go, C
  {
    "neovim/nvim-lspconfig",
  },

  -- Autocomplete
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },

        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),

          ["<CR>"] = cmp.mapping.confirm({
            select = false,
          }),

          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<C-e>"] = cmp.mapping.abort(),
        }),

        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }),
      })
    end,
  },

  -- Formatieren
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "black" },
        go = { "gofmt" },
        c = { "clang_format" },
        cpp = { "clang_format" },
      },

      format_on_save = {
        timeout_ms = 1000,
        lsp_format = "fallback",
      },

      notify_on_error = true,
      notify_no_formatters = false,
    },
  },

  -- Kommentare schnell ein/aus
  {
    "numToStr/Comment.nvim",
    opts = {},
  },

  -- Klammern automatisch schließen
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({})
    end,
  },
}, {
  performance = {
    rtp = {
      reset = false,
    },
  },
})

-- ========================
-- LSP capabilities for autocomplete
-- ========================
local capabilities = vim.lsp.protocol.make_client_capabilities()

local ok_cmp_lsp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if ok_cmp_lsp then
  capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

vim.lsp.config("*", {
  capabilities = capabilities,
})

-- ========================
-- LSP configs
-- ========================

-- Python
vim.lsp.config("pyright", {
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "basic",
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
      },
    },
  },
})

-- C / C++
vim.lsp.config("clangd", {
  cmd = {
    "clangd",
    "--background-index",
  },
})

-- Enable LSP servers
vim.lsp.enable({
  "pyright",
  "gopls",
  "clangd",
})

-- ========================
-- Diagnostics
-- ========================
vim.diagnostic.config({
  virtual_text = {
    prefix = "●",
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = "if_many",
  },
})

-- ========================
-- LSP keymaps
-- ========================
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local map = function(keys, func, desc)
      vim.keymap.set("n", keys, func, {
        buffer = event.buf,
        desc = "LSP: " .. desc,
      })
    end

    map("gd", vim.lsp.buf.definition, "Zur Definition springen")
    map("gD", vim.lsp.buf.declaration, "Zur Deklaration springen")
    map("gr", vim.lsp.buf.references, "Referenzen anzeigen")
    map("gi", vim.lsp.buf.implementation, "Implementation anzeigen")
    map("K", vim.lsp.buf.hover, "Info anzeigen")

    map("<leader>rn", vim.lsp.buf.rename, "Umbenennen")
    map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
    map("<leader>d", vim.diagnostic.open_float, "Fehler anzeigen")

    map("[d", function()
      vim.diagnostic.jump({ count = -1, float = true })
    end, "Vorheriger Fehler")

    map("]d", function()
      vim.diagnostic.jump({ count = 1, float = true })
    end, "Nächster Fehler")
  end,
})

-- ========================
-- General keymaps
-- ========================
local map = vim.keymap.set

-- Deine gewünschten Tasten
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Speichern" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Beenden" })
map("n", "<leader>Q", "<cmd>qa<CR>", { desc = "Alles beenden" })

-- Formatieren
map("n", "<leader>f", function()
  require("conform").format({
    async = true,
    lsp_format = "fallback",
  })
end, { desc = "Datei formatieren" })

-- Neovim Splits
map("n", "<leader>|", "<cmd>vsplit<CR>", { desc = "Vertikaler Split" })
map("n", "<leader>-", "<cmd>split<CR>", { desc = "Horizontaler Split" })

-- Zwischen Neovim-Splits bewegen
map("n", "<C-h>", "<C-w>h", { desc = "Split links" })
map("n", "<C-j>", "<C-w>j", { desc = "Split unten" })
map("n", "<C-k>", "<C-w>k", { desc = "Split oben" })
map("n", "<C-l>", "<C-w>l", { desc = "Split rechts" })

-- Eingebauter Datei-Explorer
map("n", "<leader>e", "<cmd>Ex<CR>", { desc = "Datei-Explorer" })

-- Suche markieren ausmachen
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Suche entfernen" })
