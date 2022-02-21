if exists('*luoc#load')
	finish
endif

func luoc#load()
	nnoremap <buffer> <F9> :call luoc#CompileRun()<cr><cr>
	inoremap <buffer> <F9> <Esc>:call luoc#CompileRun()<cr><cr>

	let g:luoc_blockViaIndent   = s:withDefault('g:luoc_blockViaIndent'  , s:if_expert(1 , 0))
	let g:luoc_typeofSupported  = s:withDefault('g:luoc_typeofSupported' , s:if_expert(1 , 0))
	let g:luoc_extendKeywords   = s:withDefault('g:luoc_extendKeywords'  , s:if_expert(1 , 1))
	let g:luoc_blockStyle       = s:withDefault('g:luoc_blockStyle'      , s:if_expert(1 , 0))
	let g:luoc_keepOriginal     = s:withDefault('g:luoc_keepOriginal'    , s:if_expert(0 , 1))
	let g:luoc_showGenerated    = s:withDefault('g:luoc_showGenerated'   , s:if_expert(1 , 1))
	if g:luoc_extendKeywords
		let g:luoc_keywords		= ['if' , 'elif' , 'else' , 'for' , 'do' , 'while' , 'until']
	else
		let g:luoc_keywords		= ['if' , 'else' , 'for' , 'do' , 'while']
	endif
	let g:luoc_keypattern = '\%('.join(g:luoc_keywords , '\|').'\)'
endfunc


func s:withDefault(vname, defaultValue)
	return exists(a:vname) ? eval(a:vname) : a:defaultValue
endfunc

func s:if_expert(expert, stupid)
	return exists('g:luoc_expert') && g:luoc_expert > 0 ? a:expert : a:stupid
endfunc

call luoc#load()

func luoc#CompileRun()
	if g:luoc_keepOriginal <= 0
		let saved_view = winsaveview()
		call luoc#PreProcessor()
		call winrestview(saved_view)
	endif
	update
	let dest = s:withDefault('g:luoc_destination' , '%<_generated_by_luoc.cpp')
	let s:original_tab = tabpagenr()
	if exists('s:generated_tab')
		exe 'tabclose '.s:generated_tab
	endif
	exe 'w! '.dest
	exe 'tab drop '.dest
	let s:generated_tab = tabpagenr()
	sleep 100m
	set modifiable
	if g:luoc_keepOriginal > 0
		call luoc#PreProcessor()
	endif
	call luoc#Processor()
	update
	set nomodifiable
	call luoc#CRcpp()
	exe 'tabnext '.s:original_tab
	if g:luoc_showGenerated <= 0
		exe 'tabclose '.s:generated_tab
	endif
endfunc

func luoc#CRcpp()
	update
	if expand('%:e') == 'cpp' || expand('%:e') == 'lin'
		e %<.cpp | normal ggVG"+y
		let out = '%:p:h\out'
		let run = out.(filereadable(expand('%<').'.lin')? ' < %<.lin' : '')
		execute '!start cmd /c g++ %<.cpp -Wall -o '.out.' & '.run.' & pause'
	endif
endfunc

func luoc#PreProcessor()
	"为 空行 添加缩进(与其后的第一个非空行对齐) 并 保留最多连续3个空行
	%s/^\s*\n\s*\n\s*\n\%(\s*\n\)*\(\s*\)\(\S.*\)/\1\r\1\r\1\r\1\2/e
	%s/^\s*\n\s*\n\(\s*\)\(\S.*\)/\1\r\1\r\1\2/e
	%s/^\s*\n\(\s*\)\(\S.*\)/\1\r\1\2/e
endfunc

