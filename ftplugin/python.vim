nnoremap <buffer> <F5> <cmd>vsplit<cr><cmd>terminal python3 %<cr>A

" autocmd BufNewFile *.py exec ":call SetTitle()"
" func SetTitle()
"   if expand("%:e") == "py"
"     call setline(1, "\# -*- coding: utf-8 -*-")
"     normal G
"     normal o
"     normal o
"   endif
" endfunc
