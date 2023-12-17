
-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

--markdown preview
vim.keymap.set('n', '<leader>mp', '<cmd>MarkdownPreview<CR>', {desc = 'Markdown Preview'})

-- more keymaps
vim.keymap.set('n', '<leader>x', vim.cmd.Ex, {desc = 'Explore'})
vim.keymap.set('n', '<leader>nc', '<cmd>e $HOME/.config/nvim<CR>')
vim.keymap.set('n', '<leader>nl', '<cmd>e $HOME/.config/nvim/lua/lazy-setup.lua<CR>')

require('which-key').register {
  ['<leader>n'] = { name = '[N]eovim Configurations', _ = 'which_key_ignore' },
  ['<leader>l'] = { name = '[L]atex', _ = 'which_key_ignore' },
  ['<leader>m'] = { name = '[M]arkdown', _ = 'which_key_ignore' }
}


-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})
