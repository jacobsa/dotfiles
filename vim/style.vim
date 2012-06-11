" Add <mydir>/runtime and <mydir>/runtime/after to appropiate places in Vim's
" runtimepath. The former is made the second element, while the latter is made
" the second to last element. This should put our paths between the user's
" personal settings and Vim's factory settings on both the "normal" part of
" the path and the "after" part of the path.
let s:rt_before = expand('<sfile>:p:h') . '/runtime'
if has('win32') || has('win64')
  let s:rt_before = substitute(s:rt_before, '\\', '/', 'g')
endif
let s:rt_after = s:rt_before . '/after'
let &runtimepath = substitute(&runtimepath, '^\([^,]*\),\(.*\),\([^,]*\)$', '\1,' . s:rt_before . ',\2,' . s:rt_after . ',\3', '')

" Used by functions below.
let s:marked_line_on_screen = 0

" Sets default Google coding style options. expand_tabs indicates whether
" 'expandtab' should be set.
function! GoogleCodingStyle(expand_tabs)
  setlocal tabstop=8
  setlocal shiftwidth=2
  if a:expand_tabs
    setlocal expandtab
  endif
  setlocal textwidth=80
endfunction

" Filetype-specific options are defined in ftplugins.
filetype plugin indent on

" Show trailing spaces in yellow (or red, for users with dark backgrounds).
" "set nolist" to disable this.
" this only works if syntax highlighting is enabled.
set list
set listchars=tab:\ \ ,trail:\ ,extends:»,precedes:«
if &background == "dark"
  highlight SpecialKey ctermbg=Red guibg=Red
else
  highlight SpecialKey ctermbg=Yellow guibg=Yellow
end

" Reasonable defaults for indentation.
set autoindent nocindent nosmartindent

" Tell sh syntax highlighting that /bin/sh is actually bash.
let is_bash=1

" Trims excess newlines from the end of the buffer.  Also adds a newline if the
" last line doesn't have one.
function! GoogleTrimNewlines ()
  let lines = line('$')
  let done = 0
  " loop so that we can also delete trailing lines consisting of only whitespace
  while !done
    " erase last line if it's only whitespace
    %s/^\s*\%$//e

    " erase trailing blank lines
    %s/\n*\%$/\r/e
    %s/\n*\%$//e

    " if we actually did anything, assume that we have more to do
    let done = lines == line('$')
    let lines = line('$')
  endwhile
endfunction

function! GoogleMarkCurrPos ()
  " mark the curr position, as well as the first visible character on that
  " line. We need the latter because certain sorts of window decorations (eg:
  " 'number') can cause the first position to be non-zero.
  normal! mzg0my

  " remember the marked position wrt the screen
  let s:marked_col_on_screen = wincol()
  let s:marked_line_on_screen = winline()
endfunction

function! GoogleRestorePos ()
  " jump back to the old "first character on the line", and remember offsets
  silent! normal! `y
  let col_offset = wincol() - s:marked_col_on_screen
  let line_offset = winline() - s:marked_line_on_screen

  " jump to actual marked position
  silent! normal! `z

  " scroll window to correct for offsets
  if col_offset < 0
    exe "normal! " . -col_offset . "zh"
  elseif col_offset > 0
    exe "normal! " . col_offset . "zl"
  endif
  if line_offset < 0
    exe "normal! " . -line_offset . "\<C-Y>"
  elseif line_offset > 0
    exe "normal! " . line_offset . "\<C-E>"
  endif
endfunction

" Trims newlines and at the end of the file if this is a file of an appropriate
" type.
function! GoogleConditionallyTrimNewlines ()
  if &ft == 'cpp' || &ft == 'c' || &ft == 'java' || &ft == 'python' || &ft == 'make' || &ft == 'javascript'
    if match(getline('$'), '^\s*$') >= 0
      call GoogleMarkCurrPos()
      call GoogleTrimNewlines()
      call GoogleRestorePos()
    endif
  endif
endfunction

" Trim newlines at the end of certain files before saving
au BufWritePre * call GoogleConditionallyTrimNewlines()
