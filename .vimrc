scriptencoding utf-8
if has('vim_starting')
    set runtimepath+=~/.vim/bundle/neobundle.vim/
endif
call neobundle#rc(expand('~/.vim/bundle/'))
" Let NeoBundle manage NeoBundle
NeoBundleFetch 'Shougo/neobundle.vim'

set backspace=indent,eol,start

" add plugins

filetype plugin on
filetype plugin indent on
syntax enable

" Base plugin
NeoBundle 'Shougo/vimproc.vim', {
			\ 'build' : {
			\     'mac' : 'make -f make_mac.mak',
			\     'unix' : 'make -f make_unix.mak',
			\   }
			\ }
NeoBundle "Shougo/neosnippet.vim"
NeoBundle "Shougo/neosnippet-snippets"
imap <expr><Tab> neosnippet#expandable_or_jumpable() ?
			\ "\<Plug>(neosnippet_expand_or_jump)"
			\: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
			\ "\<Plug>(neosnippet_expand_or_jump)"
			\: "\<TAB>"
nnoremap <Space>ns :execute "tabnew\|:NeoSnippetEdit ".&filetype<CR>
let g:neosnippet#snippets_directory = "~/.neosnippet"
NeoBundle "tyru/caw.vim" " Comment Util
nmap \c <Plug>(caw:I:toggle)
vmap \c <Plug>(caw:I:toggle)
nmap \C <Plug>(caw:I:uncomment)
vmap \C <Plug>(caw:I:uncomment)
NeoBundle "t9md/vim-quickhl" " Word Highlight
nmap <Space>m <Plug>(quickhl-manual-this)
xmap <Space>m <Plug>(quickhl-manual-this)
nmap <Space>M <Plug>(quickhl-manual-reset)
xmap <Space>M <Plug>(quickhl-manual-reset)
NeoBundle "Shougo/unite.vim" " Buffer Outline
NeoBundle "Shougo/unite-outline"
if has("lua") " Code Complete
	NeoBundle "Shougo/neocomplete.vim"
else
	NeoBundle "Shougo/neocomplcache"
endif
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#skip_auto_completion_time = ""
let g:neocomplcache_enable_at_startup = 1
NeoBundle "thinca/vim-quickrun"
let g:quickrun_config = {
			\   "_" : {
			\       "outputter" : "error",
			\       "outputter/error/success" : "buffer",
			\       "outputter/error/error"   : "quickfix",
			\       "outputter/buffer/split" : ":botright 8sp",
			\       "outputter/quickfix/open_cmd" : "copen",
			\       "runner" : "vimproc",
			\       "runner/vimproc/updatetime" : "500" ,
			\   },
			\   "cpp" : {
			\     "type" : "cpp/clang++",
			\     "cmdopt" : "-Wall -Wextra -Werror -std=c++11",
			\   },
			\   "cpp/watchdogs_checker" : {
			\     "type" : "watchdogs_checker/clang++",
			\   },
			\
			\   "watchdogs_checker/g++" : {
			\     "cmdopt" : "-Wall -Wextra -Werror -std=c++11",
			\   },
			\   "watchdogs_checker/clang++" : {
			\     "cmdopt" : "-Wall -Wextra -Werror -std=c++11",
			\   },
			\   "haskell" : {
			\     "type" : "haskell/ghc",
			\     "cmdopt" : "-Wall -Werror",
			\   },
			\   "ruby" : {
			\     "type" : "ruby/ruby",
			\   },
			\ }
let s:hook = {
			\   "name" : "clear_quickfix",
			\   "kind" : "hook",
			\ }
function! s:hook.on_normalized(session, context)
  call setqflist([])
endfunction
call quickrun#module#register(s:hook, 1)
unlet s:hook
let g:watchdogs_check_BufWritePost_enable = 1

" for C++
function! s:cpp()
  setlocal path+=/usr/include/boost/:/usr/include/c++/4.8/
  setlocal tabstop=4
  setlocal shiftwidth=4
  setlocal expandtab
  setlocal matchpairs+=<:>
  nnoremap <buffer><silent> <Space>ii :execute "?".&include<CR> :noh<CR> o
  syntax match boost_pp /BOOST_PP_[A-z0-9_]*/
  highlight link boost_pp cppStatement
  let g:marching_backend = "sync_clang_command"
  let g:marching_clang_command_option="-Wall -Wextra -Werror -std=c++11"
  let g:marching_enable_neocomplete = 1
  if !exists('g:neocomplete#force_omni_input_patterns')
    let g:neocomplete#force_omni_input_patterns = {}
  endif
  let g:neocomplete#force_omni_input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'
endfunction
function! s:expand_namespace()
  let l:s = getline('.')[0:col('.')-1]
  if l:s =~# '\<b;$'
    return "\<BS>oost::"
  elseif l:s =~# '\<s;$'
    return "\<BS>td::"
  elseif l:s =~# '\<d;$'
    return "\<BS>etail::" 
  else
    return ";"
  endif
