" When you set the size of a window (presently using keymaps) it remembers its
" size, and restores to that size the next time you enter it.

" Ideally instead of keymaps would could intercept user-originated calls to
" :resize, e.g. from the mouse or from user or default mappings.
" (There is no WinResized event to attach to.)

" Alternatively, we could try *always* storing the size:
" autocmd WinLeave * call <SID>RememberHeight() | call <SID>RememberWidth()

" Current keybinds are: Ctrl-NumPadMultiply/Divide/Add/Subtract
nnoremap <silent> Om :resize -2<Enter>:call <SID>RememberHeight()<Enter>
nnoremap <silent> Ok :resize +2<Enter>:call <SID>RememberHeight()<Enter>
nnoremap <silent> Oo :vert resize -6<Enter>:call <SID>RememberWidth()<Enter>
nnoremap <silent> Oj :vert resize +6<Enter>:call <SID>RememberWidth()<Enter>
nmap <silent> = =:call ForgetAll()<Enter>

function! s:RememberHeight()
  let w:rememberedHeight = winheight(0)
endfunction

function! s:RememberWidth()
  let w:rememberedWidth = winwidth(0)
endfunction

autocmd WinEnter * call <SID>RestoreSize()

function! s:RestoreSize()
  if exists('w:rememberedWidth')
    exec "vert resize ".w:rememberedWidth
  endif
  if exists('w:rememberedHeight')
    exec "resize ".w:rememberedHeight
  endif
endfunction

" Exposed to user
function! ForgetAll()
  let l:winnr = winnr()
  windo unlet! w:rememberedHeight
  windo unlet! w:rememberedWidth
  exec l:winnr." wincmd w"
endfunction

" BUG: ForgetAll() sometimes changes the current window layout!
" CONSIDER: Could be better to store sizes in a global, so they can be
" forgotten easily (without visiting the windows!).
" OTOH: Using window-local rather than windowid-indexed vars means they
" disappear tidily when windows are closed or opened.
" Or we could just disable our WinEnter event handler during the windo calls.
" Or we can accept that ForgetAll might change the current window sizes!
