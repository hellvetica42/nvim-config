
" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages available in Debian.
runtime! debian.vim

" Vim will load $VIMRUNTIME/defaults.vim if the user does not have a vimrc.
" This happens after /etc/vim/vimrc(.local) are loaded, so it will override
" any settings in these files.
" If you don't want that to happen, uncomment the below line to prevent
" defaults.vim from being loaded.
" let g:skip_defaults_vim = 1

filetype plugin indent on
syntax on
set backspace=indent,eol,start
set hidden
set noswapfile
set hlsearch
set is hls

"set laststatus=2
"set statusline+=%F

let $RTP=split(&runtimepath, ',')[0]
let $RC="$HOME/.config/nvim/init.vim"

set path=.,**
set number relativenumber
set mouse=a "Scroll wheel
set wildmenu "za fuzzy search?
set scrolloff=7
set smartcase
nnoremap <C-n> :NERDTreeToggle<CR>
nnoremap <C-k> <C-a>

call plug#begin('~/.config/nvim/plugged')

"Plug 'nvim-treesitter/nvim-treesitter', { 'commit': '3c07232'}
"Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
Plug 'preservim/nerdtree'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'christoomey/vim-tmux-navigator'
Plug 'sheerun/vim-polyglot'
Plug 'nathanaelkane/vim-indent-guides'
"Plug 'joshdick/onedark.vim'
Plug 'rakr/vim-one'
Plug 'tomasr/molokai'
"Plug 'morhetz/gruvbox'
"Plug 'xolox/vim-easytags'  
"Plug 'xolox/vim-misc'
call plug#end()


let g:loaded_nerdtree_fs_menu=1
let g:loaded_clipboard_provider=1
set clipboard+=unnamedplus

highlight CocFloating ctermbg=red
highlight CocErrorFloat ctermfg=white


" Use tab for trigger completion with characters ahead and navigate.
" " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" " other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
	\ pumvisible() ? "\<C-n>" :
	\ <SID>check_back_space() ? "\<TAB>" :
	\ coc#refresh()

inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]  =~# '\s'
endfunction

if exists('+termguicolors')
	let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
	let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
	set termguicolors
endif

"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
""If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support (see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
	if (has("nvim"))
	"For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 > 
		let $NVIM_TUI_ENABLE_TRUE_COLOR=1
	endif
"For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
"Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd > < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
	if (has("termguicolors"))
		set termguicolors
	endif
endif

let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_invert_selection='0'
colorscheme one
"let g:airline_theme='one'
set background=dark
