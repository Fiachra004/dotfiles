return {
    -- WakaTime
    {
        'wakatime/vim-wakatime',
        lazy = false,
    },

    -- Mason (LSP Manager) - Load before LSP
    {
        'williamboman/mason.nvim',
        lazy = false,
        config = function()
            require('mason').setup()
        end
    },
    {
        'williamboman/mason-lspconfig.nvim',
        lazy = false,
        dependencies = { 'williamboman/mason.nvim' },
        config = function()
            require('mason-lspconfig').setup({
                ensure_installed = { 'lua_ls', 'ts_ls' },
            })
        end
    },

    -- LSP Setup
    {
        'neovim/nvim-lspconfig',
        dependencies = { 
            'williamboman/mason-lspconfig.nvim',
            'hrsh7th/cmp-nvim-lsp',
        },
        config = function()
            -- Setup capabilities with nvim-cmp
            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            -- Configure LSP servers using the new API
            vim.lsp.config('lua_ls', {
                cmd = { 'lua-language-server' },
                root_markers = { '.luarc.json', '.luarc.jsonc', '.luacheckrc', '.stylua.toml', 'stylua.toml', 'selene.toml', 'selene.yml', '.git' },
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { 'vim' }
                        },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true),
                            checkThirdParty = false,
                        },
                        telemetry = { enable = false },
                    }
                }
            })

            vim.lsp.config('ts_ls', {
                cmd = { 'typescript-language-server', '--stdio' },
                root_markers = { 'package.json', 'tsconfig.json', 'jsconfig.json', '.git' },
                capabilities = capabilities,
            })

            -- Enable LSP servers
            vim.lsp.enable('lua_ls')
            vim.lsp.enable('ts_ls')

            -- LSP keymaps
            vim.api.nvim_create_autocmd('LspAttach', {
                callback = function(args)
                    local opts = { buffer = args.buf }
                    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
                    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
                    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
                    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
                    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
                    vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, opts)
                    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
                    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
                end,
            })
        end
    },

    -- Snippets (Load before nvim-cmp)
    {
        'L3MON4D3/LuaSnip',
        lazy = false,
        version = "2.*",
        build = "make install_jsregexp",
        config = function()
            require('luasnip').config.set_config({
                history = true,
                updateevents = "TextChanged,TextChangedI",
            })
        end
    },

    -- Auto-completion
    {
        'hrsh7th/nvim-cmp',
        lazy = false,
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',
        },
        config = function()
            local cmp = require('cmp')
            local luasnip = require('luasnip')

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                    { name = 'buffer' },
                    { name = 'path' },
                }),
            })

            -- Command line setup
            cmp.setup.cmdline({ '/', '?' }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = { { name = 'buffer' } },
            })
            cmp.setup.cmdline(':', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = 'path' }
                }, {
                    { name = 'cmdline' }
                }),
            })
        end
    },

    -- Telescope for fuzzy finding
    {
        'nvim-telescope/telescope.nvim',
        lazy = false,
        dependencies = { 
            'nvim-lua/plenary.nvim',
            'nvim-tree/nvim-web-devicons',
        },
        config = function()
            local telescope = require('telescope')
            local actions = require('telescope.actions')
            
            telescope.setup({
                defaults = {
                    mappings = {
                        i = {
                            ['<C-j>'] = actions.move_selection_next,
                            ['<C-k>'] = actions.move_selection_previous,
                            ['<C-q>'] = actions.send_to_qflist + actions.open_qflist,
                            ['<Esc>'] = actions.close,
                        },
                    },
                    file_ignore_patterns = { 'node_modules', '.git/', 'dist/' },
                    layout_config = {
                        horizontal = {
                            preview_width = 0.55,
                        },
                    },
                },
            })

            local builtin = require('telescope.builtin')
            
            -- File navigation
            vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find Files' })
            vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live Grep' })
            vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Find Buffers' })
            vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Help Tags' })
            vim.keymap.set('n', '<leader>fo', builtin.oldfiles, { desc = 'Recent Files' })
            vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = 'Find Word Under Cursor' })
            
            -- Git pickers
            vim.keymap.set('n', '<leader>gf', builtin.git_files, { desc = 'Git Files' })
            vim.keymap.set('n', '<leader>gc', builtin.git_commits, { desc = 'Git Commits' })
            vim.keymap.set('n', '<leader>gb', builtin.git_branches, { desc = 'Git Branches' })
            
            -- LSP pickers
            vim.keymap.set('n', '<leader>lr', builtin.lsp_references, { desc = 'LSP References' })
            vim.keymap.set('n', '<leader>ld', builtin.diagnostics, { desc = 'LSP Diagnostics' })
            vim.keymap.set('n', '<leader>ls', builtin.lsp_document_symbols, { desc = 'Document Symbols' })
        end
    },

    -- File Explorer
    {
        'nvim-tree/nvim-tree.lua',
        lazy = false,
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            -- Disable netrw
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1

            require('nvim-tree').setup({
                sort_by = 'case_sensitive',
                view = {
                    width = 35,
                },
                renderer = {
                    group_empty = true,
                    icons = {
                        show = {
                            file = true,
                            folder = true,
                            folder_arrow = true,
                            git = true,
                        },
                    },
                },
                filters = {
                    dotfiles = false,
                },
                git = {
                    enable = true,
                    ignore = false,
                },
            })

            -- Keymaps
            vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeToggle<CR>', { desc = 'Toggle File Explorer' })
            vim.keymap.set('n', '<leader>ef', '<cmd>NvimTreeFindFile<CR>', { desc = 'Find File in Explorer' })
        end
    },

    -- Indent guides
    {
        'lukas-reineke/indent-blankline.nvim',
        lazy = false,
        main = 'ibl',
        config = function()
            require('ibl').setup({
                indent = {
                    char = '│',
                },
                scope = {
                    enabled = true,
                    show_start = true,
                    show_end = false,
                },
            })
        end
    },

    -- Git signs in gutter
    {
        'lewis6991/gitsigns.nvim',
        lazy = false,
        config = function()
            require('gitsigns').setup({
                signs = {
                    add          = { text = '│' },
                    change       = { text = '│' },
                    delete       = { text = '_' },
                    topdelete    = { text = '‾' },
                    changedelete = { text = '~' },
                    untracked    = { text = '┆' },
                },
                on_attach = function(bufnr)
                    local gs = package.loaded.gitsigns

                    -- Navigation
                    vim.keymap.set('n', ']c', function()
                        if vim.wo.diff then return ']c' end
                        vim.schedule(function() gs.next_hunk() end)
                        return '<Ignore>'
                    end, { expr = true, buffer = bufnr, desc = 'Next Git Hunk' })

                    vim.keymap.set('n', '[c', function()
                        if vim.wo.diff then return '[c' end
                        vim.schedule(function() gs.prev_hunk() end)
                        return '<Ignore>'
                    end, { expr = true, buffer = bufnr, desc = 'Previous Git Hunk' })

                    -- Actions
                    vim.keymap.set('n', '<leader>hs', gs.stage_hunk, { buffer = bufnr, desc = 'Stage Hunk' })
                    vim.keymap.set('n', '<leader>hr', gs.reset_hunk, { buffer = bufnr, desc = 'Reset Hunk' })
                    vim.keymap.set('n', '<leader>hu', gs.undo_stage_hunk, { buffer = bufnr, desc = 'Undo Stage Hunk' })
                    vim.keymap.set('n', '<leader>hp', gs.preview_hunk, { buffer = bufnr, desc = 'Preview Hunk' })
                    vim.keymap.set('n', '<leader>hb', gs.blame_line, { buffer = bufnr, desc = 'Blame Line' })
                end
            })
        end
    },

    -- Which-key for keybinding help
    {
        'folke/which-key.nvim',
        lazy = false,
        config = function()
            local wk = require('which-key')
            wk.setup({
                plugins = {
                    spelling = { enabled = true },
                },
            })

            -- Register leader key groups
            wk.add({
                { "<leader>f", group = "Find (Telescope)" },
                { "<leader>g", group = "Git" },
                { "<leader>h", group = "Git Hunks" },
                { "<leader>l", group = "LSP" },
                { "<leader>e", group = "Explorer" },
            })
        end
    },

    -- Statusline
    {
        'nvim-lualine/lualine.nvim',
        lazy = false,
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('lualine').setup({
                options = {
                    theme = 'auto',
                    component_separators = { left = '|', right = '|' },
                    section_separators = { left = '', right = '' },
                },
                sections = {
                    lualine_a = { 'mode' },
                    lualine_b = { 'branch', 'diff', 'diagnostics' },
                    lualine_c = { 'filename' },
                    lualine_x = { 'encoding', 'fileformat', 'filetype' },
                    lualine_y = { 'progress' },
                    lualine_z = { 'location' }
                },
            })
        end
    },

    -- Auto pairs
    {
        'windwp/nvim-autopairs',
        lazy = false,
        config = function()
            require('nvim-autopairs').setup({
                check_ts = true,
                ts_config = {
                    lua = { 'string' },
                    javascript = { 'template_string' },
                },
            })

            -- Integration with nvim-cmp
            local cmp_autopairs = require('nvim-autopairs.completion.cmp')
            local cmp = require('cmp')
            cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
        end
    },

    -- Trouble for diagnostics
    {
        'folke/trouble.nvim',
        lazy = false,
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('trouble').setup({})

            vim.keymap.set('n', '<leader>xx', '<cmd>Trouble diagnostics toggle<CR>', { desc = 'Toggle Trouble' })
            vim.keymap.set('n', '<leader>xd', '<cmd>Trouble diagnostics toggle filter.buf=0<CR>', { desc = 'Document Diagnostics' })
            vim.keymap.set('n', '<leader>xq', '<cmd>Trouble qflist toggle<CR>', { desc = 'Quickfix List' })
            vim.keymap.set('n', '<leader>xl', '<cmd>Trouble loclist toggle<CR>', { desc = 'Location List' })
        end
    },

    -- Git integration
    {
        'tpope/vim-fugitive',
        lazy = false,
        config = function()
            vim.keymap.set('n', '<leader>gs', vim.cmd.Git, { desc = 'Git Status' })
            vim.keymap.set('n', '<leader>gc', '<cmd>Git commit<CR>', { desc = 'Git Commit' })
            vim.keymap.set('n', '<leader>gp', '<cmd>Git push<CR>', { desc = 'Git Push' })
            vim.keymap.set('n', '<leader>gl', '<cmd>Git pull<CR>', { desc = 'Git Pull' })
        end
    },

    -- Commenting
    { 'tpope/vim-commentary', lazy = false },

    -- Surround-like editing
    { 'machakann/vim-sandwich', lazy = false },

    -- Syntax highlighting and parsing
    {
        'nvim-treesitter/nvim-treesitter',
        lazy = false,
        build = ':TSUpdate',
        config = function()
            require('nvim-treesitter.configs').setup({
                ensure_installed = {
                    'lua', 'vim', 'vimdoc', 'bash', 'python',
                    'javascript', 'typescript', 'java', 'json',
                    'yaml', 'markdown', 'html', 'css'
                },
                highlight = { enable = true },
                indent = { enable = true },
                auto_install = true,
            })
        end
    },
}
