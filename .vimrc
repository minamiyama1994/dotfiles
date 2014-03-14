if has('vim_starting')
    set runtimepath+=~/.vim/bundle/neobundle.vim/
endif
call neobundle#rc(expand('~/.vim/bundle/'))
" Let NeoBundle manage NeoBundle
NeoBundleFetch 'Shougo/neobundle.vim'

" add plugins

filetype plugin on

NeoBundleCheck

NeoBundle 'dag/vim2hs'
NeoBundle 'eagletmt/ghcmod-vim'
NeoBundle 'pbrisbin/html-template-syntax'
NeoBundle 'ujihisa/neco-ghc'
NeoBundle 'eagletmt/unite-haddock'
NeoBundle 'kana/vim-filetype-haskell'
NeoBundle 'Shougo/vimproc.vim'
