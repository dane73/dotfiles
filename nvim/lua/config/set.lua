
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.cursorline = true

vim.opt.mouse = ""

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

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
