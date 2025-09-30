vim.opt.clipboard:append("unnamedplus")

-- Place this in ~/.config/nvim/lua/config/aesthetics.lua
-- Then require it in your init.lua with: require('config.aesthetics')

-- Basic UI settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.signcolumn = 'yes'
vim.opt.wrap = false
vim.opt.scrolloff = 8

-- Custom colorscheme with your specifications
local function setup_custom_colors()
    -- Clear any existing colorscheme
    vim.cmd('highlight clear')
    if vim.fn.exists('syntax_on') then
        vim.cmd('syntax reset')
    end

    vim.g.colors_name = 'custom_dark'

    -- Define color palette
    local colors = {
        bg = '#08021a',
        fg = '#e0e0e0',
        -- Blues
        blue1 = '#4A9EFF',
        blue2 = '#6BB6FF',
        blue3 = '#2C7FD4',
        cyan = '#56B6C2',
        -- Reds
        red1 = '#FF5555',
        red2 = '#FF6B6B',
        red3 = '#E06C75',
        -- Oranges
        orange1 = '#FF8C42',
        orange2 = '#FFB86C',
        orange3 = '#D19A66',
        -- Supporting colors
        purple = '#C678DD',
        green = '#98C379',
        yellow = '#E5C07B',
        gray1 = '#3E4451',
        gray2 = '#5C6370',
        gray3 = '#ABB2BF',
    }

    -- Helper function to set highlights
    local function hi(group, opts)
        local cmd = 'highlight ' .. group
        if opts.fg then cmd = cmd .. ' guifg=' .. opts.fg end
        if opts.bg then cmd = cmd .. ' guibg=' .. opts.bg end
        if opts.style then cmd = cmd .. ' gui=' .. opts.style end
        if opts.sp then cmd = cmd .. ' guisp=' .. opts.sp end
        vim.cmd(cmd)
    end

    -- Editor UI
    hi('Normal', { fg = colors.fg, bg = colors.bg })
    hi('NormalFloat', { fg = colors.fg, bg = colors.bg })
    hi('CursorLine', { bg = '#0f0528' })
    hi('CursorLineNr', { fg = colors.orange1, style = 'bold' })
    hi('LineNr', { fg = colors.gray2 })
    hi('SignColumn', { bg = colors.bg })
    hi('VertSplit', { fg = colors.gray1 })
    hi('StatusLine', { fg = colors.blue1, bg = colors.gray1 })
    hi('StatusLineNC', { fg = colors.gray2, bg = colors.gray1 })
    hi('Pmenu', { fg = colors.fg, bg = '#120533' })
    hi('PmenuSel', { fg = colors.bg, bg = colors.blue1 })
    hi('PmenuSbar', { bg = colors.gray1 })
    hi('PmenuThumb', { bg = colors.blue2 })

    -- Syntax highlighting with blues, reds, and oranges
    hi('Comment', { fg = colors.gray2, style = 'italic' })
    hi('Constant', { fg = colors.orange1 })
    hi('String', { fg = colors.orange2 })
    hi('Character', { fg = colors.orange3 })
    hi('Number', { fg = colors.orange1 })
    hi('Boolean', { fg = colors.red2 })
    hi('Float', { fg = colors.orange1 })
    
    hi('Identifier', { fg = colors.blue2 })
    hi('Function', { fg = colors.blue1, style = 'bold' })
    
    hi('Statement', { fg = colors.red1 })
    hi('Conditional', { fg = colors.red2 })
    hi('Repeat', { fg = colors.red2 })
    hi('Label', { fg = colors.red3 })
    hi('Operator', { fg = colors.blue3 })
    hi('Keyword', { fg = colors.red1, style = 'bold' })
    hi('Exception', { fg = colors.red1 })
    
    hi('PreProc', { fg = colors.orange2 })
    hi('Include', { fg = colors.red2 })
    hi('Define', { fg = colors.red1 })
    hi('Macro', { fg = colors.orange3 })
    hi('PreCondit', { fg = colors.orange1 })
    
    hi('Type', { fg = colors.blue1 })
    hi('StorageClass', { fg = colors.blue2 })
    hi('Structure', { fg = colors.blue3 })
    hi('Typedef', { fg = colors.blue1 })
    
    hi('Special', { fg = colors.cyan })
    hi('SpecialChar', { fg = colors.orange2 })
    hi('Tag', { fg = colors.red2 })
    hi('Delimiter', { fg = colors.fg })
    hi('SpecialComment', { fg = colors.cyan, style = 'italic' })
    hi('Debug', { fg = colors.red1 })
    
    hi('Underlined', { style = 'underline' })
    hi('Error', { fg = colors.red1 })
    hi('Todo', { fg = colors.orange1, bg = colors.bg, style = 'bold' })
    
    -- Treesitter specific
    hi('@variable', { fg = colors.fg })
    hi('@variable.builtin', { fg = colors.red2 })
    hi('@property', { fg = colors.blue2 })
    hi('@parameter', { fg = colors.orange3 })
    hi('@function', { fg = colors.blue1, style = 'bold' })
    hi('@function.builtin', { fg = colors.cyan })
    hi('@method', { fg = colors.blue1 })
    hi('@constructor', { fg = colors.blue3 })
    hi('@keyword', { fg = colors.red1, style = 'bold' })
    hi('@keyword.function', { fg = colors.red2 })
    hi('@keyword.operator', { fg = colors.red1 })
    hi('@conditional', { fg = colors.red2 })
    hi('@repeat', { fg = colors.red2 })
    hi('@string', { fg = colors.orange2 })
    hi('@number', { fg = colors.orange1 })
    hi('@boolean', { fg = colors.red2 })
    hi('@constant', { fg = colors.orange1 })
    hi('@constant.builtin', { fg = colors.orange3 })
    hi('@type', { fg = colors.blue1 })
    hi('@type.builtin', { fg = colors.blue3 })
    hi('@operator', { fg = colors.blue3 })
    hi('@punctuation.bracket', { fg = colors.fg })
    hi('@punctuation.delimiter', { fg = colors.gray3 })
    hi('@tag', { fg = colors.red2 })
    hi('@tag.attribute', { fg = colors.orange2 })
    hi('@tag.delimiter', { fg = colors.gray3 })
    
    -- LSP
    hi('DiagnosticError', { fg = colors.red1 })
    hi('DiagnosticWarn', { fg = colors.orange1 })
    hi('DiagnosticInfo', { fg = colors.blue1 })
    hi('DiagnosticHint', { fg = colors.cyan })
    hi('DiagnosticUnderlineError', { sp = colors.red1, style = 'undercurl' })
    hi('DiagnosticUnderlineWarn', { sp = colors.orange1, style = 'undercurl' })
    hi('DiagnosticUnderlineInfo', { sp = colors.blue1, style = 'undercurl' })
    hi('DiagnosticUnderlineHint', { sp = colors.cyan, style = 'undercurl' })
    
    -- Git signs
    hi('GitSignsAdd', { fg = colors.green })
    hi('GitSignsChange', { fg = colors.orange1 })
    hi('GitSignsDelete', { fg = colors.red1 })
    
    -- Telescope
    hi('TelescopeBorder', { fg = colors.blue1 })
    hi('TelescopePromptBorder', { fg = colors.blue2 })
    hi('TelescopeResultsBorder', { fg = colors.blue1 })
    hi('TelescopePreviewBorder', { fg = colors.blue3 })
    hi('TelescopeSelection', { fg = colors.fg, bg = '#1a0d3d' })
    hi('TelescopeMatching', { fg = colors.orange1, style = 'bold' })
    
    -- nvim-tree
    hi('NvimTreeFolderIcon', { fg = colors.blue1 })
    hi('NvimTreeFolderName', { fg = colors.blue2 })
    hi('NvimTreeOpenedFolderName', { fg = colors.blue1, style = 'bold' })
    hi('NvimTreeRootFolder', { fg = colors.red2, style = 'bold' })
    hi('NvimTreeGitDirty', { fg = colors.orange1 })
    hi('NvimTreeGitNew', { fg = colors.green })
    hi('NvimTreeGitDeleted', { fg = colors.red1 })
    
    -- Which-key
    hi('WhichKey', { fg = colors.blue1 })
    hi('WhichKeyGroup', { fg = colors.red2 })
    hi('WhichKeyDesc', { fg = colors.orange2 })
    hi('WhichKeySeparator', { fg = colors.gray2 })
    
    -- Indent-blankline
    hi('IblIndent', { fg = colors.gray1 })
    hi('IblScope', { fg = colors.blue3 })
