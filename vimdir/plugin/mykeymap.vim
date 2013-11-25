func mykeymap#load()
	noremap j gj
	noremap k gk
	noremap J <C-d>M
	noremap K <C-u>M
	noremap H 10h
	noremap L 10l
	noremap <A-h> gT
	noremap <A-l> gt

	nnoremap e :e 
	nnoremap w :w<cr>
	nnoremap q :q<cr>
	nnoremap t :tabnew<cr>

	nnoremap U <C-r>
	nnoremap <cr> A
	nnoremap <S-cr> o
	nnoremap <space> i <Esc>l
	nnoremap <backspace> i<backspace><Esc>l
	nnoremap - $l
	vnoremap - $l
	"nnoremap s :%s//g<left><left><left>
	nnoremap f 0f
	nnoremap <C-z> <C-x>
	nnoremap b <C-v>
	vnoremap b <C-v>
	vnoremap <backspace> d
	vnoremap ii v<C-v>I
	vnoremap aa v<C-v>A
	vnoremap v V
	vnoremap V v

	inoremap <C-x> <Esc>"+x
	inoremap <C-c> <Esc>"+y
	inoremap <C-v> <Esc>"+p
	noremap <C-x> "+x
	noremap <C-c> "+y
	noremap <C-v> "+p

	noremap <F4> :browse oldfiles<cr>q
	inoremap <F4> <Esc>:browse oldfiles<cr>q
	noremap <F8> ggVG"+y
"	nnoremap x "+x
"	nnoremap y "+y
"	vnoremap x "+x
"	vnoremap y "+y
"	noremap p "+p
endfunc

