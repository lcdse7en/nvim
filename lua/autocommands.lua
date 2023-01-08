vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "markdown" },
  callback = function()
    vim.cmd [[
    inoremap <buffer> ,f <Esc>/<++><CR>:nohlsearch<CR>"_c4l
    inoremap <buffer> <c-e> <Esc>/<++><CR>:nohlsearch<CR>"_c4l
    inoremap <buffer> ,w <Esc>/ <++><CR>:nohlsearch<CR>"_c5l<CR>
    inoremap <buffer> ,n ---<Enter><Enter>
    inoremap <buffer> ,b **** <++><Esc>F*hi
    inoremap <buffer> ,s ~~~~ <++><Esc>F~hi
    inoremap <buffer> ,i ** <++><Esc>F*i
    inoremap <buffer> ,d `` <++><Esc>F`i
    inoremap <buffer> ,c ```<Enter><++><Enter>```<Enter><Enter><++><Esc>4kA
    inoremap <buffer> ,m - [ ]
    inoremap <buffer> ,p ![](<++>)<++><Esc>F[a
    inoremap <buffer> ,a [](<++>)<++><Esc>F[a
    inoremap <buffer> ,1 #<Space><Enter><++><Esc>kA
    inoremap <buffer> ,2 ##<Space><Enter><++><Esc>kA
    inoremap <buffer> ,3 ###<Space><Enter><++><Esc>kA
    inoremap <buffer> ,4 ####<Space><Enter><++><Esc>kA
    inoremap <buffer> ,5 #####<Space><Enter><++><Esc>kA
    inoremap <buffer> ,l --------<Enter>
     ]]
  end,
})

vim.cmd "autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif"

vim.cmd "autocmd BufWritePost * :%s/s+$//e"

vim.cmd [[
autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif
]]

vim.cmd [[
    let fcitx5state=system("fcitx5-remote")
    autocmd InsertLeave * :silent let fcitx5state=system("fcitx5-remote")[0] | silent !fcitx5-remote -c
    autocmd InsertEnter * :silent if fcitx5state == 2 | call system("fcitx5-remote -o") | endif
    autocmd VimLeave *.tex !texclear %
]]

vim.cmd [[
autocmd ColorScheme * lua require('leap').init_highlight(true)
]]

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    vim.api.nvim_set_hl(0, "LeapMatch", { ctermfg = "#99ddff" })
    vim.api.nvim_set_hl(0, "LeapLabelPrimary", { ctermfg = "#99ddff" })
    vim.api.nvim_set_hl(0, "LeapLabelSecondary", { ctermfg = "#99ddff" })
  end,
})

vim.cmd [[
    augroup _auto_format
      autocmd!
      autocmd BufWritePre * FormatWrite
    augroup end

]]

vim.cmd [[
    augroup title_py
        autocmd!
        autocmd BufNewFile *.py exec":call SetTitle_py()"
          func SetTitle_py()
            if expand("%:e") == "py"
              call setline(1, "\# -*- coding: utf-8 -*-")
              normal G
              normal o
              normal o
            endif
          endfunc
        autocmd BufNewFile * normal G
    augroup end
]]

vim.cmd [[
    augroup title_sh
        autocmd!
        autocmd BufNewFile *.sh exec":call SetTitle_sh()"
          func SetTitle_sh()
            if expand("%:e") == "sh"
              call setline(1, "#!/usr/bin/sh")
              call setline(2, "#")
              call setline(3, "#*******************************************")
              call setline(4, "# Author:      lcdse7en                    *")
              call setline(5, "# E-mail:      2353442022@qq.com           *")
              call setline(6, "# Date:        ".strftime("%Y-%m-%d")."                  *")
              call setline(7, "# Description:                             *")
              call setline(8, "#*******************************************")
              call setline(9, "")
              call setline(10, "")
            endif
          endfunc
        autocmd BufNewFile * normal G
    augroup end
]]
