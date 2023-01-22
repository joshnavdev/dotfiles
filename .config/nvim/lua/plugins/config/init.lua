local M = {}

M.plugins_init = function(packer_bootstrap)
  return function (use)
    use "wbthomason/packer.nvim" -- To use packer

    use {
      "themercorp/themer.lua",
      config = function ()
        require "plugins.config.themer"
      end,
    }

    use {
      "nvim-treesitter/nvim-treesitter", -- highlights
      module = "nvim-treesitter",
      cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSEnable", "TSDisable", "TSModuleInfo" },
      run = ":TSUpdate",
      config = function ()
        require "plugins.config.treesitter"
      end,
    }

    use {
      "windwp/nvim-autopairs", -- autocompletation pairs
      config = function ()
        require "plugins.config.autopairs"
      end,
    }

    -- use { 
    --   "windwp/nvim-ts-autotag", -- autocompletation tag 
    --   config = function ()
    --     require "plugins.config.ts-autotag"
    --   end
    -- }

    use {
      "hoob3rt/lualine.nvim", -- Statusline
      config = function ()
        require "plugins.config.lualine"
      end,
    }

    use {
      "kyazdani42/nvim-web-devicons", -- File icons
      config = function ()
        require "plugins.config.web-devicons"
      end,
    }

    use {
      "alexghergh/nvim-tmux-navigation", -- Navigate between windows
      config = function ()
        require "plugins.config.tmux-navigation"
      end,
    }

    use {
      "nvim-telescope/telescope.nvim", -- Telescope with file browser
      requires = { { "nvim-lua/plenary.nvim" }, { "nvim-telescope/telescope-file-browser.nvim" } },
      config = function ()
        require "plugins.config.telescope"
      end,
    }

    use {
      "akinsho/nvim-bufferline.lua", -- tabs
      tag = "v3.*",
      requires = "kyazdani42/nvim-web-devicons",
      config = function ()
        require "plugins.config.bufferline"
      end,
    }

    use {
      "terrortylor/nvim-comment", -- commenter
      config = function ()
        require "plugins.config.comment"
      end,
    }

    use {
      "lukas-reineke/indent-blankline.nvim",
      config = function ()
        require "plugins.config.indent-blankline"
      end
    }

    -- LSP configuration and more
    use { "hrsh7th/cmp-nvim-lsp" } -- LSP source for nvim-cmp

    use { "b0o/schemastore.nvim" } -- json schemas to use with lspconfig

    use {
      "neovim/nvim-lspconfig",
      after = { "cmp-nvim-lsp", "schemastore.nvim" },
      config = function ()
        require "plugins.config.lspconfig"
      end,
    }

    use { "L3MON4D3/LuaSnip" } -- Snippets plugin 

    use {
      "onsails/lspkind-nvim", -- vscoder-like pictograms
      config = function ()
        require "plugins.config.lspkind"
      end,
    }

    use {
      "hrsh7th/nvim-cmp", -- Autocompletion plugin
      after = { "nvim-lspconfig", "LuaSnip", "lspkind-nvim" },
      config = function ()
        require "plugins.config.cmp"
      end,
    }

    use {
      "saadparwaiz1/cmp_luasnip", -- Snippets source for nvim-cmp
    }

    use { "williamboman/mason.nvim" }

    use {
      "williamboman/mason-lspconfig.nvim",
      after = "mason.nvim",
      config = function ()
        require "plugins.config.mason"
      end,
    }

    use {
      "joshuanr5/lspsaga.nvim", -- LSP UIs
      branch = "legacy",
      config = function ()
        require "plugins.config.lspsaga"
      end,
    }

    use {
      "jose-elias-alvarez/null-ls.nvim", -- eslint linter
      requires = { "nvim-lua/plenary.nvim" },
      config = function ()
        -- TODO: slint_d install
        require "plugins.config.null-ls"
      end,
    }


    -- use {
    --   "MunifTanjim/prettier.nvim", -- prettier formatting
    --   config = function ()
    --     -- TODO: Validate prettier installation
    --     require "plugins.config.prettier"
    --   end,
    -- }


    use {
      "lewis6991/gitsigns.nvim", -- git change ui 
      config = function ()
        require "plugins.config.gitsigns"
      end,
    }

    use {
      "NvChad/nvterm", -- terminal
      config = function ()
        require "plugins.config.terminal"
      end,
    }

    -- use "EdenEast/nightfox.nvim" -- Good themes
    -- use "dinhhuy258/git.nvim" -- fork git blame & browser
    -- use "tpope/vim-fugitive"
    -- use "f-person/auto-dark-mode.nvim" -- change automaticaly themes for macOS theme mode
    -- use { "sindrets/diffview.nvim", requires = "nvim-lua/plenary.nvim" } -- Single tabpage interface for easily cycling through diffs for all modified files for any git rev.

    -- Local plugins
    use { "joshnavdev/jestjs.nvim",
      config = function ()
        require "plugins.config.jestjs"
      end,
    }

    use {
       "joshnavdev/indentation-multiline.nvim",
       config = function ()
         require "plugins.config.indentation-multiline"
       end,
     }

    -- use "/Users/joshua.navarro/workplace/projects/nvim/plugins/jestjs.nvim"
    -- use "/Users/joshua.navarro/workplace/projects/nvim/plugins/indentation-multiline.nvim"

    if packer_bootstrap then
      require("packer").sync()

      vim.api.nvim_create_autocmd("User", {
        pattern = "PackerComplete",
        callback = function ()
          print('Packer has been complete')
        end
      })
    end
  end
end

return M