endfunction
augroup vimrc-cpp
  autocmd!
  autocmd FileType cpp call s:cpp()
augroup END
let $CPP_STD_INCLUDE_PATH="/usr/include/c++/4.8"
augroup vimrc-std-include-path
  autocmd!
  autocmd BufReadPost $CPP_STD_INCLUDE_PATH/* if empty(&filetype) | set filetype=cpp | endif
augroup END
augroup cpp-namespace
  autocmd!
  autocmd FileType cpp inoremap <buffer><expr>; <SID>expand_namespace()
augroup END
NeoBundleLazy "osyo-manga/vim-marching" , {
			\   'autoload' : {
			\     'filetype' : 'cpp'
			\   }
			\ }
NeoBundleLazy "jceb/vim-hier", {
			\   'autoload' : {
			\     'filetype' : 'cpp'
			\   }
			\ }
NeoBundleLazy "osyo-manga/vim-watchdogs", {
			\   'autoload' : {
			\     'filetype' : 'cpp'
			\   }
			\ }
NeoBundleLazy "osyo-manga/shabadou.vim", {
			\   'autoload' : {
			\     'filetype' : 'cpp'
			\   }
			\ }

" for Haskell
function! s:haskell()
  setlocal tabstop=2
  setlocal shiftwidth=2
  setlocal expandtab
  let g:marching_enable_neocomplete = 1
  if !exists('g:neocomplete#force_omni_input_patterns')
    let g:neocomplete#force_omni_input_patterns = {}
  endif
  let g:neocomplete#force_omni_input_patterns.haskell = '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'
endfunction
augroup vimrc-haskell
  autocmd!
  autocmd FileType haskell call s:haskell()
augroup END
NeoBundleLazy "kana/vim-filetype-haskell", {
			\   'autoload' : {
			\     'filetype' : 'haskell'
			\   }
			\ }
NeoBundleLazy "dag/vim2hs", {
			\   'autoload' : {
			\     'filetype' : 'haskell'
			\   }
			\ }
NeoBundleLazy "eagletmt/ghcmod-vim", {
			\   'autoload' : {
			\     'filetype' : 'haskell'
			\   }
			\ }
NeoBundleLazy "pbrisbin/vim-syntax-shakespeare", {
			\   'autoload' : {
			\     'filetype' : 'haskell'
			\   }
			\ }
NeoBundleLazy "eagletmt/neco-ghc", {
			\   'autoload' : {
			\     'filetype' : 'haskell'
			\   }
			\ }
NeoBundleLazy "eagletmt/unite-haddock", {
			\   'autoload' : {
			\     'filetype' : 'haskell'
			\   }
			\ }

" for Coq
NeoBundle "minamiyama1994/coqtop-vim"

" for Ruby
function! s:ruby()
  setlocal tabstop=2
  setlocal shiftwidth=2
  setlocal expandtab
  let g:marching_enable_neocomplete = 1
  if !exists('g:neocomplete#force_omni_input_patterns')
    let g:neocomplete#force_omni_input_patterns = {}
  endif
  let g:neocomplete#force_omni_input_patterns.ruby = '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'
endfunction
augroup vimrc-ruby
  autocmd!
  autocmd FileType haml call s:ruby()
  autocmd FileType ruby call s:ruby()
  autocmd FileType eruby call s:ruby()
augroup END

" for Twitter
NeoBundle "basyura/TweetVim", {
			\   "depends" : [
			\     'mattn/webapi-vim' ,
			\     'basyura/twibill.vim' ,
			\     'tyru/open-browser.vim' ,
			\     'h1mesuke/unite-outline' ,
			\     'basyura/bitly.vim' ,
			\     'Shougo/unite.vim' ,
			\   ]
			\ }

" for Markdown
NeoBundle "rcmdnk/vim-markdown"
NeoBundle "kannokanno/previm"
NeoBundle "tyru/open-browser.vim"

" for HTML CSS
function! s:scss()
  setlocal tabstop=2
  setlocal shiftwidth=2
  setlocal expandtab
  let g:marching_enable_neocomplete = 1
  if !exists('g:neocomplete#force_omni_input_patterns')
    let g:neocomplete#force_omni_input_patterns = {}
  endif
  let g:neocomplete#force_omni_input_patterns.scss = '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'
endfunction
augroup vimrc-scss
  autocmd!
  autocmd FileType scss call s:scss()
augroup END
NeoBundle "mattn/emmet-vim"
NeoBundle "tpope/vim-surround"
NeoBundle "othree/html5.vim"
NeoBundle "hail2u/vim-css3-syntax"
NeoBundle "css_color.vim"

" for VimShell
NeoBundle "Shougo/vimshell.vim"

" for Web

NeoBundle "yuratomo/w3m.vim"

NeoBundleCheck
