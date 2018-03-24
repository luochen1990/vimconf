func s:init()
	call s:helpers()
	call s:encoding()
	call s:general()
	call s:font()
	call s:editor()
	call s:plugins()
	call s:keymap()
endfunc

func s:general()
	let dropbox_candidates = [expand('~/Dropbox'), 'D:/Dropbox']
	for d in dropbox_candidates
		if !exists('$Dropbox') && isdirectory(d) |let $Dropbox = d |endif
	endfor
	if exists('$Dropbox') "try to use $Dropbox/Workspace firstly
		let $ws = '$Dropbox/Workspace'
	elseif isdirectory($HOME.'/Workspace') "try to use $HOME/Workspace secondly
		let $ws = '$HOME/Workspace'
	else "try to find some place to create /tmpws as backup
		let $ws = exists('$DESKTOP')? $DESKTOP : $HOME
		if isdirectory($ws.'/vimws')
			let $ws = $ws.'/vimws'
		elseif exists('*mkdir')
			call mkdir($ws.'/vimws', 'p')
			let $ws = $ws.'/vimws'
		endif
	endif

	if exists('$vimconf')
		let $vimrc = $vimconf.'/vimrc'
		let $vimdir = $vimconf.'/vimdir'
		call s:expand_rtp([$vimdir]) " + split(glob($vimconf.'/bundle/*'), '\n'))
	else
		let $vimrc = has('win32')? $HOME.'/_vimrc' : $HOME.'/.vimrc'
		let $vimdir = has('win32')? $HOME.'/vimfiles' : $HOME.'/.vim'
	endif
	cd $ws
	auto vimenter * cd $ws
	auto bufenter * silent! lcd %:p:h "LIKE AUTOCHDIR

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

	if has('gui_running')
		set guioptions=r "egmrltT
		if stridx(&guioptions, 'm') >= 0 |set langmenu=zh_cn.utf-8 |source $vimruntime/delmenu.vim |source $vimruntime/menu.vim |endif
		"set guitablabel=%N\ %f
		if has('mouse')
			set mouse=a mousefocus mousemodel=extend
		endif
		if has('gui_running') "has('win32') || has('win64')
			"auto guienter * silent! call libcallnr("vimtweak.dll", 'SetAlpha', 220)
			set winaltkeys=no
			auto guienter * simalt ~x "MAXIMIZE WINDOW
			noremap <a-space> :simalt ~<cr>
			inoremap <a-space> <esc>:simalt ~<cr>
			"set imactivatekey=c-space
			"inoremap <silent> <esc> <esc>:set iminsert=0<cr>
			"set iminsert=0
		endif
	else
		set showmatch matchtime=2
	endif

	"augroup NO_CURSOR_MOVE_ON_FOCUS
	"	au!
	"	au FocusLost * let g:oldmouse=&mouse | set mouse=
	"	au FocusGained * if exists('g:oldmouse') | let &mouse=g:oldmouse | unlet g:oldmouse | endif
	"augroup END
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
	"if has('multi_byte') && v:version > 601 |set ambiwidth=double |endif "conflict with spacevim
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
	"silent! colorscheme desert
	silent! colorscheme rdark2
	"silent! colorscheme wombat256mod
	"silent! colorscheme grb256
	"silent! colorscheme codeschool
	"silent! colorscheme space-vim-dark
	"set background=light
	"colorscheme solarized
	silent! hi Comment cterm=italic

	auto guienter * set cursorline
	set number showmode showcmd ruler
	"if v:version >= 704 |set relativenumber |endif

	"set spell spelllang=en_us
	auto bufenter * syntax spell notoplevel
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
	func s:vundle_conf() "NOTE: comments after Bundle command are not allowed..
		Bundle 'luochen1990/rainbow'
		Bundle 'luochen1990/indent-detector.vim'
		Bundle 'luochen1990/select-and-search'
		"Bundle 'mhinz/vim-startify'
		Bundle 'ctrlpvim/ctrlp.vim'
		Bundle 'Shougo/vimproc.vim'
		Bundle 'Shougo/vimshell.vim'
		Bundle 'vim-scripts/Conque-Shell'
		"Bundle 'liuchengxu/space-vim-dark'
		"Bundle 'altercation/vim-colors-solarized'
		"Bundle 'wakatime/vim-wakatime'
		"Bundle 'rdark'
		"Bundle 'genindent.vim'
		Bundle 'ervandew/supertab'
		"Bundle 'justinmk/vim-sneak'
		"Bundle 'ap/vim-css-color'
		"Bundle 'scrooloose/syntastic'
		Bundle 'scrooloose/nerdtree'
		Bundle 'Xuyuanp/nerdtree-git-plugin'
		"Bundle 'python.vim'
		"Bundle 'davidhalter/jedi-vim'
		Bundle 'kchmck/vim-coffee-script'
		"Bundle 'digitaltoad/vim-jade'
		"Bundle 'wavded/vim-stylus'
		"Bundle 'groenewege/vim-less'
		Bundle 'posva/vim-vue'
		"Bundle 'wlangstroth/vim-racket'
		"Bundle 'lambdatoast/elm.vim'
		"Bundle 'eagletmt/neco-ghc'
		"Bundle 'clausreinke/typescript-tools.vim'
		"Bundle 'leafgarland/typescript-vim'
		"Bundle 'raichoo/purescript-vim'
		Bundle 'idris-hackers/idris-vim'
		"Bundle 'trefis/coquille.git'
		"Bundle 'let-def/vimbufsync'
		Bundle 'gu-fan/riv.vim'
	endfunc
	if isdirectory($vimconf.'/bundle/vundle')
		let g:vundle_default_git_proto = 'git'
		filetype off
		set rtp+=$vimconf/bundle/vundle/
		call vundle#rc($vimconf.'/bundle')
		Bundle 'gmarik/vundle'
		call s:vundle_conf()
		filetype plugin indent on
	endif

	func s:init_coq_ide()
		silent CoqLaunch
		map <buffer> <silent> <F2> :CoqUndo<CR>
		map <buffer> <silent> <F3> :CoqNext<CR>
		map <buffer> <silent> <F4> :CoqToCursor<CR>
	endfunc
	au FileType coq call s:init_coq_ide()

	let g:vimshell_prompt = '$ '
	let g:mystatusline_activated = 1
	let g:rainbow_active = 1
	let g:rainbow_conf = {
	\	'separately': {
	\		'stylus': {
	\			'parentheses': ['start=/{/ end=/}/ fold contains=@colorableGroup'],
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
	let g:SuperTabNoCompleteAfter = ['\s', ';', '|']
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
	"let loaded_nerd_tree=1
	"let NERDChristmasTree=1
	"let NERDTreeCaseSensitiveSort=1
	"let NERDTreeQuitOnOpen=1
	"nnoremap <silent> <f2> :NERDTree<CR>

	"nmap f <Plug>Sneak_s
	"nmap F <Plug>Sneak_S
	"xmap f <Plug>Sneak_s
	"xmap F <Plug>Sneak_S
	"omap f <Plug>Sneak_s
	"omap F <Plug>Sneak_S

	" Automatically quit vim if NERDTree is last and only buffer
	autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
	let g:NERDTreeIgnore=['\.pyc','\~$','\.swp']
	let g:NERDTreeNaturalSort=1
	let g:NERDTreeQuitOnOpen=1
	let g:NERDTreeChDirMode=2
	let g:NERDTreeSortOrder=['\/$', '*']
	let g:NERDTreeMouseMode=2
	let g:NERDTreeNotificationThreshold = 500
	let g:NERDTreeIndicatorMapCustom = {
		\ "Modified"  : "✹",
		\ "Staged"	  : "✚",
		\ "Untracked" : "✭",
		\ "Renamed"   : "➜",
		\ "Unmerged"  : "═",
		\ "Deleted"   : "✖",
		\ "Dirty"	  : "✗",
		\ "Clean"	  : "✔︎",
		\ "Unknown"   : "?"
		\ }

	"let g:nerdtreeOpened = 0
	"func ToggleNerdtree()
	"	if g:nerdtreeOpened == 0
	"		NERDTree
	"		echo 0
	"		let g:nerdtreeOpened = 1
	"	else
	"		NERDTreeClose
	"		echo 1
	"		let g:nerdtreeOpened = 0
	"	endif
	"endfunc
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

	func Compilers()
		update
		cd %:p:h
		call CompileRun()
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
endfunc

func s:keymap()
	func s:keymap_init()
		call s:basic_operation()
		call s:text_browsing()
		call s:clipboard_synchronizing()
		call s:mode_switching()
		call s:parentheses_operations()
		call s:compiler_invoking()
		call s:format_adjusting()
		"call s:tab_browsing()
		call s:advanced_shotcut()
		"let NERDTreeWinPos="right"
		"nnoremap tt :NERDTree<cr>
		"nnoremap tc :NERDTreeClose<cr>
	endfunc

	func s:basic_operation()
		"nnoremap <f1> :nohl<cr>
		nnoremap a <s-a>
		vnoremap <bs> "_x
		nnoremap <s-u> <c-r>
		nnoremap / 0/
		"nnoremap \/ 0/\v
		"nnoremap s :%s///g<left><left>
		vnoremap s :s///g<left><left>
		"noremap \h :tab h<space>

		nnoremap w :set fenc=<cr>:update<cr>
		nnoremap q :q<cr>
		nnoremap e :e<space>
		"nnoremap <s-e> :exec ':e<space>'.expand('$ws')
		"auto bufenter * exec 'nnoremap <s-e> :e<space>'.expand('%:p:h').'/'
		"nnoremap t :call ToggleNerdtree()<cr>
		"nnoremap t :NERDTreeToggle<cr>
		"nnoremap <silent> t :NERDTreeFind<cr>
		nnoremap <silent> t :NERDTreeFocus<cr>
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
		nnoremap <f10> :call pep8#adjust_format()<cr>
		"nnoremap <leader>m :%s/<c-v><cr>//ge<cr>'tzt'm
		command Diff :call Tabmerge('r') | diffthis | exec "normal! <c-w><c-w>" | diffthis
	endfunc

	func s:compiler_invoking()
		nnoremap cr :call Compilers()<cr>
		nnoremap <f9> :call Compilers()<cr>
		inoremap <f9> <esc>:call Compilers()<cr>
	endfunc

	func s:text_browsing()
		"au insertleave,cursormoved * normal! zz
		nnoremap <esc> :noh<cr>zz
		"NOTE: this will do some strange things(enter insert mode and ..) on RHEL when vim enter, so you can use the following one to avoid that
		"auto guienter * nnoremap <esc> :noh<cr>zz
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
		nnoremap <cr> g<c-]>zz
		nnoremap <bs> <c-o>zz
	endfunc

	func s:clipboard_synchronizing()
		"set clipboard+=unnamed
		noremap x "_x
		nnoremap y "*y
		nnoremap d "*d
		nnoremap p "*p
		nnoremap <s-p> "*<s-p>
		vnoremap y "*y
		vnoremap d "*d
		vnoremap p "*p
		"inoremap <a-p> <esc>"*p
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
		"nnoremap <c-j> <c-w>j
		"nnoremap <c-k> <c-w>k
	endfunc

	func s:format_adjusting()
		"nnoremap <space> i<space><esc><right>
		"nnoremap <cr> <s-i><cr><esc>
		"nnoremap <s-cr> i<cr><esc>
		"nnoremap <bs> i<bs><esc><right>
		""inoremap <s-bs> <esc><right>dbi
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
		nnoremap Z <nop>
		nnoremap <s-q> qZ
		nnoremap <s-r> @Z
	endfunc

	call s:keymap_init()
endfunc

call s:init()

" vim: set fileformat=unix filetype=vim noexpandtab nosmarttab tabstop=4 shiftwidth=4 softtabstop=4:
