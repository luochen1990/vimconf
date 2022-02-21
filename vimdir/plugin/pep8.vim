
func! pep8#adjust_format()
	%s/\([a-zA-Z0-9_'")]\) *\([,:(]\)/\1\2/g
"	call s:adjust_operator()
"	func s:adjust_operator()
"		for i in range(1 , line('$'))
"			let s = getline(i)
"			let sub_pat = '.*[(]'
"			let sub_s = match(s , sub_pat)
"			if sub_s != -1
"				let sub_e = matchend(s , sub_pat)
"				getchar(s , sub_s , sub_e)
"			if match(s , '.*)
"
"
"	
"	if !exists('b:loaded')
"        cal rainbow#load()
"    endif
"    exe 'hi default op_lv0 ctermfg='.s:ctermfgs[-1].' guifg='.s:guifgs[-1]
"    for id in range(1 , s:max)
"        let ctermfg = s:ctermfgs[(s:max - id) % len(s:ctermfgs)]
"        let guifg = s:guifgs[(s:max - id) % len(s:guifgs)]
"        exe 'hi default lv'.id.'c ctermfg='.ctermfg.' guifg='.guifg
"        exe 'hi default op_lv'.id.' ctermfg='.ctermfg.' guifg='.guifg
"    endfor
"    exe 'syn sync fromstart'
"    let b:active = 'active'
endfunc

