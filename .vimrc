" Enable modern vim features.
set nocompatible

" use the 'google' package by default (see http://go/vim/packages).
source /usr/share/vim/google/google.vim

" Turn on line number display.
set number

" Highlight search results.
set hls

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

" Don't put two spaces after a full stop.
set nojoinspaces

" Make the history longer than the default of 50.
set history=1000

" Use the IR_Black theme, downloaded from here:
"
"     http://blog.toddwerth.com/entry_files/8/ir_black.vim
"
colorscheme ir_black

""""""""""""""""""""""""""""""
" selecta
""""""""""""""""""""""""""""""

" The stuff below is based on
" https://github.com/garybernhardt/selecta/blob/8b975771/README.md

" Run a given vim command on the results of fuzzy selecting from a given shell
" command. See usage below.
function! SelectaCommand(choice_command, selecta_args, vim_command)
  try
    let selection = system(a:choice_command . " | selecta " . a:selecta_args)
  catch /Vim:Interrupt/
    " Swallow the ^C so that the redraw below happens; otherwise there will be
    " leftovers from selecta on the screen
    redraw!
    return
  endtry
  redraw!
  exec a:vim_command . " " . selection
endfunction

" Find all files in all non-dot directories starting in the working directory.
" Fuzzy select one of those. Open the selected file with :e.
nnoremap <leader>e :call SelectaCommand("find * -type f", "", ":e")<cr>

""""""""""""""""""""""""""""""
" Google
""""""""""""""""""""""""""""""

" Pull in Google-specific plugins and aliases.
source /usr/local/google/home/jacobsa/.google-dotfiles/google-specific.vim


""""""""""""""""""""""""""""""
" Final
""""""""""""""""""""""""""""""

" Turn on file type-based indentation and syntax highligting.
"
" All plugins must be added before this line (http://shortn/_yZuB1FmVhB)
filetype plugin indent on
syntax on
