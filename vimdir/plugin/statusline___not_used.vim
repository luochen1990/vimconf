" Summary:     Beautify statusline
" Description:
"         This script is based on the light2011 colorscheme. Thanks for xiaohuyee <xiaohuyee@gmail.com>
"         to give us such a pretty gift. He did most of the work. I just
"         stood on his shoulders.
"         I am looking for a beautiful vim statusline for a long time but found nothing
"         until I met the light2011.
"         Last night I spent several hours to beautify my statusline, it looks good.
"         And now I give it to you.
" Screenshot: 
"         http://vimer.1063083.n5.nabble.com/beautiful-vim-statusline-td4777850.html
"         
" Maintainer: Tian Huixiong: <nedzqbear@gmail.com>
"             I'm very glad to receive your feedback. 
" Licence:    This script is released under the Vim License.
" Version:    1.0
" Update:     2011-09-07 
" Install:     
"         Put this file in ~/.vim/plugin on *nix.
"         Or put it in $vim/vimfiles/plugin on Windows.
" Tutorial:
"         Just use it, and change it.
"         When you edit it, do not erase trailing-blanks.

if ! (exists('g:statusline_active') && g:statusline_active)
	finish
endif

let g:statusline_parts = [
			\"%2* %{&ff} %{&ff=='unix'?'\\n':(&ff=='mac'?'\\r':'\\r\\n')}",
            \"%1* %{&fenc!=''?&fenc:&enc}%{&bomb?'(bom)':''}",
			\"%3* %{&ft}%m",
			\"%5* %<%50(%)%50(%)%50(%)%{expand('%:p')}",
			\"%1* %3(%{line('.')==line('$')?'End':(line('.')*100/line('$')).'%'}%)",
			\"%1* %3{line('.')}/%{line('$')}",
			\"%4* %-3(%2{col('.')-1}%) 0x%04B",
			\]

let &statusline=join(g:statusline_parts , ' ')

"set statusline=
"set statusline+=%2*\ %{&ff}\ %{&ff=='unix'?'\\n':(&ff=='mac'?'\\r':'\\r\\n')}\ 
"set statusline+=%1*\ %{&fenc!=''?&fenc:&enc}\ 
"set statusline+=%3*\ %Y%m\ 
"set statusline+=%5*\ %<%50(%)\ 
"set statusline+=%5*\ %<%50(%)\ 
"set statusline+=%5*\ %<%50{expand('%:p')}\ 
"set statusline+=%1*\ %3{line('.')}/%{line('$')}\ %5([%{line('.')==line('$')?'End':(line('.')*100/line('$')).'%'}]%)\ "[%p%%]\ 
"set statusline+=%4*\ %3{col('.')-1}\ [0x%04B]\ 


func s:color1 ()
	hi User1 guifg=#112605  guibg=#aefe7B gui=none
	hi User2 guifg=#391100  guibg=#d3905c gui=none
	hi User3 guifg=#292b00  guibg=#f4f597 gui=none
	hi User4 guifg=#051d00  guibg=#7dcc7d gui=none
	hi User5 guifg=#002600  guibg=#67ab6e gui=none
endfunc

func s:color2 ()
	hi User1 guibg=black  guifg=#aefe7B gui=none
	hi User2 guibg=black  guifg=#d3905c gui=none
	hi User3 guibg=black  guifg=#f4f597 gui=none
	hi User4 guibg=black  guifg=#7dcc7d gui=none
	hi User5 guibg=black  guifg=#67ab6e gui=none
endfunc

if g:statusline_active == 2
	au insertenter * set laststatus=0
	au insertleave * set laststatus=2
elseif g:statusline_active == 3
	au insertleave * call s:color1()
	au insertenter * call s:color2()
elseif g:statusline_active == 4
endif

if exists('g:statusline_color')
	if g:statusline_color == 1
		call s:color1()
	elseif g:statusline_color == 2
		call s:color2()
	endif
else
	call s:color1()
endif

fu! FileTime()
	let ext=tolower(expand("%:e"))
	let fname=tolower(expand('%<'))
	let filename=fname . '.' . ext
	let msg=""
	"let msg=msg." ".strftime("(Modified %y/%b/%d  %H:%M:%S)",getftime(filename))
	let msg=msg." ".strftime("(Modified %c)",getftime(filename))
	return msg
endf
 
fu! CurTime()
	let ftime=""
	let ftime=ftime." ".strftime("%b,%d %y %H:%M:%S")
	return ftime
endf

