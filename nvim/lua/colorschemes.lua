
local time = os.date("*t")

local timebased = false

if (time.hour < 8 or time.hour > 16) or not timebased then
  vim.o.background = "dark"
else
  vim.o.background = "light"
end

require("onedark").setup({
  transparent =true
  }
)
require("onedark").load()

require("solarized-osaka").setup({
  -- your configuration comes here
  -- or leave it empty to use the default settings
  transparent = (vim.o.background == "dark") and true or false, -- Enable this to disable setting the background color
  terminal_colors = true, -- Configure the colors used when opening a `:terminal` in [Neovim](https://github.com/neovim/neovim)
  styles = {
    -- Style to be applied to different syntax groups
    -- Value is any valid attr-list value for `:help nvim_set_hl`
    comments = { italic = true },
    keywords = { italic = false },
    functions = {},
    variables = {},
    -- Background styles. Can be "dark", "transparent" or "normal"
    sidebars = "dark", -- style for sidebars, see below
    floats = "dark", -- style for floating windows
  },
  sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
  day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
  hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
  dim_inactive = false, -- dims inactive windows
  lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold

  --- You can override specific color groups to use other groups or a hex color
  --- function will be called with a ColorScheme table
  ---@param colors ColorScheme
  on_colors = function(colors) end,

  --- You can override specific highlights to use other groups or a hex color
  --- function will be called with a Highlights and ColorScheme table
  ---@param highlights Highlights
  ---@param colors ColorScheme
  on_highlights = function(highlights, colors) end,
})

local gruvbox = require("gruvbox")

local function setupGruvbox()
  if vim.o.bg == "light" then
    gruvbox.setup({
      terminal_colors = true
    })
  else
    gruvbox.setup({
      strikethrough = true,
      transparent_mode = true,
      contrast = "hard",
      palette_overrides = {dark0_hard = "#0E1018"},
      overrides = {
        -- Comment = {fg = "#626A73", italic = true, bold = true},
        -- #736B62,  #626273, #627273 
        Comment = {fg = "#81878f", italic = true, bold = true},
        Define = {link = "GruvboxPurple"},
        Macro = {link = "GruvboxPurple"},
        ["@constant.builtin"] = {link = "GruvboxPurple"},
        ["@storageclass.lifetime"] = {link = "GruvboxAqua"},
        ["@text.note"] = {link = "TODO"},
        ["@namespace.latex"] = {link = "Include"},
        ["@namespace.rust"] = {link = "Include"},
        ContextVt = {fg = "#878788"},
        CopilotSuggestion = {fg = "#878787"},
        CocCodeLens = {fg = "#878787"},
        CocWarningFloat = {fg = "#dfaf87"},
        CocInlayHint = {fg = "#ABB0B6"},
        CocPumShortcut = {fg = "#fe8019"},
        CocPumDetail = {fg = "#fe8019"},
        DiagnosticVirtualTextWarn = {fg = "#dfaf87"},
        -- fold
        Folded = {fg = "#fe8019", bg = "#3c3836", italic = true},
        FoldColumn = {fg = "#fe8019", bg = "#0E1018"},
        --SignColumn = {bg = "#fe8019"},
        -- new git colors
        DiffAdd = { bold = true, reverse = false, fg = "", bg = "#2a4333"},
        DiffChange = { bold = true, reverse = false, fg = "", bg = "#333841" },
        DiffDelete = { bold = true, reverse = false, fg = "#442d30", bg = "#442d30" },
        DiffText = { bold = true, reverse = false, fg = "", bg = "#213352" },
        -- statusline
        StatusLine = {bg = "#ffffff", fg = "#0E1018"},
        StatusLineNC = {bg = "#3c3836", fg = "#0E1018"},
        CursorLineNr = {fg = "#fabd2f", bg = ""},
        GruvboxOrangeSign = {fg = "#dfaf87", bg = ""},
        GruvboxAquaSign = {fg = "#8EC07C", bg = ""},
        GruvboxGreenSign = {fg = "#b8bb26", bg = ""},
        GruvboxRedSign = {fg = "#fb4934", bg = ""},
        GruvboxBlueSign = {fg = "#83a598", bg = ""},
        WilderMenu = {fg = "#ebdbb2", bg = ""},
        WilderAccent = {fg = "#f4468f", bg = ""},
        -- coc semantic token
        CocSemStruct = {link = "GruvboxYellow"},
        CocSemKeyword = {fg = "", bg = "#0E1018"},
        CocSemEnumMember = {fg = "", bg = "#0E1018"},
        CocSemTypeParameter = {fg = "", bg = "#0E1018"},
        CocSemComment = {fg = "", bg = "#0E1018"},
        CocSemMacro = {fg = "", bg = "#0E1018"},
        CocSemVariable = {fg = "", bg = "#0E1018"},
        -- CocSemFunction = {link = "GruvboxGreen"},
        -- neorg
        ["@neorg.markup.inline_macro"] = {link = "GruvboxGreen"}
      }
    })
  end
end

setupGruvbox()
