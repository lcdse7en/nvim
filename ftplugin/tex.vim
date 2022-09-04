" nnoremap <buffer> <F6> <cmd>vsplit<cr><cmd>terminal xelatex %<cr>A

nnoremap <buffer> <F6> <cmd>ToggleTerm size=10 direction=horizontal<cr><cmd>terminal latexmk -pvc *.tex<cr>A
nnoremap <buffer> <F7> <cmd>ToggleTerm size=10 direction=horizontal<cr><cmd>terminal latexmk -pvc --shell-escape *.tex<cr>A
