nnoremap <buffer> <F9> :call cpp#CRcpp()<cr><cr>
inoremap <buffer> <F9> <Esc>:call cpp#CRcpp()<cr><cr>

inoremap <buffer> `pii pair <int , int>
inoremap <buffer> `psi pair <string , int>
inoremap <buffer> `vi vector <int>
inoremap <buffer> `vii vector < pair <int , int> >
inoremap <buffer> `mii map <int , int>
inoremap <buffer> `msi map <string , int>
inoremap <buffer> `pb push_back
inoremap <buffer> `pf push_front
inoremap <buffer> `i insert
inoremap <buffer> `f first
inoremap <buffer> `s second
inoremap <buffer> `b begin
inoremap <buffer> `e end
inoremap <buffer> `std using namespace std ;
inoremap <buffer> `# #include

if exists('*cpp#CRcpp')
	finish
endif

func cpp#CRcpp()
	update
	if expand('%:e') == 'cpp' || expand('%:e') == 'cin'
		e %<.cpp | normal ggVG"+y
		let out = '%:p:h\out'
		let run = out.(filereadable(expand('%<').'.cin')? ' < %<.cin' : '')
		execute '!start cmd /c g++ %<.cpp -Wall -o '.out.' & '.run.' & pause'
	endif
endfunc
