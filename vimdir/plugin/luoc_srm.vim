func luoc_srm#load_file()
	let g:luoc_showGenerated = 0
	let g:luoc_destination = 'F:\Desktop\srm.cpp'
	exe '%d'
	exe '0read ' . g:luoc_destination
	update
	exe '!start C:\Users\luochen1990\AppData\Local\Google\Chrome\Application\chrome.exe F:\Desktop\srm.html'
endfunc

au bufNewFile,bufRead *.luoc nnoremap <F7> :call luoc_srm#load_file()<cr><cr>
