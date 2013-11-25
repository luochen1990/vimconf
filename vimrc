func s:init()
	call s:encoding()
	call s:general()
	call s:font()
	call s:editor()
	call s:bundle()
	call s:plugins()
	call s:global()
	call s:keymap()
endfunc

func s:general()
	if exists('$vimrc') && match($vimrc , '\<Dropbox\>') >= 0
		let $Dropbox = strpart($vimrc, 0, match($vimrc,'\<Dropbox\>')+7)
		let $ws = '$Dropbox/Workspace/vim'
	else
		let $ws = exists('$DESKTOP')? $DESKTOP : $HOME
		if exists('*mkdir')
			if !isdirectory($ws.'/luows')
				call mkdir($ws.'/luows', 'p')
			endif
			let $ws = $ws.'/luows'
		endif
	endif
	if exists('$vimrc') && isdirectory($vimrc.'/../vimdir')
		let $vimdir = '$vimrc/../vimdir'
		let &rtp = $vimdir.','.&rtp.','.$vimdir.'/after'
	endif
	cd $ws
	"auto bufenter * silent! lcd %:p:h "LIKE AUTOCHDIR
	
	set nocompatible 
	set autoread "lazyredraw
	set visualbell "t_vb=
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
		if has('mouse')
			set mouse=a mousefocus
		endif
		if has('win32') || has('win64')
			set winaltkeys=no
			auto guienter * simalt ~x "MAXIMIZE WINDOW
			noremap <a-space> :simalt ~<cr>
			inoremap <a-space> <esc>:simalt ~<cr>
			set imactivatekey=c-space
			"imap <silent> <esc> <esc>:set iminsert=0<cr>
			set iminsert=0
		endif
	else 
		set showmatch matchtime=2
	endif
endfunc

func s:encoding()
	set encoding=utf-8
	set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
	if has('multi_byte') && v:version > 601 |set ambiwidth=double |endif
	"language messages en_us.utf-8
	if has('win32') || has('win64') |language messages zh_cn.utf-8 |endif
	"set helplang=zh
	"set langmenu=zh_cn.utf-8 |source $vimruntime/delmenu.vim  |source $vimruntime/menu.vim
	set fileformat=unix
	auto bufenter * silent! if &modifiable && line('$') == 1 && getline('$') == '' |set fileformat=unix |update |endif
endfunc

