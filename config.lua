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
vim.opt.tabstop = 4       -- A TAB character looks like 4 spaces
vim.opt.shiftwidth = 4

-- ########################
-- ## Key listing
-- ########################
--
lvim.colorscheme = "tokyonight-moon"

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

-- find stuff
lvim.builtin.which_key.mappings["f"] = {
    name = "+Find",
    f = { "<cmd>Telescope find_files<cr>", "Find files" },
    F = { "<cmd>Telescope find_files hidden=true no_ignore=true<cr>", "Find files (all)" },
    t = { "<cmd>TodoTelescope<cr>", "Todo Telescope" },
}


-- ########################
-- ## Building plugins
-- ########################
--
lvim.builtin.nvimtree.setup.actions.open_file.quit_on_open = true; -- avoid closing on opening a file in explorer

-- find hidden files like .env
lvim.builtin.which_key.mappings["sT"] = {
    function()
        require("telescope.builtin").live_grep {
            additional_args = function(args) return vim.list_extend(args, { "--hidden", "--no-ignore" }) end,
        }
    end,
    "Text Everywhere",
}

-- debug here now
lvim.builtin.which_key.mappings["dh"] = {
    function()
        local dap = require("dap")

        -- Add a debug point at the current line (adjust as needed)
        dap.toggle_breakpoint()

        -- Start debugging (adjust configuration and target as needed)
        dap.continue()
    end,
    "Add Debug Point & Start Debugging"
}


-- ########################
-- ## User plugins
-- ########################
--
--
lvim.builtin.treesitter.rainbow.enable = true
lvim.builtin.treesitter.rainbow.extended_mode = true
lvim.plugins = {
    -- NOTE: highlight plugin
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("todo-comments").setup {
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            }
        end
    },
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000
    },
    "pocco81/auto-save.nvim",
    -- NOTE: Debugging
    "mfussenegger/nvim-dap",
    "leoluz/nvim-dap-go",
    "mrjones2014/nvim-ts-rainbow",
}

-- NOTE: Debugging
lvim.builtin.dap.active = true
local dap = require("dap")

dap.adapters.go = function(callback, _)
    local stdout = vim.loop.new_pipe(false)
    local handle
    local pid_or_err
    local port = 38697
    local opts = {
        stdio = { nil, stdout },
        args = { "dap", "-l", "127.0.0.1:" .. port },
        detached = true,
    }
    handle, pid_or_err = vim.loop.spawn("dlv", opts, function(code)
        stdout:close()
        handle:close()
        if code ~= 0 then
            print("dlv exited with code", code)
        end
    end)
    assert(handle, "Error running dlv: " .. tostring(pid_or_err))
    stdout:read_start(function(err, chunk)
        assert(not err, err)
        if chunk then
            vim.schedule(function()
                require("dap.repl").append(chunk)
            end)
        end
    end)
    -- Wait for delve to start
    vim.defer_fn(function()
        callback { type = "server", host = "127.0.0.1", port = port }
    end, 100)
end
-- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
dap.configurations.go = {
    {
        type = "go",
        name = "Debug",
        request = "launch",
        program = "${file}",
    },
    -- {
    --   type = "go",
    --   name = "Debug test",   -- configuration for debugging test files
    --   request = "launch",
    --   mode = "test",
    --   program = "${file}",
    -- },
    -- -- works with go.mod packages and sub packages
    -- {
    --   type = "go",
    --   name = "Debug test (go.mod)",
    --   request = "launch",
    --   mode = "test",
    --   program = "./${relativeFileDirname}",
    -- },
}
