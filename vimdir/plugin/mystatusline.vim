"==============================================================================
"Script Title: mystatusline
"Script Version: 1.0
"Author: luochen1990
"Last Edited: 2013/8/1
"Configuration:
"	first, put "mystatusline.vim"(this file) to dir vim73/plugin or vimfiles/plugin
"	second, add the follow sentences to your .vimrc or _vimrc :
"
"			set laststatus=2
"	 		let g:mystatusline_activated = 1
"
"	third, restart your vim and enjoy coding.

if exists('g:mystatusline_activated') && g:mystatusline_activated
	let statusline_parts = [
				\"%1* %{&ff} %{&ff=='unix'?'\\n':(&ff=='mac'?'\\r':'\\r\\n')}",
				\"%2* %{&fenc!=''?&fenc:&enc}%{&bomb?'(bom)':''}",
				\"%3* %{&ft}%m",
				\"%4* %<%50(%)%50(%)%50(%)%{expand('%:p')}",
				\"%5* %3(%{line('.')==line('$')?'end':(line('.')*100/line('$')).'%'}%)",
				\"%5* %3{line('.')}/%{line('$')}",
				\"%6* %-3(%2{col('.')-1}%) 0x%02B",
				\]

	let statusline_str = join(statusline_parts , ' ')
	"setlocal statusline=%!statusline_str
	set statusline=%!statusline_str
	
	if exists('g:mystatusline_colorschema') && g:mystatusline_colorschema == 1
		hi user1 guifg=#391100  guibg=#d3905c
		hi user2 guifg=#112605  guibg=#aefe7b
		hi user3 guifg=#292b00  guibg=#f4f597
		hi user4 guifg=#002600  guibg=#67ab6e
		hi user5 guifg=#112605  guibg=#aefe7b
		hi user6 guifg=#051d00  guibg=#7dcc7d
	else
		"hi user1 guifg=#ffffff  guibg=#116699
		auto bufenter * if &ff == 'dos' | hi user1 guifg=#ffffff  guibg=#993333 | endif
		auto bufenter * if &ff == 'mac' | hi user1 guifg=#ffffff  guibg=#993333 | endif
		auto bufenter * if &ff == 'unix' | hi user1 guifg=#ffffff  guibg=#116699 | endif
		hi user2 guifg=#ffffff  guibg=#2277aa
		hi user3 guifg=#ffffff  guibg=#3388bb
		hi user4 guifg=#ffffff  guibg=#4499cc
		hi user5 guifg=#ffffff  guibg=#2277aa
		hi user6 guifg=#ffffff  guibg=#005588
	endif
endif

