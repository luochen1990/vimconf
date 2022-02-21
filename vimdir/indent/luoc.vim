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
"let b:indent_block_start='^\s*\(for\|while\|until\|if\|elif\|else\) \|{$'
if exists("g:luoc_keywords")
	let b:indent_block_start=printf('^\s*%s\s\|{\s*$', '\%('.join(g:luoc_keywords, '\|').'\)')
endif
let b:indent_block_end='^\s*}'

