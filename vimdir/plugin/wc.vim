" Vim plugin for counting words, Strunk & White style
" Maintainer: jcline <jcline@ieee.org>
" Last Change: 2004 Jan 28

" Don't do this when:
" - when 'compatible' is set
" - this plugin was already loaded
" - user commands are not available.
if !&cp && !exists(":WC") && has("user_commands")
  command -range=% WC :call JCWC(<line1>, <line2>)


  func JCWC_line(line)
      let line = a:line
      let line = substitute(line, "--", " ", "g")
      let line = substitute(line, "\*", " ", "g")
      let line = substitute(line, "\[ \t\n\]\[ \t\n\]\*", " ", "g")
      let line = substitute(line, "^", " ", "")
      let line = substitute(line, " [^ ][^ ]*", "a", "g")
      let line = substitute(line, "\[ \n\]", "", "g")
      let n = strlen(line)
"      echo n . "; " . a:line       " for debug
      return n
  endfunc

  func JCWC(line1, line2)
    let wc_start_line = 1
    let wc_end_line = 1
    if a:line2 >= a:line1
      let wc_start_line = a:line1
      let wc_end_line = a:line2
    else
      let wc_start_line = a:line2
      let wc_end_line = a:line1
    endif

    let wc_count = 0

    let stop = ""
    let n = wc_start_line
    while n <= wc_end_line
        let line = getline(n)
        "if match(line, "^--------") >= 0
        "    let stop = " until '^--------'"
        "    break
        "endif
        let c = JCWC_line(line)
        let wc_count = wc_count + c
        let n = n + 1
    endwhile

    echo "counted " . wc_count . " words" . stop

  endfunc

endif
