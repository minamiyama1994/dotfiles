scriptencoding utf-8
if has('vim_starting')
    set runtimepath+=~/.vim/bundle/neobundle.vim/
endif
call neobundle#rc(expand('~/.vim/bundle/'))
" Let NeoBundle manage NeoBundle
NeoBundleFetch 'Shougo/neobundle.vim'

" add plugins

filetype plugin on
filetype plugin indent on
syntax enable

NeoBundleCheck

NeoBundle 'Shougo/vimproc.vim'
NeoBundle 'dag/vim2hs'
NeoBundle 'eagletmt/ghcmod-vim'
NeoBundle 'pbrisbin/html-template-syntax'
NeoBundle 'ujihisa/neco-ghc'
NeoBundle 'eagletmt/unite-haddock'
NeoBundle 'kana/vim-filetype-haskell'
NeoBundle 'eagletmt/coqtop-vim'
NeoBundle "tyru/caw.vim"
if has("lua")
	NeoBundle "Shougo/neocomplete.vim"
else
	NeoBundle "Shougo/neocomplcache"
endif
NeoBundle "Shougo/neosnippet.vim"
NeoBundle "Shougo/neosnippet-snippets"
NeoBundle "Shougo/unite.vim"
NeoBundle "Shougo/unite-outline"
NeoBundle "vim-jp/cpp-vim"
NeoBundle "rhysd/wandbox-vim"
NeoBundle "osyo-manga/vim-marching"
NeoBundle "thinca/vim-quickrun"
NeoBundle "jceb/vim-hier"
NeoBundle "dannyob/quickfixstatus"
NeoBundle "osyo-manga/vim-watchdogs"
NeoBundle "osyo-manga/shabadou.vim"
NeoBundle "t9md/vim-quickhl"
NeoBundleCheck
