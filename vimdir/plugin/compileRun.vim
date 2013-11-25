"func g:compileRun_qf()
"	if &filetype == 'cpp11'
"		"let out = expand('%:p:h').'\out'
"		let out = expand('%<').'.exe'
"        if filereadable(out)
"            exec '!start cmd /c del '.out
"        endif
"		let &makeprg = 'g++ -Wall -Wno-unused -std=c++11 -o '.out.' %'
"		make | cw
"        if filereadable(out)
"			if filereadable(expand('%:p:r').'.cin')
"				exec '!start cmd /c '.out.' < %<.cin && pause'
"			else
"				exec '!start cmd /c '.out.' && pause'
"			endif
"        endif
"	endif
"	
"	if &filetype == 'cpp'
"		let out = expand('%<').'.exe'
"        if filereadable(out)
"            exec '!start cmd /c del '.out
"        endif
"		let &makeprg = 'g++ -Wall -Wno-unused -std=c++98 -o '.out.' %'
"		make | cw
"        if filereadable(out)
"			if filereadable(expand('%:p:r').'.cin')
"				exec '!start cmd /c '.out.' < %<.cin && pause'
"			else
"				exec '!start cmd /c '.out.' && pause'
"			endif
"        endif
"	endif
"	
"	if &filetype == 'python'
"		exec "! python %:p"
"	endif
"	
"	if &filetype == 'pythonw'
"		exec "!start cmd /c pythonw %:p"
"	endif
"	
"	if &filetype == 'haskell'
"		exec "!start cmd /c ghci %"
"	endif
"	
"	if &filetype == 'tex'
"		exec '!start cmd /c del %:p:r.pdf && xelatex %:p && del %:p:r.aux && del %:p:r.log'
"		for cnt in range(10)
"			sleep 200m
"			if filereadable(expand('%:p:r').'.pdf')
"				silent ! start %:p:r.pdf
"				break
"			endif
"		endfor
"		if cnt == 9
"			! echo FILE UNREADABLE.
"		endif
"	endif
"endfunc

func g:compileRun()
	if &filetype == 'cpp11'
		let out = '%:p:h\out'
		let run = out.(filereadable(expand('%:p:r').'.cin')? ' < %:p:r.cin' : '')
		execute '!start cmd /c g++ %:p:r.cpp -Wall -Wno-unused -std=c++11 -o '.out.' & '.run.' & pause'
	endif
	
	if &filetype == 'cpp'
		if match(getline(1) , '//vc') != -1
			let vcpath = 'f:\desktop\vc2010'
			"let vcpath = expand('$vc')
			let vcload = 'd:\appfordevelop\vs10\common7\tools\vsvars32.bat'
			exec '!start cmd /c '.vcload.' & cl %:p & %:p:r.exe & del %:p:r.obj & pause'
		else
			let out = '%:p:h\out'
			let run = out.(filereadable(expand('%:p:r').'.cin')? ' < %:p:r.cin' : '')
			execute '!start cmd /c g++ %:p:r.cpp -Wall -Wno-unused -std=c++98 -o '.out.' & '.run.' & pause'
		endif
	endif
	
	if expand('%:e') == 'cin'
		e %<.cpp | normal ggVG"+y
		let out = '%:p:h\out'
		let run = out.(filereadable(expand('%:p:r').'.cin')? ' < %:p:r.cin' : '')
		execute '!start cmd /c g++ %:p:r.cpp -Wall -Wno-unused -std=c++98 -o '.out.' & '.run.' & pause'
	endif
	
	if &filetype == 'python'
		execute "!start cmd /c python %:p & pause"
	endif
	
	if &filetype == 'pythonw'
		execute "!start cmd /c pythonw %:p"
	endif
	
	if &filetype == 'python3'
		execute "!start cmd /c python3 %:p & pause"
	endif
	
	if &filetype == 'pythonw3'
		execute "!start cmd /c pythonw3 %:p"
	endif
	
	if &filetype == 'tex'
		exe '!start cmd /c del %:p:r.pdf & xelatex %:p:r.tex & del %:p:r.aux & del %:p:r.log'
		let cnt = 0
		while cnt < 10
			let cnt += 1
			sleep 500m
			if filereadable(expand('%:p:r').'.pdf')
				exe '!start cmd /c acrord32 %:p:r.pdf'
				break
			endif
		endwhile
		if cnt == 10
			exe '! cmd /c echo file unreadable !'
		endif
	endif
	
	if &filetype == 'coffee'
		exe '! coffee -c %:p'
	endif
	
	if &filetype == 'html'
		exe '!start C:\Program Files\Internet Explorer\iexplore.exe %:p'
	endif
