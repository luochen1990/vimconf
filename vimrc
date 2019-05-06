" TroubleShooting: disable following init steps from bottom to up
func s:init()
	call s:helpers() "definitions of helper functinos
	call s:personal() "env variables and working dir
	call s:keymap()
	call s:encoding() "set character encoding schemes
	call s:vimdir() "my own vimdir
	call s:editor() "filetypes & syntax & highlighting & indent
	call s:general() "global options
	call s:font()
	call s:plugins() "load plugins and their configurations
endfunc

func s:register_plugins()
	Plug 'rlue/vim-barbaric' " to solve the im swiching problem on *nix os

	Plug 'luochen1990/rainbow' " rainbow parentheses
	Plug 'luochen1990/indent-detector.vim' " solve indent inconsistent problem
	Plug 'luochen1990/select-and-search' " select a piece of code and press n to search next one
	Plug 'wakatime/vim-wakatime' " time log
	Plug 'xuhdev/SingleCompile' " compile and run single file
	Plug 'Shougo/deol.nvim' " shell for nvim/vim8 (better vimshell)
	Plug 'autozimu/LanguageClient-neovim', {'branch': 'next', 'do': 'bash install.sh'} " lsp client: https://microsoft.github.io/language-server-protocol/implementors/tools/
	Plug 'junegunn/fzf' "(Optional) Multi-entry selection UI.

	" forgotten
	Plug 'tpope/vim-fugitive'
	"Plug 'mhinz/vim-startify'
	Plug 'ctrlpvim/ctrlp.vim'
	Plug 'Shougo/unite.vim'
	"Plug 'Shougo/denite.nvim'
	Plug 'Shougo/vimfiler.vim'
	Plug 'Shougo/vimproc.vim', {'do' : 'make'}
	Plug 'Shougo/vimshell.vim'
	Plug 'mileszs/ack.vim' "searching tool
	Plug 'tpope/vim-vinegar'
	Plug 'vim-scripts/Conque-Shell'

	Plug 'Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins'}

	"Plug 'liuchengxu/space-vim-dark'
	"Plug 'altercation/vim-colors-solarized'
	Plug 'tpope/vim-surround'
	Plug 'tpope/vim-repeat'
	"Plug 'rdark'
	"Plug 'genindent.vim'
	Plug 'ervandew/supertab'
	"Plug 'justinmk/vim-sneak'
	Plug 'ap/vim-css-color'
	"Plug 'w0rp/ale'

	" lang specific syntax and indent
	"Plug 'python.vim', {'for': 'python'}
	"Plug 'davidhalter/jedi-vim', {'for': 'python'}
	Plug 'kchmck/vim-coffee-script', {'for': 'coffee'}
	Plug 'digitaltoad/vim-jade', {'for': 'jade'}
	Plug 'wavded/vim-stylus', {'for': 'stylus'}
	Plug 'groenewege/vim-less', {'for': 'less'}
	Plug 'posva/vim-vue', {'for': 'vue'}
	"Plug 'file:///~/Github/vim-haskellConceal'
	"Plug 'Twinside/vim-haskellConceal', {'for': 'haskell'}
	"Plug 'enomsg/vim-haskellConcealPlus', {'for': 'haskell'}
	Plug 'wlangstroth/vim-racket', {'for': 'racket'}
	"Plug 'lambdatoast/elm.vim'
	"Plug 'eagletmt/neco-ghc'
	"Plug 'raichoo/purescript-vim', {'for': 'purescript'}
	Plug 'idris-hackers/idris-vim', {'for': 'idris'}
	"Plug 'trefis/coquille.git'
	"Plug 'let-def/vimbufsync'
	"Plug 'gu-fan/riv.vim'
	Plug 'ElmCast/elm-vim', {'for': 'elm'}
	"Plug 'tasn/vim-tsx'
	Plug 'leafgarland/typescript-vim', {'for': 'typescript'}
	"Plug 'peitalin/vim-jsx-typescript', {'for': 'typescript'}
	Plug 'pangloss/vim-javascript' ", {'for': 'javascript'}
	"Plug 'mxw/vim-jsx', {'for': 'javascript'}
	Plug 'purescript-contrib/purescript-vim'
	"Plug 'roxma/nvim-completion-manager'
	Plug 'derekwyatt/vim-scala'
endfunc

