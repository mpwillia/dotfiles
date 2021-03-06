

"Usage:
"       xxd [options] [infile [outfile]]
"    or
"       xxd -r [-s [-]offset] [-c cols] [-ps] [infile [outfile]]
"Options:
"    -a          toggle autoskip: A single '*' replaces nul-lines. Default off.
"    -b          binary digit dump (incompatible with -ps,-i,-r). Default hex.
"    -c cols     format <cols> octets per line. Default 16 (-i: 12, -ps: 30).
"    -E          show characters in EBCDIC. Default ASCII.
"    -g          number of octets per group in normal output. Default 2.
"    -h          print this summary.
"    -i          output in C include file style.
"    -l len      stop after <len> octets.
"    -ps         output in postscript plain hexdump style.
"    -r          reverse operation: convert (or patch) hexdump into binary.
"    -r -s off   revert with <off> added to file positions found in hexdump.
"    -s [+][-]seek  start at <seek> bytes abs. (or +: rel.) infile offset.
"    -u          use upper case hex letters.
"    -v          show version: "xxd V1.10 27oct98 by Juergen Weigert".



"Enables the command :HexDump to open the given file in hex mode within a
"temporary scratch buffer
command! -complete=shellcmd -nargs=+ HexDump call s:HexDumpFile(<q-args>)

"Quick abbreviations
cabbrev hexdump HexDump
cabbrev xd HexDump
cabbrev hxd HexDump

"Opens the given file in hex mode within a temporary scratch buffer
function! s:HexDumpFile(args)
   botright new
   setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
   call setline(1, 'Hex dump of: ' . a:args)

   "HexDump is done by the 'xxd' shell command
   "':r!' executes the given shell command and writes its output to the buffer; see ':help r!'
   "therefore ':r !xxd ' . a:args executes 'xxd' with the given arguments and 
   "dumps it's output to the newly made scratch buffer
   execute ':r !xxd ' . a:args
   setlocal nomodifiable
   1
endfunction
