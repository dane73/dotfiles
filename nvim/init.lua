-- settings
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.winborder = "rounded"
vim.opt.mouse = "n"
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.scrolloff = 8
vim.opt.colorcolumn = "80,100"
vim.opt.signcolumn = "yes"

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- add `Config` command
vim.api.nvim_create_user_command("Config", function()
    vim.cmd("edit " .. vim.fn.stdpath("config") .. "/init.lua")
end, { desc = "Open neovim config" })

-- keymaps
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>x", vim.cmd.Ex)
-- vim.keymap.set("n", "<leader>w", vim.cmd.write)
vim.keymap.set("n", "<C-d", "<C-d>zz")
vim.keymap.set("n", "<C-u", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")
vim.keymap.set("n", "<leader>Y", "\"+Y")
vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<space>", '<Nop>', { silent = true })
vim.keymap.set("n", "<leader>f", function()
    vim.lsp.buf.format()
end)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open diagnostic message' })

-- lsp config
vim.lsp.config['luals'] = {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_markers = { '.luarc.json', '.luarc.jsonc', '.git' },
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true)
            }
        }
    }
}
local root_markers_python = {
    'pyproject.toml',
    'setup.py',
    'setup.cfg',
    'requirements.txt',
    'Pipfile',
    'pyrightconfig.json',
    '.git',
}
vim.lsp.config['basedpyright'] = {
    cmd = { 'basedpyright-langserver', '--stdio' },
    filetypes = { 'python' },
    root_markers = root_markers_python,
    settings = {
        basedpyright = {
            analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = 'openFilesOnly',
                diasbleOrganizeImports = true,
            },
        },
    },
}
vim.lsp.config['ruff'] = {
    cmd = { 'ruff', 'server' },
    filetypes = { 'python' },
    root_markers = root_markers_python,
    settings = {}
}
---@brief
---
--- https://clangd.llvm.org/installation.html
---
--- - **NOTE:** Clang >= 11 is recommended! See [#23](https://github.com/neovim/nvim-lspconfig/issues/23).
--- - If `compile_commands.json` lives in a build directory, you should
---   symlink it to the root of your source tree.
---   ```
---   ln -s /path/to/myproject/build/compile_commands.json /path/to/myproject/
---   ```
--- - clangd relies on a [JSON compilation database](https://clang.llvm.org/docs/JSONCompilationDatabase.html)
---   specified as compile_commands.json, see https://clangd.llvm.org/installation#compile_commandsjson

-- https://clangd.llvm.org/extensions.html#switch-between-sourceheader
local function switch_source_header(bufnr, client)
    local method_name = 'textDocument/switchSourceHeader'
    ---@diagnostic disable-next-line:param-type-mismatch
    if not client or not client:supports_method(method_name) then
        return vim.notify(('method %s is not supported by any servers active on the current buffer'):format(method_name))
    end
    local params = vim.lsp.util.make_text_document_params(bufnr)
    ---@diagnostic disable-next-line:param-type-mismatch
    client:request(method_name, params, function(err, result)
        if err then
            error(tostring(err))
        end
        if not result then
            vim.notify('corresponding file cannot be determined')
            return
        end
        vim.cmd.edit(vim.uri_to_fname(result))
    end, bufnr)
end

local function symbol_info(bufnr, client)
    local method_name = 'textDocument/symbolInfo'
    ---@diagnostic disable-next-line:param-type-mismatch
    if not client or not client:supports_method(method_name) then
        return vim.notify('Clangd client not found', vim.log.levels.ERROR)
    end
    local win = vim.api.nvim_get_current_win()
    local params = vim.lsp.util.make_position_params(win, client.offset_encoding)
    ---@diagnostic disable-next-line:param-type-mismatch
    client:request(method_name, params, function(err, res)
        if err or #res == 0 then
            -- Clangd always returns an error, there is no reason to parse it
            return
        end
        local container = string.format('container: %s', res[1].containerName) ---@type string
        local name = string.format('name: %s', res[1].name) ---@type string
        vim.lsp.util.open_floating_preview({ name, container }, '', {
            height = 2,
            width = math.max(string.len(name), string.len(container)),
            focusable = false,
            focus = false,
            title = 'Symbol Info',
        })
    end, bufnr)
end

---@class ClangdInitializeResult: lsp.InitializeResult
---@field offsetEncoding? string

vim.lsp.config['clangd'] = {
    cmd = { 'clangd' },
    filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
    root_markers = {
        '.clangd',
        '.clang-tidy',
        '.clang-format',
        'compile_commands.json',
        'compile_flags.txt',
        'configure.ac', -- AutoTools
        '.git',
    },
    capabilities = {
        textDocument = {
            completion = {
                editsNearCursor = true,
            },
        },
        offsetEncoding = { 'utf-8', 'utf-16' },
    },
    ---@param init_result ClangdInitializeResult
    on_init = function(client, init_result)
        if init_result.offsetEncoding then
            client.offset_encoding = init_result.offsetEncoding
        end
    end,
    on_attach = function(client, bufnr)
        vim.api.nvim_buf_create_user_command(bufnr, 'LspClangdSwitchSourceHeader', function()
            switch_source_header(bufnr, client)
        end, { desc = 'Switch between source/header' })

        vim.api.nvim_buf_create_user_command(bufnr, 'LspClangdShowSymbolInfo', function()
            symbol_info(bufnr, client)
        end, { desc = 'Show symbol info' })
    end,
}
vim.lsp.enable({ 'luals', 'basedpyright', 'ruff', 'clangd' })
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup('lsp_attach_disable_ruff_hover', { clear = true }),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client == nil then
            return
        end
        if client.name == 'ruff' then
            -- Disable hover in favor of Pyright
            client.server_capabilities.hoverProvider = false
        end
    end,
    desc = 'LSP: Disable hover capability from Ruff',
})

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- plugins
require("lazy").setup({
    { "f-person/auto-dark-mode.nvim",    priority = 1000 },
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
    },
    { "nvim-treesitter/nvim-treesitter", branch = 'master',   lazy = false,                              build = ":TSUpdate" },
    { 'lewis6991/gitsigns.nvim', },
    { 'ThePrimeagen/harpoon',            branch = 'harpoon2', dependencies = { "nvim-lua/plenary.nvim" } },
})