func s:general()
	set nocompatible
	set autoread "lazyredraw
	set visualbell t_vb=
	set history=1000
	set nowritebackup nobackup noswapfile
	set ignorecase smartcase
	"set tags=tags;
	set keymodel=startsel,stopsel selectmode=
	set showtabline=1
	"MOVE CURSOR TO LATEST POS
	auto bufreadpost * silent! exec "normal! g'\""

	if has('mouse')
		set mouse=a mousefocus mousemodel=popup_setpos
	endif

	if has('gui_running')
		set guioptions=r "egmrltT
		if stridx(&guioptions, 'm') >= 0 |set langmenu=zh_cn.utf-8 |source $vimruntime/delmenu.vim |source $vimruntime/menu.vim |endif
		"set guitablabel=%N\ %f
		"if has('win32') || has('win64')
		"	"auto guienter * silent! call libcallnr("vimtweak.dll", 'SetAlpha', 220)
		"	set winaltkeys=no
		"	auto guienter * simalt ~x "MAXIMIZE WINDOW
		"	noremap <a-space> :simalt ~<cr>
		"	inoremap <a-space> <esc>:simalt ~<cr>
		"	"set imactivatekey=c-space
		"	"inoremap <silent> <esc> <esc>:set iminsert=0<cr>
		"	"set iminsert=0
		"endif
	else
		set showmatch matchtime=2
	endif

	"set shell=bash
	"augroup NO_CURSOR_MOVE_ON_FOCUS
	"	au!
	"	au FocusLost * let g:oldmouse=&mouse | set mouse=
	"	au FocusGained * if exists('g:oldmouse') | let &mouse=g:oldmouse | unlet g:oldmouse | endif
	"augroup END
endfunc

func s:personal()
	"let g:sh_no_error = 1
	let dropbox_candidates = [expand('~/Dropbox'), 'D:/Dropbox']
	for d in dropbox_candidates
		if !exists('$Dropbox') && isdirectory(d) |let $Dropbox = d |endif
	endfor
	if exists('$Dropbox') "try to use $Dropbox/Workspace firstly
		let $ws = '$Dropbox/Workspace'
	elseif isdirectory($HOME.'/ws') "try to use $HOME/Workspace secondly
		let $ws = '$HOME/ws'
	else "try to find some place to create ws/ as temp workspace
		let $ws = exists('$DESKTOP')? $DESKTOP : $HOME
		if isdirectory($ws.'/ws')
			let $ws = $ws.'/ws'
		elseif exists('*mkdir')
			call mkdir($ws.'/ws', 'p')
			let $ws = $ws.'/ws'
		endif
	endif

	if exists('$vimconf')
		let $vimrc = $vimconf.'/vimrc'
		let $vimdir = $vimconf.'/vimdir'
	else
		let $vimrc = has('win32')? $HOME.'/_vimrc' : $HOME.'/.vimrc'
		let $vimdir = has('win32')? $HOME.'/vimfiles' : $HOME.'/.vim'
	endif
	cd $ws
	auto vimenter * cd $ws
	auto bufenter * silent! lcd %:p:h "LIKE AUTOCHDIR
endfunc

func s:vimdir()
	if exists('$vimconf')
		call s:expand_rtp([$vimdir]) " + split(glob($vimconf.'/bundle/*'), '\n'))
	endif
endfunc

func s:encoding()
	if !has('multi_byte') |echo 'ALERT: vim_not_has_multi_byte' |endif
	if &termencoding == '' |let &termencoding = &encoding |endif
	set encoding=utf-8
	setglobal fileencoding=utf-8
	set termencoding=utf-8
	"set termencoding=cp936
	"setglobal bomb
	set fileencodings=ucs-bom,ascii,utf-8,gb2312,cp936,gb18030,big5,euc-jp,euc-kr,latin1
	if has('win32') || has('win64') |language messages zh_cn.utf-8 |endif
	"set helplang=zh
	set fileformat=unix
	auto bufenter * silent! if &modifiable && line('$') == 1 && getline('$') == '' |set fileformat=unix |update |endif

	"" autocmds to automatically enter hex mode and handle file writes properly
	"if has("autocmd")
	"	" vim -b : edit binary using xxd-format!
	"	augroup Binary
	"		au!

	"		" set binary option for all binary files before reading them
	"		au BufReadPre *.bin,*.hex setlocal binary

	"		" if on a fresh read the buffer variable is already set, it's wrong
	"		au BufReadPost *
	"				\ if exists('b:editHex') && b:editHex |
	"				\	 let b:editHex = 0 |
	"				\ endif

	"		" convert to hex on startup for binary files automatically
	"		au BufReadPost *
	"				\ if &binary | Hexmode | endif

	"		" When the text is freed, the next time the buffer is made active it will
	"		" re-read the text and thus not match the correct mode, we will need to
	"		" convert it again if the buffer is again loaded.
	"		au BufUnload *
	"				\ if getbufvar(expand("<afile>"), 'editHex') == 1 |
	"				\	 call setbufvar(expand("<afile>"), 'editHex', 0) |
	"				\ endif

	"		" before writing a file when editing in hex mode, convert back to non-hex
	"		au BufWritePre *
	"				\ if exists("b:editHex") && b:editHex && &binary |
	"				\	let oldro=&ro | let &ro=0 |
	"				\	let oldma=&ma | let &ma=1 |
	"				\	silent exe "%!xxd -r" |
	"				\	let &ma=oldma | let &ro=oldro |
	"				\	unlet oldma | unlet oldro |
	"				\ endif

	"		" after writing a binary file, if we're in hex mode, restore hex mode
	"		au BufWritePost *
	"				\ if exists("b:editHex") && b:editHex && &binary |
	"				\	let oldro=&ro | let &ro=0 |
	"				\	let oldma=&ma | let &ma=1 |
	"				\	silent exe "%!xxd" |
	"				\	exe "set nomod" |
	"				\	let &ma=oldma | let &ro=oldro |
	"				\	unlet oldma | unlet oldro |
	"				\ endif
	"	augroup END
	"endif

