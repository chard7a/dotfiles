" Keep moving in given direction until we reach a new character under the
" cursor.  (Like Ctrl-Arrow Excel.)  Bound to Ctrl-Shift-Up/Down for Vim.

let g:move_stay_in_column   = 1   " Will not stop on shorter lines than the one we started on
let g:move_skip_empty_lines = 1   " Never stop on an empty line (if also unifying, never stop on whitespace)
let g:move_unify_whitespace = 1   " Tab, space and empty-line are all considered the same.
let g:move_once_at_start    = 1   " Argh!  New style sucks without this.  If you are on the 'c' of 'class' and want to skip all the whitespace to the next 'c', this won't do it - it will skip all the 'c's!  (Unless it happens to meet a / first.)  Really the question is, does the first move get the same char as the start?  If so, user wants to move out of first char, if not user probably wants to move out of second char (since first char would have been a single down press).  These comparisons *include* newlines/whitespace; we can't skip them!  OK now this option has been turned into just that check!

" Meh it's still a bit naff.  In you are on "public" and go down, you will either skip all the publics until something different, or if the next line is empty, you will simply jump to the next public.  What is the wanted behaviour anyway?  Don't stop on whitespace but stop after it as soon as we hit a non-blank, even if it's the same? 

" I guess I am confusing two features: one whitespace jumper, and one get-out-of-or-past-block, which require slightly different behaviour.  They are pretty similar - what is the difference?

nnoremap <silent> <C-S-Up> :call <SID>FindNextChange("k")<Enter>
nnoremap <silent> <C-S-Down> :call <SID>FindNextChange("j")<Enter>
" Attempt to work in Visual mode; failed:
"vnoremap <silent> <C-S-Up> :<C-U>call <SID>FindNextChange("k")<Enter>
"vnoremap <silent> <C-S-Down> :<C-U>call <SID>FindNextChange("j")<Enter>

function! s:FindNextChange(moveKey)
  let startCol = wincol()
  let unwatedChar = s:GetCharUnderCursor()
  if g:move_once_at_start
    exec "normal "a:moveKey
  endif
  let nextCharUnderCursor = s:GetCharUnderCursor()
  if nextCharUnderCursor != unwatedChar
    let unwatedChar = nextCharUnderCursor
  endif
  let lastRow = line(".")
  " echo "start (".startCol.",".lastRow.") ".unwatedChar
  while 1
    exec "normal ".a:moveKey
    let newCol = wincol()
    let newRow = line(".")
    let newCharUnderCursor = s:GetCharUnderCursor()
    " echo "(".newCol.",".newRow.") ".newCharUnderCursor
    if newRow == lastRow
      " Failed to move; better stop trying!  (probably reached a boundary)
      break
    endif
    if g:move_skip_empty_lines && newCharUnderCursor == ""
      " Do nothing, continue to next line
    elseif g:move_stay_in_column && newCol != startCol
      " Likewise
    else
      if newCharUnderCursor != unwatedChar
        " We have found what we were looking for!
        "if g:move_skip_empty_lines && unwatedChar == ""
          "let unwatedChar = newCharUnderCursor
          "" We never usually save empty lines, so the last line must have been the first line.  We don't break on the second line just cos the first is non-empty.
          "" I think this is all wrong now.  With new style, least-confusion says we do want to stop on it!
        "else
          "break
        "endif
        break
      endif
    endif
    let lastRow = newRow
  endwhile
endfunction

function! s:GetCharUnderCursor()
  let c = strpart(getline("."), col(".") - 1, 1)
  if g:move_unify_whitespace && (c==" " || c=="\t")
    let c = ""
  endif
  return c
endfunction

