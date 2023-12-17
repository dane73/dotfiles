-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require('lazy-bootstrap')
require('lazy-setup')
require('vimtex-setup').config()

require('colorschemes')

vim.cmd[[colorscheme onedark]]

require('options')
require('keymaps')
require('telescope-setup')
require('treesitter-setup')
require('lsp-setup')
require('cmp-setup')
require("oil").setup()

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