endfunc

func s:font()
""" `1234567890-= qwertyuiop[]\ asdfghjkl;' zxcvbnm,./
""" ~!@#$%^&*()_+ QWERTYUIOP{}| ASDFGHJKL:" ZXCVBNM<>?
""" Courier New ; Times New Roman
""" use `set guifont=*` to select font from list
	if has("gui_running")
		if has('directx')
			set guifont=Source\ Code\ Pro:h14
			set rop=type:directx,gamma:1.0,contrast:0.5,level:1,geom:1,renmode:4,taamode:1
			if has('multi_byte') && v:version > 601 |set ambiwidth=single |endif
		elseif has("gui_gtk2")
			set guifont=Courier\ 10\ Pitch\ 16
		elseif has("x11")
			set guifont=*-lucidatypewriter-medium-r-normal-*-*-180-*-*-m-*-*
		elseif has("gui_win32")
			set guifont=courier_new:h16
			"auto bufenter * set guifont=courier_new:h16		"一般字体
			"auto bufenter *.txt if &ft=='help'|set gfn=courier_new:h14|endif
			"set guifont=bitstream_vera_sans_mono:h14:cansi " 英文
			"set guifont=arial_monospaced_for_sap:h14:cansi
			"set guifontwide=幼圆:h14.5:cgb2312				" 中文
			"set guifontwide=方正准圆简体:h14.5:cgb2312
		endif
	endif
endfunc

func s:editor()
	"call pathogen#infect()
	filetype plugin indent on

	syntax enable
	set termguicolors
	set background=light
	"silent! colorscheme soladark
	let g:solarized_contrast = "high"
	let g:solarized_degrade = 9
	"silent! colorscheme solarized
	silent! colorscheme rdark2
	"silent! colorscheme codeschool
	"silent! colorscheme desert
	"silent! colorscheme wombat256mod
	"silent! colorscheme grb256
	"silent! colorscheme space-vim-dark
	silent! hi Comment cterm=italic
	silent! hi! link hsString hsNumber

	auto guienter * set cursorline
	set number showmode showcmd ruler
	"if v:version >= 704 |set relativenumber |endif

	set spelllang=en_us,cjk
	"set spell
	"auto bufenter * syntax spell toplevel

	set nowrapscan incsearch hlsearch

	set virtualedit=block
	set foldmethod=syntax foldlevel=10
	set autoindent smartindent
	"set noexpandtab nosmarttab tabstop=4 shiftwidth=4 softtabstop=4 "NOTE: for TAB user. "NOTE: use `:set ts=4 noet | retab!` to switch from SPACE
	set expandtab smarttab tabstop=4 shiftwidth=4 softtabstop=4 "NOTE: for SPACE user. "NOTE: use `:set ts=4 et | retab` to switch from TAB

	set list
	set listchars=tab:⋮\ ,trail:␣,eol:\ ,nbsp:▫		"backup: ⋮☇✓✗▫‚„¬𝄻𝄽
	set laststatus=2

	set nowrap sidescrolloff=20 sidescroll=1
	set wrap textwidth=0 linebreak formatoptions+=mM
	set backspace=start,indent,eol whichwrap=b,<,>,[,]
endfunc

