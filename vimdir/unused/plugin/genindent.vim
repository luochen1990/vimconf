" File Name: genindent.vim
" Maintainer: Moshe Kamensky
" Original Date: June 15, 2003
" Last Update: Tue 30 Jun 2009 09:49:39 PM EDT
" Description: provides a function GenericIndent, that returns the indent in 
" the following simple situation:
" We have blocks, the start of each block is a string that matches a certain 
" pattern, and the end of each block matches another pattern. We would like to 
" add one indent to all the lines within such a block. In addition, a pattern 
" can be given of lines to ignore when calculating the indent (such as 
" comments). These lines themselves are, on the other hand, indented normally.
" The usage is as follows: first, set the variables 'b:indent_block_start' and 
" 'b:indent_block_end' to the patterns of beginning and ending of blocks, 
" respectively. For example, for vim this is (copying from the vim.vim indent 
" file):
" 
" let b:indent_block_start='\(^\||\)\s*\(if\|wh\%[ile]\|try\|cat\%[ch]\|fina\%[lly]\|fu\%[nction]\|el\%[seif]\)\>'
" let b:indent_block_end='^\s*\(ene\@!\|cat\|fina\|el\|aug\%[roup]\s*!\=\s\+END\)'
"
" Also set 'b:indent_ignore' to the pattern of lines to ignore (if you wish). 
" All this should probably be done in the indent file. Then calling 
" GenericIndent(<lnum>) will return the indent for line <lnum>, so in the 
" simplest cases setting 'indentexpr=GenericIndent(v:lnum)' should give the 
" correct indentation.

" Only define the function once.
if exists("*GenericIndent")
  finish
endif

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

