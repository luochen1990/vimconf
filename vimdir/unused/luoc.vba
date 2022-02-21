" Vimball Archiver by Charles E. Campbell, Jr., Ph.D.
UseVimball
finish
ftdetect/luoc.vim	[[[1
1
au BufNewFile,BufRead *.luoc setf luoc
ftplugin/luoc.vim	[[[1
109
if !exists('*WithDefault')
	func WithDefault(vname, defaultValue)
		return exists(a:vname) ? eval(a:vname) : a:defaultValue
	endfunc
endif

if !exists('*luoc#CompileRun')
	" Configuration

	nnoremap <buffer> <F9> :call luoc#CompileRun()<cr><cr>
	inoremap <buffer> <F9> <Esc>:call luoc#CompileRun()<cr><cr>
    let s:keywords = ['if' , 'elif' , 'else' , 'for' , 'while' , 'until']
	let s:blockViaIndent   = WithDefault('g:luoc_blockViaIndent'  , 1)
	let s:customIdentifier = WithDefault('g:luoc_customIdentifier', 1)
	let s:typeofSupported  = WithDefault('g:luoc_typeofSupported' , 1)
	let s:extendKeywords   = WithDefault('g:luoc_extendKeywords'  , 1)
	let s:blockStyle       = WithDefault('g:luoc_blockStyle'      , 1)


	" Function

	func luoc#CompileRun()
		call luoc#PreProcessor() | w
		w! %<_generated_by_luoc.cpp
		tabe %<_generated_by_luoc.cpp
		sleep 100m
		set modifiable
		call luoc#Processor() | w
		set nomodifiable
		if exists('*CRcpp')
			call CRcpp()
		else
			call luoc#CRcpp()
		endif
	endfunc
	
	func luoc#CRcpp()
		execute 'update'
		if expand('%:e') == 'cpp' || expand('%:e') == 'in'
			w | e %<.cpp | normal ggVG"+y
			let run = filereadable(expand('%<').'.in')? '%< < %<.in' : '%<'
			execute '!start cmd /c g++ %<.cpp -Wall -o %< & '.run.' & pause'
		endif
	endfunc

	func luoc#PreProcessor()
		"为 空行 添加缩进(与其后的第一个非空行对齐) 并 保留最多连续3个空行
		%s/^\s*\n\s*\n\s*\n\(\s*\n\)*\(\s*\)\(\S.*\)/\2\r\2\r\2\r\2\3/e
		%s/^\s*\n\s*\n\(\s*\)\(\S.*\)/\1\r\1\r\1\2/e
		%s/^\s*\n\(\s*\)\(\S.*\)/\1\r\1\2/e
	endfunc

	func luoc#Processor()
		if s:blockViaIndent > 0
		 	"为 以冒号(:)和缩进标记的代码块 添加反花括号(})
		     let each = 1
		     while each <= line('$')
		         let cmd = 'silent %dg/%s/s/^\(\s*\)\(%s .*:\s*\(\n\1\t.*\)*\)/\1\2\r\1}/'
		         exe printf(cmd, each, join(s:keywords, '\|'), '\('.join(s:keywords, '\|').'\)')
		         let each += 1
		     endwhile
		 	"将行尾的冒号(:)替换成正花括号({)
		 	%s/:\s*$/{/e
		endif

		if s:customIdentifier > 0
		 	"解析 自定义的变量命名方式
		 	%s/\([_0-9a-zA-Z]\)-\([_0-9a-zA-Z]\)/\1_\2/ge
		endif

		if s:typeofSupported > 0
		 	"解析 自动类型推断 通过关键字auto
		 	%s/\<auto\>\s\+\([_0-9a-zA-Z]\+\)\s*=\s*\([-0-9_a-zA-Z"].*\)\s*\([;,]\)/typeof(\2) \1 = \2 \3/ge
		endif

		if s:extendKeywords > 0
		 	"解释 新增的操作关键字
		 	"%s/\<len \([_0-9a-zA-Z]\+\)\>/int(\1\.size())/ge
		 	"%s/\<len(\([_0-9a-zA-Z]\+\))/int(\1\.size())/ge
		 	"%s/\<len\>(\?\<\([_0-9a-zA-Z]\+\)\>)\?/int(\1\.size())/ge
		 	"解释 新增的循环和条件关键字
		 	%s/^\(\s*\)\(until\)\s\(.*\)\s*{\s*$/\1while (!(\3)) {/e
		 	%s/^\(\s*\)\(elif\)\s\(.*\)\s*{\s*$/\1else if (\3) {/e
		 	"for i in range(b , e , s) :
		 	%s/^\(\s*\)\(for\)\s\([_0-9a-zA-Z]\+\)\s\+in\s\+range(\s*\([-0-9_a-zA-Z][^,]*\),\s*\([-0-9_a-zA-Z][^,]*\),\s*\([-0-9_a-zA-Z][^,]*\))\s\+{\s*$/\1\2 (int \3=\4; (\3+(\6)-(\4))*(\3+(\6)-(\5))<=0; \3+=\6) {/e
		 	"for i in range(b , e) :
		 	%s/^\(\s*\)\(for\)\s\([_0-9a-zA-Z]\+\)\s\+in\s\+range(\s*\([-0-9_a-zA-Z][^,]*\),\s*\([-0-9_a-zA-Z][^,]*\))\s\+{\s*$/\1\2 (int \3 = \4; \3 < \5; ++\3) {/e
		 	"for i in range(n) :
		 	%s/^\(\s*\)\(for\)\s\([_0-9a-zA-Z]\+\)\s\+in\s\+range(\s*\([-0-9_a-zA-Z][^,]*\))\s\+{\s*$/\1\2 (int \3 = 0; \3 < \4; ++\3) {/e
			if s:typeofSupported > 0
				"for it in arr : (ie: foreach)
				%s/^\(\s*\)\(for\)\s\([_0-9a-zA-Z]\+\)\s\+in\s\+\([_a-zA-Z].*\)\s*{\s*$/\1\2 (typeof(\4\.begin()) _inner_iter_\3 = \4\.begin(); _inner_iter_\3 != \4\.end(); ++_inner_iter_\3) {\r\1\ttypeof(*\4\.begin()) \&\3 = *_inner_iter_\3;/e
			endif
		 	"为 没有添加圆括号的循环和条件块的条件 添加一对圆括号
		 	%s/^\(\s*\)\(if\|else if\|for\|while\)\s\+\([^(].*\)\s*{\s*$/\1\2 (\3) {/e
		endif

		if s:blockStyle > 0
		 	"设置 代码块风格
			if s:blockStyle == 1
				%s/^\(\s*\)\([_a-zA-Z].*\)\n\s*{$/\1\2{/ge
			elseif s:blockStyle == 2
				%s/^\(\s*\)\([_a-zA-Z].*\){$/\1\2\r\1{/ge
			endif
		endif
	endfunc
endif
"au syntax *luoc cal rainbow#load([['(', ')'], ['\[', '\]'], ['if\|else\|for\|while\|until\|elif\|{', '}']])

syntax/luoc.vim	[[[1
81
" Vim syntax file
" Language:	C++
" Maintainer:	Ken Shan <ccshan@post.harvard.edu>
" Last Change:	2002 Jul 15

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" Read the C syntax to start with
if version < 600
  so <sfile>:p:h/c.vim
else
  runtime! syntax/c.vim
  unlet b:current_syntax
endif

" C++ extentions
syn keyword cppStatement	new delete this friend using
syn keyword cppAccess		public protected private
syn keyword cppType		inline virtual explicit export bool wchar_t
syn keyword cppExceptions	throw try catch
syn keyword cppOperator		operator typeid
syn keyword cppOperator		and bitor or xor compl bitand and_eq or_eq xor_eq not not_eq
syn match cppCast		"\<\(const\|static\|dynamic\|reinterpret\)_cast\s*<"me=e-1
syn match cppCast		"\<\(const\|static\|dynamic\|reinterpret\)_cast\s*$"
syn keyword cppStorageClass	mutable
syn keyword cppStructure	class typename template namespace
syn keyword cppNumber		NPOS
syn keyword cppBoolean		true false


" luoc extentions
syn keyword luocStatement	goto break return continue asm
syn keyword luocLabel		case default
syn keyword luocConditional	if else elif
syn keyword luocRepeat		while for do until
syn keyword luocOperator	sizeof len in

" The minimum and maximum operators in GNU C++
syn match cppMinMax "[<>]?"

" Default highlighting
if version >= 508 || !exists("did_cpp_syntax_inits")
  if version < 508
    let did_cpp_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif
  HiLink cppAccess		cppStatement
  HiLink cppCast		cppStatement
  HiLink cppExceptions		Exception
  HiLink cppOperator		Operator
  HiLink cppStatement		Statement
  HiLink cppType		Type
  HiLink cppStorageClass	StorageClass
  HiLink cppStructure		Structure
  HiLink cppNumber		Number
  HiLink cppBoolean		Boolean

  HiLink luocStatement  	cStatement  
  HiLink luocLabel             	cLabel      
  HiLink luocConditional       	cConditional
  HiLink luocRepeat            	cRepeat     
  HiLink luocOperator          	cOperator   

  delcommand HiLink
endif

"syn clear Conditional cConditional luocConditional
"syn clear Repeat cRepeat luocRepeat
"syn clear cUserCont

let b:current_syntax = "cpp"

" vim: ts=8
indent/luoc.vim	[[[1
38
" Only load this indent file when no other was loaded.
if exists("b:did_indent")
	finish
endif
let b:did_indent = 1
let b:undo_indent = "setl cin<"

if !exists("*GenericIndent")
	function GenericIndent(lnum)
		if !exists('b:indent_ignore')
			" this is safe, since we skip blank lines anyway
			let b:indent_ignore='^$'
		endif
		" Find a non-blank line above the current line.
		let lnum = prevnonblank(a:lnum - 1)
		while lnum > 0 && getline(lnum) =~ b:indent_ignore
			let lnum = prevnonblank(lnum - 1)
		endwhile
		if lnum == 0
			return 0
		endif
		let curline = getline(a:lnum)
		let prevline = getline(lnum)
		let indent = indent(lnum)
		if ( prevline =~ b:indent_block_start )
			let indent = indent + &sw
		endif
		if ( curline =~ b:indent_block_end )
			let indent = indent - &sw
		endif
		return indent
	endfunction
endif

set indentexpr=GenericIndent(v:lnum)
let b:indent_block_start='^\s*\(for\|while\|until\|if\|elif\|else\) \|{$'
let b:indent_block_end='^\s*}'

