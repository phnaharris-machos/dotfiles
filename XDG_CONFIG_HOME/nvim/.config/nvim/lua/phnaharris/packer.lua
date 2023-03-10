local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath("data") ..
        "/site/pack/packer/start/packer.nvim"
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ "git", "clone", "--depth", "1",
            "https://github.com/wbthomason/packer.nvim", install_path })
        vim.cmd.packadd("packer.nvim")
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

local status, packer = pcall(require, "packer")
if (not status) then
    print("Packer is not installed")
    return
end

vim.cmd.packadd("packer.nvim")

-- Auto run :PackerCompile whenever packer.lua is updated
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost packer.lua source <afile> | PackerCompile
  augroup end
]])

packer.startup(function(use)
    use { "wbthomason/packer.nvim",
        config = function()
            bind("n", "<leader>pi", "<cmd>PackerInstall<CR>")
            bind("n", "<leader>pc", "<cmd>PackerClean<CR>")
        end

    }

    use "neovim/nvim-lspconfig" -- LSP
    use {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate"
    }
    use "williamboman/mason.nvim"
    use "williamboman/mason-lspconfig.nvim"
    use "onsails/lspkind-nvim" -- vscode-like pictograms
    use "j-hui/fidget.nvim" -- nvim-lsp progress
    use "saadparwaiz1/cmp_luasnip" -- nvim-cmp source for luasnip
    use "L3MON4D3/LuaSnip"
    use "rafamadriz/friendly-snippets"
    use "jose-elias-alvarez/null-ls.nvim" -- Use Neovim as a language server to inject LSP diagnostics, code actions, and more via Lua

    use "hrsh7th/nvim-cmp" -- Completion
    use "hrsh7th/cmp-buffer" -- nvim-cmp source for buffer words
    use "hrsh7th/cmp-nvim-lsp" -- nvim-cmp source for neovim's built-in LSP

    use "norcalli/nvim-colorizer.lua"
    use "simrat39/rust-tools.nvim"
    use "MrcJkb/haskell-tools.nvim"
    use({
        "iamcco/markdown-preview.nvim",
        run = function() vim.fn["mkdp#util#install"]() end,
        config = function()
            bind("n", "<leader>M", "<cmd>MarkdownPreview<CR>")
            bind("n", "<leader>Ms", "<cmd>MarkdownPreviewStop<CR>")
        end

    })

    use "mfussenegger/nvim-dap" -- Debug Adapter Protocal
    use "mfussenegger/nvim-dap-python" -- Extension for nvim-dap providing default configuration for nvim-dap-python
    use "rcarriga/nvim-dap-ui" -- Better UI for debugging
    use "leoluz/nvim-dap-go" -- DAP for Golang
    use "mxsdev/nvim-dap-vscode-js"
    use {
        "microsoft/vscode-js-debug",
        opt = true,
        run = "npm install --legacy-peer-deps && npm run compile"
    }

    use "rest-nvim/rest.nvim"
    use "lewis6991/gitsigns.nvim"
    use "nvim-lualine/lualine.nvim" -- Statusline
    use "nvim-lua/plenary.nvim" -- Common utilities
    use "kyazdani42/nvim-web-devicons" -- File icons
    -- use 'fgheng/winbar.nvim' -- Only support neovim >= 0.8.*

    -- File browser
    use "nvim-tree/nvim-tree.lua"
    use "nvim-telescope/telescope.nvim"
    use "nvim-telescope/telescope-file-browser.nvim"

    use "windwp/nvim-autopairs"
    use "windwp/nvim-ts-autotag" -- Auto close, rename html tag

    use "tpope/vim-surround"

    -- use "github/copilot.vim"
    -- Commenting
    use "numToStr/Comment.nvim"
    -- use 'JoosepAlviste/nvim-ts-context-commentstring'

    use {
        "nvim-neorg/neorg",
        run = ":Neorg sync-parsers",
        after = "nvim-treesitter", -- You may want to specify Telescope here as well
    }

    use "mbbill/undotree"

    -- Themes
    use {
        "dracula/vim",
        as = "dracula",
        after = "nvim-treesitter",
        config = function()
            vim.cmd.colorscheme("dracula")
        end

    }
    -- use({
    --     "rose-pine/neovim",
    --     as = "rose-pine",
    --     config = function()
    --         vim.cmd("colorscheme rose-pine")
    --     end
    -- })

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require("packer").sync()
    end
end)
