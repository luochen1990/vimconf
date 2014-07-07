"setlocal expandtab smarttab tabstop=4 shiftwidth=4 softtabstop=4
if has('win32')
	let line = getline(1)
	if line[:1] == '#!'
		let python_cmd = line[strridx(line, ' ')+1:]
	else
		let python_cmd = 'python3'
	endif
	"if system('echo %python%') != system('echo %'.python_cmd.'%')
	"	silent! exe '!setx python \%'.python_cmd.'\%'
	"	echo 'Using Python From: '.expand('$'.python_cmd)
	"endif
	"if expand('$python') != expand('$'.python_cmd)
	"	call system('setx python %'.python_cmd.'%'.' && setx path '.expand(expand('$path')))
	"	echo 'Using Python From: '.expand('$'.python_cmd)
	"endif
endif