endfunc

"func g:compileCmd()
"	if &ft == 'cpp'
"		return 'g++ -Wall -Wno-unused -o %<.exe % & %<.exe & pause'
"		"let out = '%:p:h\out'
"		"let run = out.(filereadable(expand('%:p:r').'.cin')? ' < %:p:r.cin' : '')
"		"return 'g %:p:r.cpp -Wall -Wno-unused -std=c++11 -o '.out.' & '.run.' & pause'
"	endif
"	
"	if &ft == 'py'
"		return 'python %:p & pause'
"	endif
"	
"	if &ft == 'pyw'
"		return 'pythonw %:p'
"	endif
"	
"endfunc

"func g:compileRun()
"	if expand('%:e') == 'cin'
"		e %<.cpp | normal ggvg"+y
"		let out = '%:p:h\out'
"		let run = out.(filereadable(expand('%:p:r').'.cin')? ' < %:p:r.cin' : '')
"		execute '!start cmd /c g++ %:p:r.cpp -Wall -Wno-unused -std=c++98 -o '.out.' & '.run.' & pause'
"	endif
"	
"	if expand('%:e') == 'cpp'
"		if match(getline(1) , '//vc') != -1
"			let vcpath = 'f:\desktop\vc2010'
"			"let vcpath = expand('$vc')
"			let vcload = 'd:\appfordevelop\vs10\common7\tools\vsvars32.bat'
"			exec '!start cmd /c '.vcload.' & cl %:p & %:p:r.exe & del %:p:r.obj & pause'
"		elseif match(getline(1) , '//cpp11') != -1 || match(getline(1) , '//c++11') != -1
"			let out = '%:p:h\out'
"			let run = out.(filereadable(expand('%:p:r').'.cin')? ' < %:p:r.cin' : '')
"			execute '!start cmd /c g++ %:p:r.cpp -Wall -Wno-unused -std=c++11 -o '.out.' & '.run.' & pause'
"		else
"			e %<.cpp | normal ggvg"+y
"			let out = '%:p:h\out'
"			let run = out.(filereadable(expand('%:p:r').'.cin')? ' < %:p:r.cin' : '')
"			execute '!start cmd /c g++ %:p:r.cpp -Wall -Wno-unused -std=c++98 -o '.out.' & '.run.' & pause'
"		endif
"	endif
"	
"	if expand('%:e') == 'py'
"		if getline(1) == '#pyw'
"			execute "!start cmd /c pythonw %:p"
"		else
"			execute "!start cmd /c python %:p & pause"
"		endif
"	endif
"	
"	if expand('%:e') == 'pyw'
"		if getline(1) == '#py'
"			execute "!start cmd /c python %:p & pause"
"		else
"			execute "!start cmd /c pythonw %:p"
"		endif
"	endif
"	
"	if expand('%:e') == 'tex'
"		exe '!start cmd /c del %:p:r.pdf & xelatex %:p:r.tex & del %:p:r.aux & del %:p:r.log'
"		let cnt = 0
"		while cnt < 10
"			let cnt += 1
"			sleep 500m
"			if filereadable(expand('%:p:r').'.pdf')
"				exe '!start cmd /c acrord32 %:p:r.pdf'
"				break
"			endif
"		endwhile
"		if cnt == 10
"			exe '! cmd /c echo file unreadable !'
"		endif
"	endif
"endfunc

"auto bufenter * let &makeprg = g:compileRun()

