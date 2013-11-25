nnoremap <F9> :call tex#CRtex()<cr><cr>
inoremap <F9> <Esc>:call tex#CRtex()<cr><cr>

if exists('*tex#CRtex')
	finish
endif

func tex#CRtex()
	update
	if expand('%:e') == 'tex'
		exe '!start cmd /c del %<.pdf & xelatex %<.tex & del %<.aux & del %<.log'
		let cnt = 0
		while cnt < 50
			let cnt += 1
			sleep 100m
			if filereadable(expand('%<').'.pdf')
				exe '!start cmd /c AcroRd32 %<.pdf'
				break
			endif
		endwhile
		if cnt == 50
			exe '! cmd /c echo File Unreadable !'
		endif
		"if filereadable(expand('%<').'.pdf')
		"	exe '!start cmd /c AcroRd32 %<.pdf'
		"else
		"	exe '! cmd echo file unreadable!! & pause'
		"endif
	endif
endfunc
