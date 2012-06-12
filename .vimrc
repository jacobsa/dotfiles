" Add support for Go.
set rtp+=$GOROOT/misc/vim

" Turn on syntax highlighting.
syntax on

" Include coding style options.
if filereadable("/usr/share/vim/google/google.vim")
  source /usr/share/vim/google/google.vim
else
  source ~jacobsa/.vim/style.vim
endif

" enables extra vim features (which break strict compatibility with vi)
" only set if unset, since it has side effects (resetting a bunch of options)
if &compatible
  set nocompatible
endif

" allows files to be open in invisible buffers
set hidden

" Turn on line number display.
set number

" Highlight search results.
set hls

" Switch between header files, implementation files, tests, and so on by
" pressing comma and then a letter.
let pattern = '\(\(_\(unit\)\?test\)\?\.\(cc\|js\|py\|m\|mm\|go\)\|\(-inl\)\?\.h\)$'
nmap ,c :e <C-R>=substitute(expand("%"), pattern, ".cc", "")<CR><CR>
nmap ,g :e <C-R>=substitute(expand("%"), pattern, ".go", "")<CR><CR>
nmap ,h :e <C-R>=substitute(expand("%"), pattern, ".h", "")<CR><CR>
nmap ,j :e <C-R>=substitute(expand("%"), pattern, ".js", "")<CR><CR>
nmap ,t :e <C-R>=substitute(expand("%"), pattern, "_test.", "") . substitute(expand("%:e"), "h", "cc", "")<CR><CR>

" Toggle paste mode on and off with comma p.
map ,p :se invpaste paste?<return>

" Highlight columns 81 and 82 with red on white.
function! HighlightTooLongLines()
  highlight def link RightMargin Error
  if &textwidth != 0
    exec 'match RightMargin /\%<' . (&textwidth + 3) . 'v.\%>' . (&textwidth + 1) . 'v/'
  endif
endfunction

augroup filetypedetect
au BufNewFile,BufRead * call HighlightTooLongLines()
augroup END

" Turn off tab highlighting for makefiles and Go.
autocmd BufNewFile,BufRead Makefile set nolist
autocmd BufNewFile,BufRead *.go set nolist

" Make tabs two spaces for Go. Don't mess up the use of tabs for indentation.
autocmd BufNewFile,BufRead *.go set tabstop=2 shiftwidth=2 noexpandtab

" Treat FLAME files as JS.
autocmd BufNewFile,BufRead FLAME set filetype=javascript

" Turn on bash-like filename completion.
set wildmode=longest:list

" Make the history longer.
set history=1000

" Use the IR_Black theme, downloaded from here:
"
"     http://blog.toddwerth.com/entry_files/8/ir_black.vim
"
colorscheme ir_black

" Pull in Google-specific rules, if present.
if filereadable($HOME . "/.google-dotfiles/google-specific.vim")
  source /usr/local/google/home/jacobsa/.google-dotfiles/google-specific.vim
endif
