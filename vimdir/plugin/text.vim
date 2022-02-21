"pos		[lnum, cnum]
"region		[start_pos, end_pos]

"get		region -> str
"replace	region, str => text
"itersearch	region, pat -> iter (while iter = () -> region|null, iter)
"search		region, pat -> [region ...]

"""""""""""""""""""""""""""""""

func! text#repr(str)
	return '"'.escape(str , '"\').'"'
endfunc

"""""""""""""""""""""""""""""""

func! text#poscmp(pa, pb)
	if a:pa[0] != a:pb[0]
		return (a:pa[0] > a:pb[0]) - (a:pa[0] < a:pb[0])
	else
		return (a:pa[1] > a:pb[1]) - (a:pa[1] < a:pb[1])
	endif
endfunc

"""""""""""""""""""""""""""""""

func! text#cursorpos()
	return getpos('.')[1:2]
endfunc

func! text#cursorset(pos)
	return cursor(a:pos[0], a:pos[1])
endfunc

"""""""""""""""""""""""""""""""

func! text#get(region)
	let [sr, sc, er, ec] = [a:region[0][0], a:region[0][1], a:region[1][0], a:region[1][1]]
	if sr == er
		return getline(sr)[sc-1 : ec-1]
	elseif sr < er
		return join(getline(sr , er-1), "\n")[sc-1 :]."\n".getline(er)[: ec-1]
	else
		return ''
	endif
endfunc

func! text#replace(region, str)
	let [cursorpos, clipboard] = [text#cursorpos(), @"]
	let [s, e] = [a:region[0], a:region[1]]
	let @" = a:str
	call text#cursorset(s) |normal! v
	call text#cursorset(e) |normal! p
	let @" = clipboard |call text#cursorset(cursorpos)
endfunc

"""""""""""""""""""""""""""""""

func! text#selected()
	let cursorpos = text#cursorpos()
	exec "normal! gv" |let s = text#cursorpos()
	exec "normal! gvo\<esc>" |let e = text#cursorpos()
	call text#cursorset(cursorpos)
	return text#poscmp(s, e) <= 0? [s, e] : [e, s]
endfunc

func! text#itersearch(region, pat)
	let cursorpos = text#cursorpos()
	let [s, e] = [a:region[0], a:region[1]]
	call text#cursorset(s)
	call search(a:pat, 'cW' , e[0]) |let ms = text#cursorpos()
	call search(a:pat, 'We' , e[0]) |let me = text#cursorpos()
	let next_region = text#poscmp(me, e) <= 0 ? [me, e] : a:region
	call text#cursorset(cursorpos)
	return [[ms, me] , next_region]
endfunc

func! text#search(region, pat)
	let result_regions = []
	let now = a:region
	while 1
		let [r, next] = text#itersearch(now, a:pat)
		if next == now |break |endif
		call add(result_regions, r)
		let now = next
	endwhile
	return result_regions
endfunc

"%s/([+-*/])/\=blabla/g

"poor language
"let a = symbol()
"define a

