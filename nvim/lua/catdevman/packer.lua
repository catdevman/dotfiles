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

use {
  "epwalsh/obsidian.nvim",
  lazy = true,
  event = { "BufReadPre path/to/my-vault/**.md" },
  -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand':
  -- event = { "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp",
    "nvim-telescope/telescope.nvim",
    "godlygeek/tabular",
    "preservim/vim-markdown",
  },
  opts = {
    dir = "~/Documents/Zettelkasten",  -- no need to call 'vim.fn.expand' here

    -- Optional, if you keep notes in a specific subdirectory of your vault.
    notes_subdir = "Notes",

    -- Optional, if you keep daily notes in a separate directory.
    daily_notes = {
      folder = "Notes/dailies",
    },

    -- Optional, completion.
    completion = {
      nvim_cmp = true,  -- if using nvim-cmp, otherwise set to false
    },

    -- Optional, customize how names/IDs for new notes are created.
    note_id_func = function(title)
      -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
      -- In this case a note with the title 'My new note' will given an ID that looks
      -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
      local suffix = ""
      if title ~= nil then
        -- If title is given, transform it into valid file name.
        suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
      else
        -- If title is nil, just add 4 random uppercase letters to the suffix.
        for _ = 1, 4 do
          suffix = suffix .. string.char(math.random(65, 90))
        end
      end
      return tostring(os.time()) .. "-" .. suffix
    end,

    -- Optional, set to true if you don't want Obsidian to manage frontmatter.
    disable_frontmatter = false,

    -- Optional, alternatively you can customize the frontmatter data.
    note_frontmatter_func = function(note)
      -- This is equivalent to the default frontmatter function.
      local out = { id = note.id, aliases = note.aliases, tags = note.tags }
      -- `note.metadata` contains any manually added fields in the frontmatter.
      -- So here we just make sure those fields are kept in the frontmatter.
      if note.metadata ~= nil and require("obsidian").util.table_length(note.metadata) > 0 then
        for k, v in pairs(note.metadata) do
          out[k] = v
        end
      end
      return out
    end,

    -- Optional, for templates (see below).
    templates = {
      subdir = "templates",
      date_format = "%Y-%m-%d-%a",
      time_format = "%H:%M",
    },

    -- Optional, by default when you use `:ObsidianFollowLink` on a link to an external
    -- URL it will be ignored but you can customize this behavior here.
    follow_url_func = function(url)
      -- Open the URL in the default web browser.
      vim.fn.jobstart({"open", url})  -- Mac OS
      -- vim.fn.jobstart({"xdg-open", url})  -- linux
    end,

    -- Optional, set to true if you use the Obsidian Advanced URI plugin.
    -- https://github.com/Vinzent03/obsidian-advanced-uri
    use_advanced_uri = true,

    -- Optional, set to true to force ':ObsidianOpen' to bring the app to the foreground.
    open_app_foreground = false,

    finder = "telescope.nvim",
  },
  config = function(_, opts)
    require("obsidian").setup(opts)

    -- Optional, override the 'gf' keymap to utilize Obsidian's search functionality.
    -- see also: 'follow_url_func' config option above.
    vim.keymap.set("n", "gf", function()
      if require("obsidian").util.cursor_on_markdown_link() then
        return "<cmd>ObsidianFollowLink<CR>"
      else
        return "gf"
      end
    end, { noremap = false, expr = true })
  end,
}
  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
