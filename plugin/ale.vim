" 更改 ale 的警告符号
" let g:ale_sign_error = ''
" let g:ale_sign_warning = ''
"let g:ale_sign_error = ''
let g:ale_sign_error = '>>'
let g:ale_sign_warning = '--'

" Set this. Airline will handle the rest.
let g:airline#extensions#ale#enabled = 1
" 警告保持打开
let g:ale_sign_column_always = 1

" Check Python files with flake8 and pylint.
let b:ale_linters = ['flake8', 'pylint']
" Fix Python files with autopep8 and yapf.
let b:ale_fixers = ['autopep8', 'yapf']
" Disable warnings about trailing whitespace for Python files.
let b:ale_warn_about_trailing_whitespace = 0

"function! LinterStatus() abort
"    let l:counts = ale#statusline#Count(bufnr(''))
"
"    let l:all_errors = l:counts.error + l:counts.style_error
"    let l:all_non_errors = l:counts.total - l:all_errors
"
"    return l:counts.total == 0 ? 'OK' : printf(
"    \   '%dW %dE',
"    \   all_non_errors,
"    \   all_errors
"    \)
"endfunction
"
"set statusline=%{LinterStatus()}
"
"let g:ale_echo_msg_error_str = 'E'
"let g:ale_echo_msg_warning_str = 'W'
"let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