end

-- Apply transparent background (0.9 opacity)
local function setup_transparency()
    vim.api.nvim_create_autocmd('ColorScheme', {
        pattern = '*',
        callback = function()
            -- Make backgrounds transparent
            local transparent_groups = {
                'Normal',
                'NormalFloat',
                'NormalNC',
                'SignColumn',
                'EndOfBuffer',
                'LineNr',
                'CursorLineNr',
            }
            
            for _, group in ipairs(transparent_groups) do
                vim.cmd('highlight ' .. group .. ' guibg=NONE ctermbg=NONE')
            end
            
            -- Keep slight bg for these
            vim.cmd('highlight CursorLine guibg=#0f05287f')
            vim.cmd('highlight Pmenu guibg=#120533e6')
        end
    })
end

-- Initialize
setup_custom_colors()
setup_transparency()

-- Set opacity in terminal (works with some terminals)
-- Note: Terminal opacity is typically set in your terminal emulator settings
-- For example, in kitty.conf: background_opacity 0.9
-- Or in alacritty.yml: window.opacity: 0.9

-- Optional: Add some nice UI enhancements
vim.opt.fillchars = {
    vert = '│',
    fold = '⠀',
    eob = ' ', -- suppress ~ at EndOfBuffer
    diff = '⣿',
    msgsep = '‾',
    foldopen = '▾',
    foldsep = '│',
    foldclose = '▸'
}
