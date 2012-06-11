" Return the number of occurances of "needle" in "haystack"
function! s:CountSubstring(haystack, needle)
  let s = a:haystack
  let n = 0
  let pos = stridx(s, a:needle)
  while pos >= 0
    let s = strpart(s, pos+1)
    let n = n+1
    let pos = stridx(s, a:needle)
  endwhile
  return n
endfunction

" If previous line ends with "(" then indent under previous line + 2
" shiftwidths.
"
" If previous line contains "<<" at a paren-level of 0, ident the current line
" to that position (cout << foo\n<< bar)
"
" Otherwise, use built-in cindent rules.
function! s:GoogleCIndent()

  " No indent after namespace {
  let prevnonblankline = prevnonblank(v:lnum - 1)
  if prevnonblankline > 0
    if getline(prevnonblankline) =~ '^\s*namespace\>.*{\s*$'
      return indent(prevnonblankline)
    endif
  endif

  let default_indent = cindent(v:lnum)
  if (v:lnum > 1)
    " Do nothing on complete statements
    if default_indent <= indent(v:lnum - 1)
      return default_indent
    endif

    let prevline = getline(v:lnum - 1)

    if prevline =~ '(\s*$'
      return indent(v:lnum - 1) + (2 * &sw)
    endif

    let left_shift_pos = stridx(prevline, "<<")
    if left_shift_pos >= 0
      " check if the paren level is 0 at the <<, as a heuristic that we're
      " writing to a stream and not doing a left-shift
      let prefix = strpart(prevline, 0, left_shift_pos)
      if s:CountSubstring(prefix, "(") == s:CountSubstring(prefix, ")")
        return left_shift_pos
      endif
    endif
  endif
  return default_indent
endfunction

" set s:func to contain the global name of s:GoogleCIndent
" TODO(laurence): figure out if there's a less ugly way to do this
map <SID>GoogleCIndent <SID>GoogleCIndent
let s:func = maparg("<SID>GoogleCIndent")
unmap <SID>GoogleCIndent

let &l:indentexpr=s:func . '()'

" TODO: some things coding-style.el does which I can't decipher:
"  - c-lineup-math?
"  - (statement-case-open . +) ; case w/ {

setlocal cindent
setlocal cinoptions+=j1
setlocal cinoptions+=+2s
setlocal cinoptions+=(0
setlocal cinoptions+=g1
setlocal cinoptions+=h1
