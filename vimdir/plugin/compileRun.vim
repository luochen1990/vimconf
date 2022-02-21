if exists('s:loaded') | finish | endif | let s:loaded = 1

func CompileRun(mode)
	if a:mode == 'e'
		SCCompileRun
		"normal! :SCCompileRun<cr>
		return
	endif
	"elseif a:mode == 'r'
	"	TREPLSendFile
	"	return
	"endif

	if &filetype == 'cpp'
		if a:mode == 'e' || a:mode == 'r'
			if match(getline(1) , '//vc') != -1
				let vcpath = 'f:\desktop\vc2010'
				"let vcpath = expand('$vc')
				let vcload = 'd:\appfordevelop\vs10\common7\tools\vsvars32.bat'
				exec '!start cmd /c '.vcload.' & cl %:p & %:p:r.exe & del %:p:r.obj & pause'
			else
				if match(getline(1) , '//c++98') != -1
					let std = 'c++98'
				elseif match(getline(1) , '//c++11') != -1
					let std = 'c++11'
				elseif match(getline(1) , '//c++14') != -1
					let std = 'c++14'
				else
					let std = 'c++14'
				endif

				let out = '%:p:h\out'
				let run = out.(filereadable(expand('%:p:r').'.cin')? ' < %:p:r.cin' : '')
				execute '!start cmd /c g++ %:p -Wall -D__NO_INLINE__ -Wno-unused -O2 -std='.std.' -o '.out.' & '.run.' & pause'
				"execute '!start cmd /c g++ %:p -Wall -Wno-unused -O2 -lboost_coroutine -std='.std.' -o '.out.' & '.run.' & pause'
				"g++ Test.cpp -o Test -Wall -O2 -lboost_coroutine -std=c++11
			endif
		elseif a:mode == 'o' || a:mode == 'p'
			execute '!start cmd /c g++ %:p -Wall -D__NO_INLINE__ -Wno-unused -O2 -std=c++14 -S & cat %:r.s & pause'
		elseif a:mode == 'y'
			execute '!start cmd /c g++ %:p -Wall -D__NO_INLINE__ -Wno-unused -O2 -std=c++14 -E & pause'
		endif
	endif
	
	if expand('%:e') == 'cin'
		e %<.cpp | normal ggVG"+y
		let out = '%:p:h\out'
		let run = out.(filereadable(expand('%:p:r').'.cin')? ' < %:p:r.cin' : '')
		execute '!start cmd /c g++ %:p:r.cpp -Wall -Wno-unused -std=c++98 -o '.out.' & '.run.' & pause'
	endif
	
	if &filetype == 'c'
		if a:mode == 'e' || a:mode == 'r'
			let out = '%:p:h\out'
			let run = out.(filereadable(expand('%:p:r').'.cin')? ' < %:p:r.cin' : '')
			execute '!start cmd /c gcc %:p -Wall -D__NO_INLINE__ -Wno-unused -O2 -o '.out.' & '.run.' & pause'
		endif
	endif
	
	if &filetype[:5] == 'python'
		execute "!start cmd /c ".&filetype." %:p & pause"
	endif
	
	"if &filetype == 'pythonw'
	"	execute "!start cmd /c pythonw %:p"
	"endif
	"
	"if &filetype == 'python3'
	"	execute "!start cmd /c python3 %:p & pause"
	"endif
	"
	"if &filetype == 'pythonw3'
	"	execute "!start cmd /c pythonw3 %:p"
	"endif
	
	if &filetype == 'tex'
		exe '!start cmd /c del %:p:r.pdf && xelatex %:p:r.tex && del %:p:r.aux && del %:p:r.log'
		"let cnt = 0
		"while cnt < 10
		"	let cnt += 1
		"	sleep 500m
		"	if filereadable(expand('%:p:r').'.pdf')
		"		"exe '!start cmd /c acrord32 %:p:r.pdf'
		"		exe '!start cmd /c SumatraPDF %:p:r.pdf'
		"		break
		"	endif
		"endwhile
		"if cnt == 10
		"	exe '! cmd /c echo file unreadable !'
		"endif
	endif

	if &filetype == 'markdown'
		if a:mode == 'r'
			if search('\n\n----\?\n\n', 'wn', 0, 50) == 0 "no horizentol or vertical bar
				exe 'silent !start chrome --allow-file-access-from-files --Incognito %:p'
			else
				exe '!start cmd /c reveal-md -w "%"'
				"exe 'silent !start reveal-md %:p' "this not available, not sure why.
			endif
		elseif a:mode == 'e'
			exec '!start cmd /c mdpdf "%" & pause'
		endif
	endif

	if &filetype == 'java'
		if a:mode == 'r'
			"exec '!start cmd /c jshell --startup %'
			exec 'VimShellInteractive jshell --startup '.expand('%')
		elseif a:mode == 'e'
			exec "!start cmd /c javac %:p & java -cp %:p:h %:r & pause"
		endif
	endif

	if &filetype == 'javascript'
		if a:mode == 'r'
			exec '!start cmd /k cat % - | node -i'
		elseif a:mode == 'e'
			exec '!start cmd /k node %'
		endif
	endif

	if &filetype == 'coffee'
		if a:mode == 'r'
			if filereadable(expand('%:p:r').'.html')
				if filereadable(expand('%:p:r').'.js')
					let r = system('coffee -cm '.expand('%:p'))
					echo r
				endif
				"exe 'silent !start chrome --allow-file-access-from-files --Incognito %:p:r.html'
				"exe '!start cmd /k coffee %:p'
			else
				"exec '!start cmd /k coffee %'
				exec 'VimShellInteractive coffee '.expand('%')
			endif
		elseif a:mode == 'e'
			exec '!start cmd /k coffee %'
		elseif a:mode == 't'
			exec '!start cmd /k decaffeinate --use-cs2 --use-optional-chaining --loose --disable-suggestion-comment  % && cat %:r.js'
		elseif a:mode == 'y'
			exec '!start cmd /k coffee --nodes "%"'
		elseif a:mode == 'u'
			exec '!start cmd /k coffee --print "%"'
		elseif a:mode == 'i'
			exec '!start cmd /k coffee -p "%"'
		elseif a:mode == 'o'
			exec '!start cmd /k coffee -p "%"'
		elseif a:mode == 'p'
			exec '!start cmd /k coffee -p "%"'
		endif
	endif
	
	if &filetype == 'lisp'
		exe '! sbcl --disable-debugger --load %:p'
	endif

	if &filetype == 'racket'
		exe '! racket -t %:p'
	endif

	if &filetype == 'scheme'
		exe '! racket -t %:p'
	endif

	if &filetype == 'haskell' || &filetype == 'lhaskell'
		if a:mode == 'r'
			"exec '!start stack exec -- ghci -i../src:../../src:../../../src "%"'
			exec 'VimShellInteractive stack exec -- ghci -i../src:../../src:../../../src '.expand('%')
		elseif a:mode == 'e'
			"let output = system("ghc -H100M -O3 -Wall -prof -auto-all -rtsopts -o out +RTS -K1G -M2G -RTS ".expand("%:p")) " -fforce-recomp
			let output = system("stack exec -- ghc -H100M -O3 -rtsopts -o out +RTS -K1G -M2G -RTS ".expand("%"))
			if v:shell_error == 0
				call system("del ".expand("%:p:r").".hi ".expand("%:p:r").".o")
				exec "!start cmd /c out +RTS -s && pause"
			else
				echo output
			endif
		elseif a:mode == 't'
			exec "!start cmd /c hastec \"%\" --onexec --opt-all --opt-minify=off && node \"%:r.js\" && pause"
		elseif a:mode == 'y'
			exec '!stack exec -- ghc -S -ddump-parsed-ast "%"'
		elseif a:mode == 'u'
			exec '!stack exec -- ghc -S -ddump-simpl "%"'
		elseif a:mode == 'i'
			exec '!stack exec -- ghc -S -ddump-stg "%"'
		elseif a:mode == 'o'
			exec '!stack exec -- ghc -S -ddump-llvm "%"'
		elseif a:mode == 'p'
			exec '!stack exec -- ghc -S -ddump-asm "%"'
		endif
	endif

	if &filetype == 'idris' || &filetype == 'lidris'
		if a:mode == 'r'
			"exe '!start cmd /c idris -p contrib -p effects -p prelude -p pruviloj -p lightyear -p idrisscript "%"'
			exec 'VimShellInteractive idris -p contrib -p effects -p prelude -p pruviloj -p lightyear -p idrisscript '.expand('%')
		elseif a:mode == 'e'
			let output = system("idris -p contrib -p effects -p prelude -p pruviloj -p lightyear -p idrisscript -o out ".expand("%:p"))
			if v:shell_error == 0
				"call system("del ".expand("%:p:r").".hi ".expand("%:p:r").".o")
				exec "!start cmd /c out && pause"
			else
				echo output
			endif
		elseif a:mode == 't'
			exe '!start cmd /c rm -f "%:r.js" & idris -p contrib -p effects -p prelude -p pruviloj -p lightyear -p idrisscript --codegen node "%" -o "%:r.js" & cat "%:r.js" & pause'
		endif
	endif

	if &filetype == 'purescript'
		cd %:p:h
		while !filereadable('./psc-package.json')
			cd ..
		endwhile
		if a:mode == 'r'
			if match(expand('%'), '^src') >= 0 "under src/ dir
				exe '!start cmd /c psc-package repl & pause'
			else
				if match(expand('%:t'), '\.test\.purs$') >= 0 "is test file
					exe '!start cmd /c psc-package repl "%:r:r.purs" "%" & pause'
				else
					exe '!start cmd /c psc-package repl "%" & pause'
				endif
			endif
		elseif a:mode == 'e'
			exe '!start cmd /c purs repl "%" & pause'
		elseif a:mode == 't'
			exe '!start cmd /c purs compile "%" & pause'
		endif
	endif

	if &filetype == 'rust'
		let extra_path = '' " 'C:\dev\Go\pkg\tool\windows_amd64'
		if a:mode == 'r'
			exec '!start cmd /c set PATH='.extra_path.';\%PATH\% & rustc % & pause'
		elseif a:mode == 'e'
			exec '!start cmd /c set PATH='.extra_path.';\%PATH\% & rustc % & pause'
		endif
	endif

	if &filetype == 'go'
		if a:mode == 'r'
			exec 'VimShellInteractive gore -context '.expand('%')
		endif
	endif

	if expand('%:e') == 'gv' "file used by graphviz, generated by gvedit using the DOT lang
		"dot -K? -- Use one of: circo dot fdp neato nop nop1 nop2 osage patchwork sfdp twopi
		exec '!start gvedit "%"'
		"exec '!start cmd /c dot -Kdot -Grankdir=LR -Granksep=0.3 -Gnodesep=0.05 -Gbgcolor="\#aaaa005f" -Nfontsize=12 -Nfontname="Source Code Pro" -Nshape=rect -Nheight=0.4 -Nstyle=filled -Tsvg -o "%:r.svg" "%" && "%:r.svg"'
	endif

	if &filetype == 'html'
		exec 'silent !start chrome --allow-file-access-from-files --Incognito %:p'
		"exe '!start iexplore %:p'
	endif
endfunc

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

"func CompileRun()
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

"auto bufenter * let &makeprg = CompileRun()

