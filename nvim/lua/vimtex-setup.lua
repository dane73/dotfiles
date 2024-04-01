local function config()
  vim.g.vimtex_view_method = 'zathura'
  vim.g.vimtex_view_forward_search_on_start = true
  vim.g.vimtex_view_general_options = '--fork --syntex-forward'
end

return {config = config}
