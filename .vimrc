scriptencoding utf-8
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


if has('vim_starting')
	set nocompatible
endif

function! s:cpp()
	let &l:path = join(filter(split($VIM_CPP_STDLIB . "," . $VIM_CPP_INCLUDE_DIR, '[,;]'), 'isdirectory(v:val)'), ',')

	setlocal matchpairs+=<:>

	syntax match boost_pp /BOOST_PP_[A-z0-9_]*/
	highlight link boost_pp cppStatement

	let b:quickrun_config = {
\		"hook/add_include_option/enable" : 1
\	}

	if exists("*CppVimrcOnFileType_cpp")
		call CppVimrcOnFileType_cpp()
	endif
endfunction

set matchtime=0

set updatetime=1000

let c_comment_strings=1
let c_no_curly_error=1

let s:neobundle_plugins_dir = expand(exists("$VIM_NEOBUNDLE_PLUGIN_DIR") ? $VIM_NEOBUNDLE_PLUGIN_DIR : '~/.vim/bundle')

let s:cpp_include_dirs = expand(exists("$VIM_CPP_INCLUDE_DIR") ? $VIM_CPP_INCLUDE_DIR : '')

if !executable("git")
	echo "Please install git."
	finish
endif

if !isdirectory(s:neobundle_plugins_dir . "/neobundle.vim")
	echo "Please install neobundle.vim."
	function! s:install_neobundle()
		if input("Install neobundle.vim? [Y/N] : ") =="Y"
			if !isdirectory(s:neobundle_plugins_dir)
				call mkdir(s:neobundle_plugins_dir, "p")
			endif

			execute "!git clone git://github.com/Shougo/neobundle.vim "
			\ . s:neobundle_plugins_dir . "/neobundle.vim"
			echo "neobundle installed. Please restart vim."
		else
			echo "Canceled."
		endif
	endfunction
	augroup install-neobundle
		autocmd!
		autocmd VimEnter * call s:install_neobundle()
	augroup END
	finish
endif

if has('vim_starting')
	execute "set runtimepath+=" . s:neobundle_plugins_dir . "/neobundle.vim"
endif

call neobundle#rc(s:neobundle_plugins_dir)

NeoBundleFetch "Shougo/neobundle.vim"

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

if !has("kaoriya")
	NeoBundle 'Shougo/vimproc.vim', {
	\ 'build' : {
	\     'windows' : 'make -f make_mingw32.mak',
	\     'cygwin' : 'make -f make_cygwin.mak',
	\     'mac' : 'make -f make_mac.mak',
	\     'unix' : 'make -f make_unix.mak',
	\    },
	\ }
endif

if exists("*CppVimrcOnNeoBundle")
	call CppVimrcOnNeoBundle()
endif

filetype plugin indent on
syntax enable

NeoBundleCheck

let s:hooks = neobundle#get_hooks("caw.vim")
function! s:hooks.on_source(bundle)
	nmap <leader>c <Plug>(caw:I:toggle)
	vmap <leader>c <Plug>(caw:I:toggle)

	nmap <Leader>C <Plug>(caw:I:uncomment)
	vmap <Leader>C <Plug>(caw:I:uncomment)

endfunction
unlet s:hooks

let s:hooks = neobundle#get_hooks("neocomplete.vim")
function! s:hooks.on_source(bundle)
	let g:neocomplete#enable_at_startup = 1

	let g:neocomplete#skip_auto_completion_time = ""
endfunction
unlet s:hooks

let s:hooks = neobundle#get_hooks("neocomplcache")
function! s:hooks.on_source(bundle)
	let g:neocomplcache_enable_at_startup=1
endfunction
unlet s:hooks

let s:hooks = neobundle#get_hooks("quickfixstatus")
function! s:hooks.on_post_source(bundle)
	QuickfixStatusEnable
endfunction
unlet s:hooks

let s:hooks = neobundle#get_hooks("vim-quickhl")
function! s:hooks.on_source(bundle)

	nmap <Space>m <Plug>(quickhl-manual-this)
	xmap <Space>m <Plug>(quickhl-manual-this)
	nmap <Space>M <Plug>(quickhl-manual-reset)
	xmap <Space>M <Plug>(quickhl-manual-reset)
endfunction
unlet s:hooks