func s:plugins()
	func s:init_coq_ide()
		silent CoqLaunch
		map <buffer> <silent> <F2> :CoqUndo<CR>
		map <buffer> <silent> <F3> :CoqNext<CR>
		map <buffer> <silent> <F4> :CoqToCursor<CR>
	endfunc
	au FileType coq call s:init_coq_ide()

	" CONFIG 'rlue/vim-barbaric'

	" The input method for Normal mode (as defined by `xkbswitch -g` or `ibus engine`)
	let g:barbaric_default = 0

	" The scope where alternate input methods persist (buffer, window, tab, global)
	let g:barbaric_scope = 'buffer'

	" Forget alternate input method after n seconds in Normal mode (disabled by default)
	" Useful if you only need IM persistence for short bursts of active work.
	let g:barbaric_timeout = -1

	" CONFIG 'autozimu/LanguageClient-neovim'

	set completefunc=LanguageClient#complete
	set formatexpr=LanguageClient#textDocument_rangeFormatting_sync()
	set conceallevel=1
	let g:javascript_conceal_function             = "ƒ"
	"let g:javascript_conceal_null                 = "␀"
	let g:javascript_conceal_this                 = "@"
	"let g:javascript_conceal_return               = "⇚"
	"let g:javascript_conceal_undefined            = "¿"
	"let g:javascript_conceal_NaN                  = "ฑ"
	"let g:javascript_conceal_prototype            = "¶"
	let g:javascript_conceal_static               = "•"
	"let g:javascript_conceal_super                = "Ω"
	let g:javascript_conceal_arrow_function       = "⇒"
	"let g:javascript_conceal_noarg_arrow_function = "🞅"
	"let g:javascript_conceal_underscore_arrow_function = "🞅"

	"set hidden

	let g:LanguageClient_autoStart = 1
	let g:LanguageClient_autoStop = 1
	let g:LanguageClient_settingsPath="~/.LanguageClient_settings.json" "seems not working
	let g:LanguageClient_serverCommands = {
	\	'haskell': ['hie-wrapper', '--lsp', '--logfile', '~/.hie.log'],
	\	'rust': ['rustup', 'run', 'stable', 'rls'],
	\	'go': ['go-langserver'],
	\}

	"\	'javascript': ['/opt/javascript-typescript-langserver/lib/language-server-stdio.js'],
	"\	'python': ['pyls'],
	"\	'cpp': ['clangd'],

	"let g:LanguageClient_changeThrottle = 2 "second
	let g:LanguageClient_windowLogMessageLevel = "Log"  " Error | Warning | Info | Log
	let g:LanguageClient_rootMarkers = ['.git*', 'package.*', 'readme*', 'license*']

	let g:LanguageClient_diagnosticsDisplay = {
	\	1: {
	\		"name": "Error",
	\		"texthl": "ALEError",
	\		"signTexthl": "ALEErrorSign",
	\		"virtualTexthl": "Error",
	\	},
	\	2: {
	\		"name": "Warning",
	\		"texthl": "ALEWarning",
	\		"signTexthl": "ALEWarningSign",
	\		"virtualTexthl": "Debug",
	\	},
	\	3: {
	\		"name": "Information",
	\		"texthl": "ALEInfo",
	\		"signText": "I",
	\		"signTexthl": "ALEInfoSign",
	\		"virtualTexthl": "Debug",
	\	},
	\	4: {
	\		"name": "Hint",
	\		"texthl": "ALEInfo",
	\		"signText": "H",
	\		"signTexthl": "ALEInfoSign",
	\		"virtualTexthl": "Debug",
	\	},
	\}

	nnoremap <silent> gm :call LanguageClient_contextMenu()<CR>
	nnoremap <silent> gt :call LanguageClient#textDocument_typeDefinition()<CR>
	nnoremap <silent> gT :call LanguageClient#textDocument_signatureHelp()<CR>
	nnoremap <silent> gh :call LanguageClient#textDocument_hover()<CR>
	nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
	nnoremap <silent> gn :call LanguageClient#textDocument_rename()<CR>
	nnoremap <silent> gf :call LanguageClient#textDocument_formatting()<CR>
	nnoremap <silent> gr :call LanguageClient#textDocument_references()<CR>
	nnoremap <silent> gc :call LanguageClient#textDocument_codeAction()<CR>
	nnoremap <silent> gs :call LanguageClient#textDocument_documentSymbol()<CR>

	let g:vimshell_prompt = '$ '
	let g:mystatusline_activated = 1
	let g:rainbow_active = 1
	let g:rainbow_conf = {
	\	'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
	\	'ctermfgs': ['darkblue', 'darkyellow', 'darkcyan', 'darkmagenta'],
	\	'operators': '_,_',
	\	'parentheses': map(['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/'], 'v:val." fold"'),
	\	'separately': {
	\		'csv': {
	\			'parentheses': ['start=/\v[^,]*\,/ step=// end=/$/ keepend'],
	\		},
	\		'coq': 0,
	\	}
	\}

	let g:syntastic_javascript_checkers = ['eslint']
	let g:syntastic_always_populate_loc_list = 1
	let g:select_and_search_active = 2
	let g:syntastic_cpp_compiler = 'g++'
	let g:syntastic_cpp_compiler_options = ' -std=c++11 -stdlib=libc++'
	let g:syntastic_python_checkers = ['pyflakes']
	let g:syntastic_python3_checkers = ['pyflakes']
	"let g:ctrlp_map = 'e'
	nnoremap <s-e> :CtrlPMixed<cr>
	"nnoremap <s-e> :CtrlPMRUFiles<cr>
	let g:ctrlp_clear_cache_on_exit = 0
	let g:ctrlp_mruf_case_sensitive = 0
	let g:SuperTabNoCompleteAfter = ['^', '\s', ';', '|', ',']
	let g:SuperTabMappingTabLiteral = '<s-tab>'
	let g:SuperTabCrMapping = 0
	let g:purescript_indent_if = 4
	let g:purescript_indent_case = 4
	let g:purescript_indent_let = 4
	let g:purescript_indent_where = 4
	let g:purescript_indent_do = 4
	let g:idris_allow_tabchar = 1
	"let g:jedi#auto_vim_configuration = 0
	"let g:jedi#goto_assignments_command = "<leader>g"
	"let g:jedi#goto_definitions_command = "<leader>d"
	"let g:jedi#documentation_command = "K"
	"let g:jedi#usages_command = "<leader>n"
	""let g:jedi#completions_command = "<tab>"
	"let g:jedi#rename_command = "<leader>r"
	"let g:jedi#show_call_signatures = "1"

	"let g:ale_linters = {
	"\  'haskell': ['brittany'],
	"\  'idris': ['idris'],
	"\  'coffeescript': ['coffee', 'coffeelint'],
	"\  'javascript': ['eslint', 'flow'],
	"\  'vue': ['prettier'],
	"\  'bash': ['shell -n flag'],
	"\  'sql': ['sqlint'],
	"\  'yaml': ['yamllint'],
	"\}
	"highlight clear ALEErrorSign " otherwise uses error bg color (typically red)
	"highlight clear ALEWarningSign " otherwise uses error bg color (typically red)
	let g:ale_sign_error = 'X' " could use emoji
	let g:ale_sign_warning = '?' " could use emoji
	let g:ale_statusline_format = ['X %d', '? %d', '']
	" %linter% is the name of the linter that provided the message
	" %s is the error or warning message
	let g:ale_echo_msg_format = '%linter% says %s'
	" Map keys to navigate between lines with errors and warnings.
	nnoremap <leader>an :ALENextWrap<cr>
	nnoremap <leader>ap :ALEPreviousWrap<cr>

	"nmap f <Plug>Sneak_s
	"nmap F <Plug>Sneak_S
	"xmap f <Plug>Sneak_s
	"xmap F <Plug>Sneak_S
	"omap f <Plug>Sneak_s
	"omap F <Plug>Sneak_S

	let g:vimfiler_as_default_explorer = 1
	let g:vimfiler_ignore_pattern = ['^\.git$', '^\.DS_Store$', '\.pyc$', '\.swp$']
	let g:vimfiler_time_format = "%y-%m-%d %H:%M"
	let g:vimfiler_sort_type = 'T' "NOTE: none|size|extension|filename|time, one char for short, upper case for reverse order
	"https://github.com/Shougo/vimfiler.vim/blob/e15fdc4b52a3d2e082283362ba041126121739f8/autoload/vimfiler/helper.vim#L238

	let g:ackprg = 'ag --vimgrep'
	"let g:ackprg = 'ag --nogroup --nocolor --column'

	if exists('$vimconf')
		source $vimconf/plug.vim
		call plug#begin($vimconf.'/bundle')
		call s:register_plugins()
		call plug#end()
	endif
