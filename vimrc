nnoremap <silent> <C-f> :TlistToggle<CR>
let Tlist_Inc_Winwidth = 0
let Tlist_GainFocus_On_ToggleOpen = 1
let Tlist_Highlight_Tag_On_BufEnter = 0

fun! ShowFuncName()
  let lnum = line(".")
  let col = col(".")
  echohl ModeMsg
  echo getline(search("^[^ \t#/]\\{2}.*[^:]\s*$", 'bW'))
  echohl None
  call search("\\%" . lnum . "l" . "\\%" . col . "c")
endfun
map f :call ShowFuncName() <CR>

fun! Switch()
  	let lnum = line(".")
  	let col = col(".")
	echohl ModeMsg
	let line = search("^.*switch.*$","esbW")
	echo getline(line) ":" line
	echohl None
  	call search("\\%" . lnum . "l" . "\\%" . col . "c")
endfun
map S :call Switch() <CR>

fun! Case()
let lnum = line(".")
let col = col(".")
echohl ModeMsg
echo getline(search("^.*case.*$",'bW'))
echohl None
call search("\\%" . lnum . "l" . "\\%" . col . "c")
endfun
map C :call Case() <CR>