func s:font()
""" `1234567890-= qwertyuiop[]\ asdfghjkl;' zxcvbnm,./
""" ~!@#$%^&*()_+ QWERTYUIOP{}| ASDFGHJKL:" ZXCVBNM<>?
""" Courier New ; Times New Roman
	if has('gui_running') "&& (has('win32') || has('win64'))
		set guifont=courier_new:h16
		"auto bufenter * set guifont=courier_new:h16		"一般字体
		"auto bufenter *.txt if &ft=='help'|set gfn=courier_new:h14|endif
		"set guifont=bitstream_vera_sans_mono:h14:cansi	" 英文
		"set guifont=arial_monospaced_for_sap:h14:cansi
		"set guifontwide=幼圆:h14.5:cgb2312				" 中文
		"set guifontwide=方正准圆简体:h14.5:cgb2312
	endif
endfunc

func s:editor()
	"call pathogen#infect()
	filetype plugin indent on
	
	syntax enable
	silent! colorscheme desert
	silent! colorscheme rdark
	auto guienter * set cursorline
	set number showmode showcmd ruler
	if v:version >= 704 |set relativenumber |endif
	
	set nowrapscan incsearch hlsearch
	
	set virtualedit=block,onemore
	set autoindent smartindent
	set noexpandtab nosmarttab tabstop=4 shiftwidth=4 softtabstop=4 " :retab or :retab!

	set laststatus=2
	
	set nowrap sidescrolloff=20 sidescroll=1
	set wrap textwidth=0 linebreak formatoptions+=mM 
	set backspace=start,indent,eol whichwrap=b,<,>,[,]
endfunc

func s:bundle()
	func s:vundle_conf()
		" original repos on github
		"Bundle 'tpope/vim-fugitive'
		"Bundle 'Lokaltog/vim-easymotion'
		"Bundle 'rstacruz/sparkup', {'rtp': 'vim/'}
		"Bundle 'tpope/vim-rails.git'
		" vim-scripts repos
		"Bundle 'L9'
		"Bundle 'FuzzyFinder'
		" non github repos
		"Bundle 'git://git.wincent.com/command-t.git'
		" git repos on your local machine (ie. when working on your own plugin)
		"Bundle 'file:///Users/gmarik/path/to/plugin'
		" ...
	endfunc

	filetype off                   " required!
	if exists('$vimdir')
		set rtp+=$vimdir/bundle/vundle/
	else
		set rtp+=.vim/bundle/vundle/
	endif
	call vundle#rc($vimdir.'/bundle')
	Bundle 'gmarik/vundle'
	Bundle 'kchmck/vim-coffee-script'
	"Bundle 'scrooloose/nerdtree'
	"call s:vundle_conf()
	filetype plugin indent on     " required!
	" Brief help
	" :BundleList          - list configured bundles
	" :BundleInstall(!)    - install(update) bundles
	" :BundleSearch(!) foo - search(or refresh cache first) for foo
	" :BundleClean(!)      - confirm(or auto-approve) removal of unused bundles
	" see :h vundle for more details or wiki for FAQ
	" NOTE: comments after Bundle command are not allowed..
endfunc

func s:plugins()
	let g:rainbow_active = 1
	let g:rainbow_operators = 1
	let g:rainbow_load_separately = [
	\	[ '*' , [['(', ')'], ['\[', '\]'], ['{', '}']] ],
	\	[ '*.tex' , [['(', ')'], ['\[', '\]']] ],
	\	[ '*.{html,htm}' , [['(', ')'], ['\[', '\]'], ['{', '}'], ['<\a[^>]*[^/]>\|<\a>', '</[^>]*>']] ],
	\]
	let g:rainbow_guifgs = ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick',]
	
	let g:mystatusline_activated = 1
	let g:luoc_expert = 1
    
	"let loaded_nerd_tree=1
	let NERDChristmasTree=1
	let NERDTreeCaseSensitiveSort=1
	let NERDTreeQuitOnOpen=1
	nnoremap <silent> <f2> :NERDTree<CR>
endfunc

func s:global()
	func g:indent_detect()
		let tab_used = false
		lines = getline(1 , 100)
		for line in lines

	endfunc

	func g:compilers()
		update
		cd %:p:h
		call g:compileRun()
		cd $ws
	endfunc

	func g:get_selected_text()
		let tmp = @"
		normal! gvy
		normal! gv
		let [tmp , @"] = [@" , tmp]
		return tmp
	endfunc

	let g:parentheses = [['(', ')'], ['[', ']'], ['{', '}'], ['<', '>'], ['"', '"'], ["'", "'"], ['`', '`']]

	func g:substitute_parentheses(lp, rp, parentheses)
		let s = g:get_selected_text()
		if len(s) >= 2
			for [lp , rp] in a:parentheses
				if s[0] == lp && s[-1:] == rp
					let s = s[1 : -2]
					break
				endif
			endfor
		endif
		let [tmp, @"] = [@", a:lp.s.a:rp] |normal! p
		let @" = tmp
	endfunc
endfunc


func s:keymap()
	func s:keymap_init()
		call s:compiler_invoking()
		call s:line_browsing()
		call s:clipboard_synchronizing()
		call s:tab_browsing()
		call s:format_adjusting()
		call s:my_shotcut()
		call s:mode_switching()
	endfunc
	
	func s:my_shotcut()
		command -nargs=? -range=% Cid :let i=1|<line1>,<line2>g/^/s/^/\=printf(<q-args>!=''?<q-args>:"%d",i)/|let i+=1|nohl
		command -nargs=? -range=% Cidx :let i=1|<line1>,<line2>g//s/^/\=printf(<q-args>!=''?<q-args>:"%d",i)/|let i+=1|nohl
		command -range=% Cdbl :<line1>,<line2>g/^\s*$/d
		command -nargs=+ Cvds :vertical diffsplit <args>
		nnoremap <f10> :call pep8#adjust_format()<cr>
		nnoremap <f1> :nohl<cr>
		nnoremap a <s-a>
		nnoremap <s-u> <c-r>
		nnoremap / 0/\v
		nnoremap s :%s///gc<left><left><left>
		vnoremap s :s///g<left><left>
		noremap \h :tab h<space>
		"nnoremap  <leader>m :%s/<c-v><cr>//ge<cr>'tzt'm
		func s:map_paratheses_op(start_with)
			"vnoremap <expr> w g:wrap_with_parentheses(v:operator)
			let cmd_pat = 'vnoremap %s%s%s :<c-u>call g:substitute_parentheses("%s", "%s", %s)<cr>%s'
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
	
	func s:compiler_invoking()
		nnoremap cr :call g:compilers()<cr>
		nnoremap <f9> :call g:compilers()<cr>
		inoremap <f9> <esc>:call g:compilers()<cr>
	endfunc
	
	func s:line_browsing()
		"au insertleave,cursormoved * normal zz
		auto guienter * nnoremap <esc> :nohl<cr>zz
		noremap j gjzz
		noremap k gkzz
		noremap - $
		vnoremap - $h
		nnoremap f 0f
		noremap n nzz
		noremap <s-n> <s-n>zz
		vnoremap n :<c-u>let @/=g:get_selected_text()<cr><esc>nzz
		vnoremap <s-n> :<c-u>let @/=g:get_selected_text()<cr><esc><s-n>zz
		noremap * *zz
		noremap <c-o> <c-o>zz
		noremap <c-i> <c-i>zz
		noremap <s-j> <c-d><s-m>
		noremap <s-k> <c-u><s-m>
		noremap <s-h> b
		noremap <s-l> e
	endfunc
	
	func s:clipboard_synchronizing()
		"set clipboard+=unnamed
		nnoremap y "+y
		nnoremap d "+d
		nnoremap p "+p
		nnoremap <s-p> "+<s-p>
		vnoremap y "+y
		vnoremap d "+d
		vnoremap p "+p
		inoremap <a-p> <esc>"+p
	endfunc
	
	func s:tab_browsing()
		nnoremap w :update<cr>
		nnoremap q :q<cr>
		nnoremap e :e<space>
		auto bufenter * exec 'nnoremap <s-e> :e<space>'.expand('%:p:h').'/'
		nnoremap t :tabe<space>
		auto bufenter * exec 'nnoremap <s-t> :tabe<space>'.expand('%:p:h').'/'
		"nnoremap tq :q<cr>
		"nnoremap tc g<s-t>:q<cr> "nnoremap tj :tabe<space>$ws<cr> "nnoremap tl :tabe<space>%:p:h\<cr>
		nnoremap <c-tab> gt
		nnoremap <c-s-tab> g<s-t>
		inoremap <c-tab> <esc>gt
		inoremap <c-s-tab> <esc>g<s-t>
		nnoremap <c-j> <c-w>j
		nnoremap <c-k> <c-w>k
		inoremap <c-j> <esc><c-w>j
		inoremap <c-k> <esc><c-w>k
	endfunc
	
	func s:format_adjusting()
		nnoremap <space> i<space><esc><right>
		nnoremap <cr> <s-i><cr><esc>
		nnoremap <s-cr> i<cr><esc>
		nnoremap <bs> i<bs><esc><right>
		vnoremap <bs> d
		"inoremap <s-bs> <esc><right>dbi
	endfunc
	
	func s:mode_switching()
		nnoremap b <c-v>
		vnoremap b <c-v>
		vnoremap ii v<c-v><s-i>
		vnoremap aa v<c-v><s-a>
		vnoremap al <s-g><s-v>gg
		vnoremap v <s-v>
		vnoremap <s-v> v
		nnoremap <s-q> q
	endfunc
	
	call s:keymap_init()
endfunc

call s:init()

" vim: set ff=unix ft=vim ts=4:
