local vim = vim
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  use {
	  'nvim-telescope/telescope.nvim',
	  requires = { {'nvim-lua/plenary.nvim'} }
  }
  use "NLKNguyen/papercolor-theme"
  use {
	  'nvim-treesitter/nvim-treesitter',
	  run = function()
		  local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
		  ts_update()
	  end
  }
use 'nvim-treesitter/playground'
use {
	'ThePrimeagen/harpoon',
	requires = {{'nvim-lua/plenary.nvim'}}
}
use 'mbbill/undotree'
use 'tpope/vim-fugitive'
use {
	'VonHeikemen/lsp-zero.nvim',
	branch = 'v2.x',
	requires = {
		-- LSP Support
		{'neovim/nvim-lspconfig'},             -- Required
		{                                      -- Optional
		'williamboman/mason.nvim',
		run = function()
			pcall(vim.cmd, 'MasonUpdate')
		end,
	},
	{'williamboman/mason-lspconfig.nvim'}, -- Optional

	-- Autocompletion
	{'hrsh7th/nvim-cmp'},     -- Required
	{'hrsh7th/cmp-nvim-lsp'}, -- Required
	{'L3MON4D3/LuaSnip'},     -- Required
}
}
use 'christoomey/vim-tmux-navigator'
use {
	'lewis6991/gitsigns.nvim',
	config = function()
		require('gitsigns').setup()
	end
}
use {
  "folke/todo-comments.nvim",
  requires = "nvim-lua/plenary.nvim",
  config = function()
    require("todo-comments").setup {}
  end
}

use 'ThePrimeagen/vim-be-good'

use {
    "epwalsh/obsidian.nvim",
    config = function()
      require("obsidian").setup({
        use_advanced_uri = true,
        dir = "~/code/github.com/catdevman/brain/notes",
        daily_notes = {
          folder = "dailies",
        },
        completion = {
          nvim_cmp = true,
        },
        note_id_func = function(title)
          local sane_name = ""
          if title ~= nil then
            -- If title is given, transform it into valid file name.
            sane_name = title:gsub(" ", "_"):gsub("[^A-Za-z0-9-]", ""):lower()
          else
            -- If title is nil, just add 4 random uppercase letters to the suffix.
            for _ in 1, 4 do
              sane_name = sane_name .. string.char(math.random(65, 90))
            end
          end
          return sane_name
        end,
      })
    end,
}
use {
    "folke/zen-mode.nvim",
    opts = {
        window = {
            width = .825
        },
        plugins = {
            gitsigns = { enabled = false },
            tmux = { enabled = false }
        },
    }
}

use {
    'numToStr/Comment.nvim',
    config = function()
        require('Comment').setup()
    end
}
use {
    "ThePrimeagen/vim-be-good"
}
  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
