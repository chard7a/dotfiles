" Keep moving in given direction until we reach a new character under the
" cursor.  (Like Ctrl-Arrow Excel.)  Bound to Ctrl-Shift-Up/Down for Vim.

let g:move_unify_whitespace = 0   " Tab, space and empty-line are all considered the same.
let g:move_skip_empty_lines = 1   " Never stop on an empty line (or if also unifying, never because of whitespace; a different printable char must be found)

nnoremap <silent> <C-S-Up> :call <SID>FindNextChange("k")<Enter>
nnoremap <silent> <C-S-Down> :call <SID>FindNextChange("j")<Enter>

function! s:FindNextChange(moveKey)
  " We used to make one initial move without checking
  " I'm no longer convinced we want that.
  " It makes sense when we are above a new block that we want to skip over.
  " But it doesn't make sense if the next line is empty, and we are trying to reach our sibling (which has the same name, but blank lines in between).
  "exec "normal "a:moveKey
  let lastCol = col(".")
  let lastRow = line(".")
  let lastCharUnderCursor = s:GetCharUnderCursor()
  while 1
    exec "normal ".a:moveKey
    let newCol = col(".")
    let newRow = line(".")
    let newCharUnderCursor = s:GetCharUnderCursor()
    if newCol == lastCol && newRow == lastRow
      " Failed to move; probably reached a boundary
      break
    endif
    if g:move_skip_empty_lines && newCharUnderCursor == ""
      " Do nothing, continue to next line
    else
      if newCharUnderCursor != lastCharUnderCursor
        " We have found what we were looking for!
        if g:move_skip_empty_lines && lastCharUnderCursor == ""
          " We never usually save empty lines, so the last line must have been the first line.  We don't break on the second line just cos the first is empty.
        else
          break
        endif
      endif
    endif
    let lastCol = newCol
    let lastRow = newRow
    let lastCharUnderCursor = newCharUnderCursor
  endwhile
endfunction

function! s:GetCharUnderCursor()
  let c = strpart(getline("."), col(".") - 1, 1)
  if g:move_unify_whitespace && (c==" " || c=="\t")
    let c = ""
  endif
  return c
endfunction