let s:hooks = neobundle#get_hooks("neosnippet.vim")
function! s:hooks.on_source(bundle)

	imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
	\ "\<Plug>(neosnippet_expand_or_jump)"
	\: pumvisible() ? "\<C-n>" : "\<TAB>"
	smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
	\ "\<Plug>(neosnippet_expand_or_jump)"
	\: "\<TAB>"

	let g:neosnippet#snippets_directory = "~/.neosnippet"

	nnoremap <Space>ns :execute "tabnew\|:NeoSnippetEdit ".&filetype<CR>
endfunction
unlet s:hooks

let s:hooks = neobundle#get_hooks("vim-marching")
function! s:hooks.on_post_source(bundle)
	if !empty(g:marching_clang_command) && executable(g:marching_clang_command)

		let g:marching_backend = "sync_clang_command"
	else

		let g:marching_backend = "wandbox"
		let g:marching_clang_command = ""
	endif

	let g:marching#clang_command#options = {
	\	"cpp" : "-std=gnu++1y"
	\}

	if !neobundle#is_sourced("neocomplete.vim")
		return
	endif

	let g:marching_enable_neocomplete = 1

	if !exists('g:neocomplete#force_omni_input_patterns')
		let g:neocomplete#force_omni_input_patterns = {}
	endif

	let g:neocomplete#force_omni_input_patterns.cpp =
		\ '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'
	endfunction
unlet s:hooks

let s:hooks = neobundle#get_hooks("vim-quickrun")
function! s:hooks.on_source(bundle)
	let g:quickrun_config = {
\		"_" : {
\			"runner" : "vimproc",
\			"runner/vimproc/sleep" : 10,
\			"runner/vimproc/updatetime" : 500,
\			"outputter" : "error",
\			"outputter/error/success" : "buffer",
\			"outputter/error/error"   : "quickfix",
\			"outputter/quickfix/open_cmd" : "copen",
\			"outputter/buffer/split" : ":botright 8sp",
\		},
\
\		"cpp/wandbox" : {
\			"runner" : "wandbox",
\			"runner/wandbox/compiler" : "clang-head",
\			"runner/wandbox/options" : "warning,c++1y,boost-1.55",
\		},
\
\		"cpp/g++" : {
\			"cmdopt" : "-std=c++1y -Wall",
\		},
\
\		"cpp/clang++" : {
\			"cmdopt" : "-std=c++1y -Wall",
\		},
\
\		"cpp/watchdogs_checker" : {
\			"type" : "watchdogs_checker/clang++",
\		},
\	
\		"watchdogs_checker/_" : {
\			"outputter/quickfix/open_cmd" : "",
\		},
\	
\		"watchdogs_checker/g++" : {
\			"cmdopt" : "-Wall",
\		},
\	
\		"watchdogs_checker/clang++" : {
\			"cmdopt" : "-Wall",
\		},
\	}

	let s:hook = {
	\	"name" : "add_include_option",
	\	"kind" : "hook",
	\	"config" : {
	\		"option_format" : "-I%s"
	\	},
	\}

	function! s:hook.on_normalized(session, context)

		if &filetype !=# "cpp"
			return
		endif
		let paths = filter(split(&path, ","), "len(v:val) && v:val !='.' && v:val !~ $VIM_CPP_STDLIB")

		if len(paths)
			let a:session.config.cmdopt .= " " . join(map(paths, "printf(self.config.option_format, v:val)")) . " "
		endif
	endfunction

	call quickrun#module#register(s:hook, 1)
	unlet s:hook

	let s:hook = {
	\	"name" : "clear_quickfix",
	\	"kind" : "hook",
	\}

	function! s:hook.on_normalized(session, context)
		call setqflist([])
	endfunction

	call quickrun#module#register(s:hook, 1)
	unlet s:hook

endfunction
unlet s:hooks

let s:hooks = neobundle#get_hooks("vim-watchdogs")
function! s:hooks.on_source(bundle)
	let g:watchdogs_check_BufWritePost_enable = 1
endfunction
unlet s:hooks

if exists("*CppVimrcOnPrePlugin")
	call CppVimrcOnPrePlugin()
endif

call neobundle#call_hook('on_source')

if exists("*CppVimrcOnFinish")
	call CppVimrcOnFinish()
endif

augroup vimrc-cpp
	autocmd!

	autocmd FileType cpp call s:cpp()
augroup END
