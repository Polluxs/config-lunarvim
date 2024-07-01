-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny
--
--
--
vim.opt.cmdheight = 0;    -- avoid excessive commandline space at bottom
vim.opt.timeoutlen = 500; -- either I know the keyboard shortcut, or I need to look


-- ########################
-- ## Key listing
-- ########################
--
lvim.builtin.which_key.mappings["t"] = {
  name = "+Terminal",
  f = { "<cmd>ToggleTerm<cr>", "Floating terminal" },
  v = { "<cmd>2ToggleTerm size=30 digection=vertical<cr>", "Split vertical" },
  h = { "<cmd>2ToggleTerm size=30 direction=horizontal<cr>", "Split horizontal" },
}

-- Todo listing
lvim.builtin.which_key.mappings["T"] = {
  name = "+Todo",
  t = { "<cmd>TodoTelescope<cr>", "Todo Telescope" },
  f = { "<cmd>TodoTelescope keywords=TODO,FIX<cr>", "Find TODO/FIX" },
  c = { "<cmd>TodoTelescope cwd=~/projects/foobar<cr>", "Search in foobar directory" },
  q = { "<cmd>TodoQuickFix<cr>", "Todo QuickFix" },
  l = { "<cmd>TodoLocList<cr>", "Todo LocList" },
  r = { "<cmd>Trouble todo<cr>", "Todo Trouble" }
}


-- ########################
-- ## Building plugins
-- ########################
--
lvim.builtin.nvimtree.setup.actions.open_file.quit_on_open = true; -- avoid closing on opening a file in explorer

-- find hidden files like .env
lvim.builtin.which_key.mappings["sf"] = { "<cmd>Telescope find_files hidden=true no_ignore=true<cr>",
  "Find File" }
lvim.builtin.which_key.mappings["sF"] = { "<cmd>Telescope find_files hidden=true no_ignore=true<cr>",
  "Find File Everywhere" }
lvim.builtin.which_key.mappings["sT"] = {
  function()
    require("telescope.builtin").live_grep {
      additional_args = function(args) return vim.list_extend(args, { "--hidden", "--no-ignore" }) end,
    }
  end,
  "Text Everywhere",
}

-- ########################
-- ## User plugins
-- ########################
--
lvim.plugins = {
  -- this plugin highlights todos & fixme etc
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  }
}