-- themes
local lightthemes = {
    "default",
    "delek",
    "morning",
    "peachpuff",
    "shine",
    "tokyonight-day",
    "zellner",
}

local darkthemes = {
    "default",
    "desert",
    "elflord",
    "evening",
    "habamax",
    "industry",
    "koehler",
    "murphy",
    "ron",
    "slate", -- hover nicht gut lesbar
    "sorbet",
    "tokyonight-night",
    "tokyonight-storm",
    "tokyonight-moon",
    "torte",
    "unokai",
    "wildcharm", -- gut
    "zaibatsu",
}

math.randomseed(os.time())
local function pick_random(list)
    return list[math.random(#list)]
end

require("auto-dark-mode").setup({
    set_dark_mode = function()
        vim.api.nvim_set_option_value("background", "dark", {})
        vim.cmd.colorscheme(pick_random(darkthemes))
        print("Colorscheme: " .. vim.g.colors_name)
    end,
    set_light_mode = function()
        vim.api.nvim_set_option_value("background", "light", {})
        vim.cmd.colorscheme(pick_random(lightthemes))
        print("Colorscheme: " .. vim.g.colors_name)
    end,
})


require("nvim-treesitter.configs").setup({
    auto_install = true,
    highlight = {
        enable = true,
    },
})

require("gitsigns").setup({
    signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '-' },
        topdelete = { text = '-' },
        changedelete = { text = '~' },
        untracked = { text = '?' },
    },
})
require('harpoon'):setup()

-- plugin keymaps
local harpoon = require('harpoon')
vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<C-j>", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<C-k>", function() harpoon:list():select(3) end)
