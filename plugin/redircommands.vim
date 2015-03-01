" {{{ commands
if !exists("g:redircommands_newbuffer_command")
    let g:redircommands_newbuffer_command='R'
endif
if !exists("g:redircommands_general_command")
    let g:redircommands_general_command='RR'
endif
execute "command! -nargs=1 " . g:redircommands_general_command   . " call call(function('<sid>Redir'), [<q-args>])"
execute "command! -nargs=1 " . g:redircommands_newbuffer_command . " call call(function('<sid>RedirToNewBuffer'), [<q-args>])"
" }}}
" {{{ Redir()
function! <sid>Redir(args)
    let a:command = substitute(a:args, " \\+[^ ]*$", "", "")
    let a:to      = substitute(a:args, "^.* ", "", "")
    exe 'redir ' . a:to
    silent execute a:command
    redir END
endfunction
" }}}
" {{{ RedirToNewBuffer()
function! <sid>RedirToNewBuffer(command)
    exe 'redir =>a:output'
    silent exe a:command
    redir END
    new
    silent put =a:output
    1d
    1d
    setlocal bufhidden=delete
    setlocal noswapfile
    let fname = "R\\ Output\\ [" . substitute(a:command, '\([ 	]\)', '\\\1', 'g') . "]"
    if bufexists(substitute(fname, '\\', '', 'g'))
        let num = 2
        while bufexists(substitute(fname . ' ' . num, '\\', '', 'g'))
            let num += 1
        endwhile
        silent exe "file " . fname . '\ ' . num
    else
        silent exe "file " . fname
    endif
    set nomodified
endfunction
" }}}

" vim:ft=vim:foldenable:foldmethod=marker:foldmarker={{{,}}}
