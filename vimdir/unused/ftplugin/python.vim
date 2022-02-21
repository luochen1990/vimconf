nnoremap <F9> :call python#CRpython()<cr><cr>
inoremap <F9> <Esc>:call python#CRpython()<cr><cr>

if exists('*python#CRpython')
	finish
endif

func python#CRpython()
	update
	if expand('%:e') == 'py'
		execute "!start cmd /c python %<.py & pause"
	endif
endfunc
