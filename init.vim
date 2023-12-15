set mouse=a  " enable mouse
set fileencodings=ucs-bom,utf-8,cp1251
set number
set noswapfile
"set ignorecase
set smartcase "Your search will be case sensitive if it contains an uppercase letter
set scrolloff=7
set spelllang=en,rus
set clipboard=unnamed
set fileformat=unix
filetype indent on      " load filetype-specific indent files

" for tabulation
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab ts=4 sw=4 ai



call plug#begin('/Users/lovermac/.local/share/nvim/site/autoload/')

Plug 'neovim/nvim-lspconfig' " main LSP plugin
" set of autocomplete plugins
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
"Plug 'chrisbra/csv.vim'

" color schemas
Plug 'sainnhe/gruvbox-material'
" Plug 'loctvl842/monokai-pro.nvim'
call plug#end()


" Run Python and C files by Ctrl+h 
autocmd FileType python map <buffer> <C-h> :w<CR>:exec '!python3' shellescape(@%, 1)<CR>
autocmd FileType python imap <buffer> <C-h> <esc>:w<CR>:exec '!python3' shellescape(@%, 1)<CR>

" colorscheme gruvbox-material setup()
set background=dark
let g:gruvbox_material_background = 'soft'
let g:gruvbox_material_better_performance = 1
let g:gruvbox_material_enable_bold = 1
let g:gruvbox_material_transparent_background = 2 
let g:gruvbox_material_dim_inactive_windows = 1
let g:gruvbox_material_ui_contrast = 'high'
" let g:gruvbox_material_colors_override = {''} "to custom setup, line numbers
" key is ...


colorscheme gruvbox-material 
" colorscheme monokai-pro "unused as macOS native terminal doesn't support truecolors
 
"block of autocomplete lsp server 
lua <<EOF
  -- Set up nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  -- Set up lspconfig.
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  require('lspconfig')['pyright'].setup {
    capabilities = capabilities
  }
EOF