endfunc

func s:helpers()
	func s:expand_rtp(path)
		let &rtp = join(a:path, ',').','.&rtp.','.join(reverse(map(copy(a:path), 'v:val."/after"')), ',')
	endfunc

	func Repr(s)
		let known = {13: '\r', 10: '\n', 9: '\t', 92: '\\'}
		let r = ''
		for i in range(len(a:s))
			let n = char2nr(a:s[i])
			let r .= has_key(known, n) ? known[n] : ((n >= 32 && n != 127) ? a:s[i] : printf('\x%02x', n))
		endfor
		return '"'.r.'"'
	endfunc

	func S2s()
		let ls = [['，', ','], ['。', '.'], ['‘', "'"], ['“', '"'], ['”', '"'], ['：', ':'], ['（', '('], ['）', ')'], ['《', '<'], ['》', '>'], ['【', '['], ['】', ']'], ['｛', '{'], ['｝', '}'], ['？', '?'], ['！', '!'], ['·', '`'], ['～', '~']]

		for [a, b] in ls
			exec 'silent! :%s/'.a.'/'.b.'/g'
		endfor
	endfunc
	"func! s:py_ver()
	"	python << EOF
	"		import sys
	"		print(sys.version)
	"	EOF
	"endfunc 

	"func! s:py3_ver()
	"	python3 << EOF
	"		import sys
	"		print(sys.version)
	"	EOF
	"endfunc

	command! -nargs=0 -bar PyV call s:py_ver()
	command! -nargs=0 -bar Py3V call s:py3_ver()
	command Syname echo synIDattr(synID(line("."), col("."), 1), "name")

	func Ia_nth_word(args, count, ia)
		let coma = stridx(a:args, ' ')
		let [n, txt] = [strpart(a:args, 0, coma), strpart(a:args, coma+1)]
		let [nxt, prv] = a:ia == 'i' ? ['W', 'B'] : ['E', 'gE']
		let locator = n[0] != '-' ? '^'.repeat(nxt, n) : '$'.repeat(prv, -n)
		exe 'normal! '.join(repeat([locator.a:ia.txt."\x1b"], a:count), 'j')
	endfunc

	func Compilers(mode)
		update
		cd %:p:h
		call CompileRun(a:mode)
		"cd $ws
	endfunc

	func Get_selected_text()
		let tmp = @"
		normal! gvy
		normal! gv
		let [tmp , @"] = [@" , tmp]
		return tmp
	endfunc

	let g:parentheses = [['(', ')'], ['[', ']'], ['{', '}'], ['<', '>'], ['"', '"'], ["'", "'"], ['`', '`']]

	func Substitute_parentheses(lp, rp, parentheses)
		let s = Get_selected_text()
		if len(s) >= 2
			for [lp , rp] in a:parentheses
				if s[0] == lp && s[-1:] == rp
					let s = s[1 : -2]
					break
				endif
			endfor
		endif
		let [tmp, @x] = [@x, a:lp.s.a:rp] |normal! "xp
		let @x = tmp
	endfunc

	func Toggle(stateVar, enableCmd, disableCmd)
		if exists(a:stateVar) && eval(a:stateVar) == 'T'
			for cmd in split(a:disableCmd, ' ;; ')
				exec cmd
			endfor
			exec 'let' a:stateVar '= "F"'
		else
			for cmd in split(a:enableCmd, ' ;; ')
				exec cmd
			endfor
			exec 'let' a:stateVar '= "T"'
		endif
	endfunc
endfunc

func s:keymap()
	let mapleader = ","

	func s:keymap_init()
		call s:basic_operation()
		call s:text_browsing()
		call s:clipboard_synchronizing()
		call s:mode_switching()
		call s:search_result_browsing()
		call s:assistant_panel()
		call s:parentheses_operations()
		call s:compiler_invoking()
		call s:tab_browsing()
		call s:advanced_shotcut()
		call s:structural_editing()
	endfunc

	func s:structural_editing()
	endfunc

	func s:search_result_browsing()
		"nnoremap ? :set hls<cr>
		"nnoremap / :set nohls<cr>0/
		nnoremap / 0/\v

		if has('gui_running') "NOTE: https://stackoverflow.com/questions/3691247/mapping-nohlsearch-to-escape-key
			nnoremap <silent> <esc> :noh<cr>zz
		else
			nnoremap <silent> <esc><esc> :noh<cr>zz<esc>
		endif
	endfunc

	func s:assistant_panel()
		" quickfix
		nnoremap <silent> f :call Toggle('g:qfix', "copen\n normal! zz", 'cclose')<cr>

		auto bufreadpost quickfix nnoremap <buffer> <silent> q :call Toggle('g:qfix', "copen\n normal! zz", 'cclose')<cr>
		auto bufreadpost quickfix nnoremap <buffer> <silent> <cr> <cr>:call Toggle('g:qfix', "copen\n normal! zz", 'cclose')<cr>

		" file explorer
		nnoremap <c-d> :VimFilerExplorer -force-hide<cr>
		nnoremap t :VimFilerExplorer -force-hide<cr>

		" shell
		nnoremap <c-f> :VimShellPop -toggle<cr>
		inoremap <c-f> <esc>:VimShellPop -toggle<cr>

		" switch between panels
		nnoremap ; <c-w><c-w>
	endfunc

	func s:basic_operation()
		map <space> <leader>
		"nnoremap <f1> :nohl<cr>
		nnoremap a <s-a>
		vnoremap <bs> "_x
		nnoremap <s-u> <c-r>
		"nnoremap \/ 0/\v
		"nnoremap s :%s///g<left><left>
		vnoremap s :s///g<left><left>
		"noremap \h :tab h<space>

		nnoremap w :set fenc=<cr>:update<cr>
		nnoremap q :q<cr>
		nnoremap e :e<space>
		"nnoremap <s-e> :exec ':e<space>'.expand('$ws')
		"auto bufenter * exec 'nnoremap <s-e> :e<space>'.expand('%:p:h').'/'
	endfunc

	func s:parentheses_operations()
		func s:map_paratheses_op(start_with)
			"vnoremap <expr> w g:wrap_with_parentheses(v:operator)
			let cmd_pat = 'vnoremap %s%s%s :<c-u>call Substitute_parentheses("%s", "%s", %s)<cr>%s'
			for [lp , rp] in g:parentheses
				for p in [lp , rp]
					let lp_ = escape(lp , '"')
					let rp_ = escape(rp , '"')
					exec printf(cmd_pat, a:start_with, '', p, lp_, rp_, '[]', '')
					exec printf(cmd_pat, a:start_with, 'c', p, lp_, rp_, 'g:parentheses', '')
					exec printf(cmd_pat, a:start_with, 's', p, lp_, rp_, 'g:parentheses', '')
					exec printf(cmd_pat, a:start_with, 'i', p, lp_, rp_, 'g:parentheses', 'gvo<esc>')
					exec printf(cmd_pat, a:start_with, 'a', p, lp_, rp_, 'g:parentheses', '')
				endfor
			endfor
			exec printf(cmd_pat, a:start_with, 'd', '', '', '', 'g:parentheses', '')
		endfunc
		call s:map_paratheses_op('w')
	endfunc

	func s:advanced_shotcut()
		"binary editing: :%!xxd , turn back: :%!xxd -r
		command W w !sudo tee % > /dev/null
		command -nargs=? -range=% Lno :let i=1|<line1>,<line2>g/^/s/^/\=<q-args>!=''?eval(<q-args>):printf("%d",i)/|let i+=1|nohl
		command -nargs=? -range=% Lnos :let i=1|<line1>,<line2>g//s//\=<q-args>!=''?eval(<q-args>):printf("%d",i)/|let i+=1|nohl
		"command -nargs=? -range=% Cid :let i=1|<line1>,<line2>g/^/s/^/\=printf(<q-args>!=''?<q-args>:"%d",i)/|let i+=1|nohl
		"command -nargs=? -range=% Cidx :let i=1|<line1>,<line2>g//s/^/\=printf(<q-args>!=''?<q-args>:"%d",i)/|let i+=1|nohl
		command -range=% DeleteBlankLine :<line1>,<line2>g/^\s*$/d
		command CD :exe 'cd %:p:h'
		"command -complete=file -nargs=+ Diff :exe 'cd %:p:h' |vertical diffsplit <args>
		command -range -nargs=1 WInsert :call Ia_nth_word('<args>', <line2>-<line1>+1, 'i')
		command -range -nargs=1 WAppend :call Ia_nth_word('<args>', <line2>-<line1>+1, 'a')
		command UniqueSpaces :%s/\S\zs\s\+/ /g
		command SyncSearch :let @/=select_and_search#plain_text_pattern(@+)
		command Syn :echo synIDattr(synID(line('.'), col('.'), 0), 'name')
		nnoremap <f1> :echo synIDattr(synID(line('.'), col('.'), 0), 'name')<cr>
		nnoremap <f2> :echo ("hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
		\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
		\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">")<cr>
		nnoremap <f3> :echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')<cr>
		nnoremap <f4> :exec 'syn list '.synIDattr(synID(line('.'), col('.'), 0), 'name')<cr>
		nnoremap <f10> :call pep8#adjust_format()<cr>
		"nnoremap <leader>m :%s/<c-v><cr>//ge<cr>'tzt'm
		command Diff :call Tabmerge('r') | diffthis | let &cursorline = 0 | exec "normal! <c-w><c-w>" | diffthis | let &cursorline = 0
		command -nargs=1 SelectColumn :let @/ = '\v^\s*(\S+\s+){'.<args>.'}\zs\S+'|set hls
	endfunc

	func s:compiler_invoking()
		"load to repl: 加载当前文件到REPL并启动REPL
		nnoremap cr :call Compilers('r')<cr>
		"nnoremap cr :SCCompileRun<cr>

		"compile and execute: 编译当前文件并执行
		"nnoremap ce :call Compilers('e')<cr>
		nnoremap ce :SCCompileRun<cr>

		"translate: 转译当前文件
		nnoremap ct :call Compilers('t')<cr>

		"show AST (yacc output): 查看当前文件的抽象语法树
		nnoremap cy :call Compilers('y')<cr>

		"show high (upper) level IR: 查看当前文件的高级中间表示
		nnoremap cu :call Compilers('u')<cr>

		"show core IR: 查看当前文件的核心中间表示
		nnoremap cI :call Compilers('i')<cr>

		"show optmized core IR: 查看当前文件的优化后的核心中间表示
		nnoremap co :call Compilers('o')<cr>

		"show low level (phisical level) IR: 查看当前文件的底层中间表示 (如ASM, Web ASM, JVM Byte Code)
		nnoremap cp :call Compilers('p')<cr>
	endfunc

	func s:text_browsing()
		"au insertleave,cursormoved * normal! zz
		noremap j gjzz
		noremap k gkzz
		noremap ^ 0
		noremap 0 ^
		noremap - $
		vnoremap - $h
		"nnoremap f 0f
		noremap n nzz
		noremap <s-n> <s-n>zz
		"vnoremap n :<c-u>let @/='\V'.escape(Get_selected_text(),'\')<cr><esc>nzz
		"vnoremap <s-n> :<c-u>let @/=Get_selected_text()<cr><esc><s-n>zz
		noremap * *zz
		noremap # #zz
		noremap <c-o> <c-o>zz
		noremap <c-i> <c-i>zz
		noremap <s-j> <c-d><s-m>
		noremap <s-k> <c-u><s-m>
		noremap <s-h> b
		noremap <s-l> e
		noremap <a-i> :ZoomIn<cr>
		noremap <a-o> :ZoomOut<cr>
		"nnoremap <space> g<c-]>zz
		nnoremap <cr> g<c-]>zz
		nnoremap <bs> <c-o>zz
	endfunc

	func s:clipboard_synchronizing()
		"set clipboard+=unnamed
		noremap x "_x
		nnoremap y "+y
		nnoremap d "+d
		nnoremap p "+p
		nnoremap <s-p> "+<s-p>
		vnoremap y "+y
		vnoremap d "+d
		vnoremap p "+p
		"inoremap <a-p> <esc>"+p
	endfunc

	func s:tab_browsing()
		"nnoremap t :tabe<space>
		"nnoremap <s-t> :exec ':tabe<space>'.expand('$ws')
		"auto bufenter * exec 'nnoremap <s-t> :tabe<space>'.expand('%:p:h').'/'
		"nnoremap tq :q<cr>
		"nnoremap tc g<s-t>:q<cr> "nnoremap tj :tabe<space>$ws<cr> "nnoremap tl :tabe<space>%:p:h\<cr>
		"
		"nnoremap <c-tab> gt
		"nnoremap <c-s-tab> g<s-t>
		"inoremap <c-tab> <esc>gt
		"inoremap <c-s-tab> <esc>g<s-t>
		nnoremap <c-j> <c-w>j
		nnoremap <c-k> <c-w>k
	endfunc

	func Start_stop_recording()
		if has('b:recording') && b:recording == 1
			let b:recording = 0
			echo b:recording
			normal! qQ
		else
			let b:recording = 1
			echo b:recording
			normal! q
		endif
	endfunc

	func s:mode_switching()
		nnoremap b <c-v>
		vnoremap b <c-v>
		vnoremap ii v<c-v><s-i>
		vnoremap aa v<c-v><s-a>
		vnoremap al <s-g><s-v>gg
		vnoremap v <s-v>
		vnoremap <s-v> v

		" record
		nnoremap <a-q> q
		"nnoremap Z <nop>
		nnoremap <s-q> :call Toggle('b:recording', "normal! qr", "normal! q ;; let @r=@r[:-2]")<cr>
		nnoremap R @r
	endfunc

	call s:keymap_init()
endfunc

call s:init()

" vim: set fileformat=unix filetype=vim noexpandtab nosmarttab tabstop=4 shiftwidth=4 softtabstop=4:
