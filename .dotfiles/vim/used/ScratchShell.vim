
"Source: http://vim.wikia.com/wiki/Display_output_of_shell_commands_in_new_window

"Enables the command :Shell to open up a scratch buffer with the output of any
"given shell command, also saves the currently open files.
command! -complete=shellcmd -nargs=+ Shell call s:RunShellCommand(<q-args>)

"Quick abbreviations for the Shell command
cabbrev shell Shell
cabbrev Sh Shell
cabbrev sh Shell

"Runs the given shell command and prints the output in a temporary scratch buffer
function! s:RunShellCommand(cmdline)
   
   "Just echo the command back
   echo a:cmdline
   
   "Expand the command 
   let expanded_cmdline = a:cmdline
   for part in split(a:cmdline, ' ')
      if part[0] =~ '\v[%#<]'
         let expanded_part = fnameescape(expand(part))
         let expanded_cmdline = substitute(expanded_cmdline, part, expanded_part, ')
      endif
   endfor

   "Create new buffer in bottom right
   botright new
   "New buffer is just a scratch buffer, it's not a real file, will be wiped
   "on close, will not be listed, and does not make a swap file
   setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile

   "Dump info into scratch buffer about the command that was entered
   "Specifically will print the exact command entered as well as how any
   "possible variables ended up getting expanded.
   call setline(1, 'You entered:    ' . a:cmdline)
   call setline(2, 'Expanded Form:  ' .expanded_cmdline)
   call setline(3,substitute(getline(2),'.','=','g'))

   "The vim command ':read !<command>' will insert the output of a command to
   "the current window, so in our case '$read !<command>' will insert the
   "output into our scratch buffer
   execute '$read !'. expanded_cmdline
   setlocal nomodifiable
   1
endfunction


"An 'enhanced' script from the same source, posted as one of the comments.
"function! s:RunShellCommand(command)
"   let command = join(map(split(a:command), 'expand(v:val)'))
"   let winnr = bufwinnr('^' . command . '$')
"   silent! execute  winnr < 0 ? 'botright new ' . fnameescape(command) : winnr . 'wincmd w'
"   setlocal buftype=nowrite bufhidden=wipe nobuflisted noswapfile nowrap number
"   echo 'Execute ' . command . '...'
"   silent! execute 'silent %!'. command
"   silent! execute 'resize ' . line('$')
"   silent! redraw
"   silent! execute 'au BufUnload <buffer> execute bufwinnr(' . bufnr('#') . ') . ''wincmd w'''
"   silent! execute 'nnoremap <silent> <buffer> <LocalLeader>r :call <SID>ExecuteInShell(''' . command . ''')<CR>'
"   echo 'Shell command ' . command . ' executed.'
"endfunction


"Original command for reference
"function! s:RunShellCommand(cmdline)
"   echo a:cmdline
"   let expanded_cmdline = a:cmdline
"   for part in split(a:cmdline, ' ')
"      if part[0] =~ '\v[%#<]'
"         let expanded_part = fnameescape(expand(part))
"         let expanded_cmdline = substitute(expanded_cmdline, part, expanded_part, ')
"      endif
"   endfor
"
"   botright new
"   setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
"   call setline(1, 'You entered:    ' . a:cmdline)
"   call setline(2, 'Expanded Form:  ' .expanded_cmdline)
"   call setline(3,substitute(getline(2),'.','=','g'))
"   execute '$read !'. expanded_cmdline
"   setlocal nomodifiable
"   1
"endfunction