func luoc#Processor()
	if g:luoc_blockViaIndent > 0
		"将 以冒号(:)和缩进标记的代码块 替换成 以花括号({})标记的块
		 let each = 1
		 while each <= line('$')
			 let cmd = 'silent %dg/^\s*%s/s/^\(\s*\)\(%s\s.*\):\s*\(\%(\n\1\t.*\)*\)/\1\2{\3\r\1}/'
			 exe printf(cmd, each, g:luoc_keypattern, g:luoc_keypattern)
			 let each += 1
		 endwhile
	endif

	if g:luoc_typeofSupported > 0
		"解析 自动类型推断 通过关键字auto
		%s/\<auto\>\s\+\([_0-9a-zA-Z]\+\)\s*=\s*\([-0-9_a-zA-Z"].*\)\s*\([;,]\)/typeof(\2) \1 = \2 \3/ge
	endif

	if g:luoc_extendKeywords > 0
		"解释 新增的操作关键字
		"%s/\<len \([_0-9a-zA-Z]\+\)\>/int(\1\.size())/ge
		"%s/\<len(\([_0-9a-zA-Z]\+\))/int(\1\.size())/ge
		"%s/\<len\>(\?\<\([_0-9a-zA-Z]\+\)\>)\?/int(\1\.size())/ge
		"解释 新增的循环和条件关键字
		%s/^\(\s*\)\(until\)\s\+\(.*\)\s*{\s*$/\1while (!(\3)) {/e
		%s/^\(\s*\)\(elif\)\s\+\(.*\)\s*{\s*$/\1else if (\3) {/e
		"for i in range(b , e , s) :
		%s/^\(\s*\)\(for\)\s\+\([_0-9a-zA-Z]\+\)\s\+in\s\+range(\s*\([-0-9_a-zA-Z][^,]*\),\s*\([-0-9_a-zA-Z][^,]*\),\s*\([-0-9_a-zA-Z][^,]*\))\s\+{\s*$/\1for (int \3=\4; (\3+(\6)-(\4))*(\3+(\6)-(\5))<=0; \3+=\6) {/e
		"for i in range(b , e) :
		%s/^\(\s*\)\(for\)\s\+\([_0-9a-zA-Z]\+\)\s\+in\s\+range(\s*\([-0-9_a-zA-Z][^,]*\),\s*\([-0-9_a-zA-Z][^,]*\))\s\+{\s*$/\1for (int \3 = \4; \3 < \5; ++\3) {/e
		"for i in range(n) :
		%s/^\(\s*\)\(for\)\s\+\([_0-9a-zA-Z]\+\)\s\+in\s\+range(\s*\([-0-9_a-zA-Z][^,]*\))\s\+{\s*$/\1for (int \3 = 0; \3 < \4; ++\3) {/e
		"for i traverse arr :
		%s/^\(\s*\)\(for\)\s\+\([_0-9a-zA-Z]\+\)\s\+trav\?e\?r\?s\?e\?\s\+\([_a-zA-Z].*\)\s*{\s*$/\1for (int \3 = 0; \3 < int(\4\.size()); ++\3) {/e
		if g:luoc_typeofSupported > 0
			"for it in arr : (ie: foreach)
			%s/^\(\s*\)\(for\)\s\+\([_0-9a-zA-Z]\+\)\s\+in\s\+\([_a-zA-Z].*\)\s*{\s*$/\1\2 (typeof(\4\.begin()) _inner_iter_\3 = \4\.begin(); _inner_iter_\3 != \4\.end(); ++_inner_iter_\3) {\r\1\ttypeof(*\4\.begin()) \&\3 = *_inner_iter_\3;/e
		endif
		"为 没有添加圆括号的循环和条件块的条件 添加一对圆括号
		%s/^\(\s*\)\(if\|else if\|for\|while\)\s\+\([^(].*\)\s*{\s*$/\1\2 (\3) {/e
	endif

	if g:luoc_blockStyle > 0
		"设置 代码块风格
		if g:luoc_blockStyle == 1
			%s/^\(\s*\)\([_a-zA-Z].*\)\n\s*{$/\1\2{/ge
		elseif g:luoc_blockStyle == 2
			%s/^\(\s*\)\([_a-zA-Z].*\){$/\1\2\r\1{/ge
		endif
	endif
endfunc

"au syntax *luoc cal rainbow#load([['(', ')'], ['\[', '\]'], ['if\|else\|for\|while\|until\|elif\|{', '}']])

