

" :so ~/.vim/joey/joey.vim


"" Update ctags tags file whenever we save a buffer.
"" To get started,  :!touch tags  then  :w
"" I need this for Ctrl-] to work when I have e.g. added new *mapping* tag to
"" e.g. RepeatLast.vim
" autocmd BufWritePost,FileWritePost *.* :!ctags -a %
"" Only if a writeable tags file exists here:
" autocmd BufWritePost,FileWritePost *.* if filewritable("tags")==1 | exec "!ctags -a %" | endif
autocmd BufWritePost,FileWritePost *.* if filewritable("tags")==1 | if &ch>1 | echo "Updating tags..." | endif | silent exec '!ctags -a "%"' | endif
"" We could, iff &ch>1, do it non-silent, or use: echo "Updating tags..." |
"" TODO: Update ../tags or ../../tags or ../../../tags if it exists.  Could
"" cache it in b:my_nearest_tagsfile.


" >>> Options for plugins {{{

	let g:miniBufExplorerMoreThanOne = 0
	" let g:miniBufExplMaxHeight = 6
	" let g:miniBufExplMapWindowNavVim = 1
	let g:miniBufExplMapWindowNavArrows = 1  " or use version in joeykeymap.vim
	let g:miniBufExplUseSingleClick = 1
	" let g:miniBufExplShowUnlistedBuffers = 0
	" let g:miniBufExplShowOtherBuffers = 1
	" let g:miniBufExplorerDebugLevel = 995

	" >>> For taglist.vim {{{

		" TODO: Consider using cscope and an "overview" plugin instead of ctags/tlist

		" == Taglist Lag Issues ==
		" Taglist will enable Tlist_Auto_Update by default.
		" If Vim is being very slow, e.g. updating the taglist after writing a
		" big file, just do :TlistLock to disable refreshing and updating
		" entirely.
		" You can then do :TlistUpdate manually when required, or :TlistUnlock.

		let g:Tlist_Auto_Open            = 0
		let g:Tlist_Use_Right_Window     = 1
		let g:Tlist_Show_One_File        = 0
		let g:Tlist_File_Fold_Auto_Close = 0
		let g:Tlist_Compact_Format       = 0
		let g:Tlist_WinWidth             = 30
		let g:Tlist_Inc_Winwidth         = 0
		" Changing window width with Tlist_Inc_Winwidth doesn't seem to work properly
		" under compiz, it messes the window up, requiring a Ctrl-L to fix it.

		"" Taglist needs to know about any custom tag types declared in ~/.ctags
		"
		" The second part of the varname is the Vim &filetype associated with the file.
		" In other words, :echo "tlist_".&filetype."_settings" in order to generate the string below!
		" The first word of the string is the ctags language module used to parse the file.
		" Consult ctags --list-languages to obtain that string.
		" For the type entries, I don't know a good way to discover these.  I just run
		" ctags over a bunch of files, and look for the single-letter types at the end
		" of each line, then guess their names!
		"
		" My custom Javascript properties and exports tags kinda suck.
		" Exports might be nice if vim would only choose the functions over them!
		"
		" v:variable
		" p:property;a:assigned
		let tlist_javascript_settings = 'javascript;c:class;f:function;e:export;r:route'
		" v:variable
		" p:property;a:assigned
		let tlist_coffee_settings = 'coffee;c:class;f:function;e:export'
		"
		let tlist_uc_settings = 'c;c:class;s:state;v:variable;f:function;m:method'
		"
		" java,javascript,c all create tags for uc files, but c lists more!
		" Labels in asm are a big distraction from more fundamental constructs
		let tlist_asm_settings = 'asm;c:context;m:macro;d:define' " l:label;
		let tlist_ocaml_settings = 'ocaml;M:module;t:type;c:class;m:method;v:variable;e:exception'
		let tlist_python_settings = 'python;c:class;m:member;f:function'
		" BUG: It seems taglist won't even use it's own defined defaults.  I get
		" no tags for a language until I define it here.  That can't be right,
		" have I broken taglist?!
		let tlist_vim_settings = 'vim;a:autocmds;v:variable;f:function;c:command;m:map' " ;h:htag'
		let tlist_dosini_settings = 'dosini;s:section'
		let tlist_haxe_settings = 'haxe;p:package;d:typedef;e:enum;t:enum_field;c:class;i:interface;f:function;v:variable'
		let tlist_grm_settings = 'joeygrammar;r:rule'
		let tlist_haskell_settings = 'haskell;d:data;t:type;s:signature;f:function' " ;p:pattern
		let tlist_markdown_settings = 'markdown;1:level1;2:level2;3:level3'
		let tlist_help_settings = 'help;s:section;h:heading' " ;m:marker
		let tlist_scala_settings = 'scala;p:package;i:include;c:class;o:object;t:trait;r:cclass;a:aclass;m:method;T:type' " V:value;v:variable;
		let tlist_man_settings = 'man;s:section'
		let tlist_html_settings = 'html;t:template;a:anchor;f:javascript function'
		let tlist_opa_settings = 'opa;m:module;t:type;d:database;g:global;f:function'

	" }}}

	" >>> For vtreeexplorer.vim {{{
		let g:treeExplVertical = 1
		let g:treeExplWinSize = 24
		" let g:treeExplAutoClose = 0
		let g:treeExplNoList = 1
	" }}}

	" let g:NERDTreeMinimalUI=1
	"" Firstly this fixes the bug of Vim starting with MBE focused (or not focused)
	"" Secondly I don't want it to hijack netrw anyway!
	let g:NERDTreeHijackNetrw = 0

	let g:Grep_OpenQuickfixWindow = 1
	let g:Grep_Default_Filelist = ". -r -I --exclude-dir=CVS --exclude-dir=.git --exclude-dir=bin --exclude-dir=build --exclude-dir=_build --exclude-dir=node_modules --exclude=tags --exclude=\'.*.sw?\' --exclude=\\*.min.js --exclude=\'*.log\'"

	let g:ConqueTerm_Color = 1
	" let g:ConqueTerm_CloseOnEnd = 1
	let g:ConqueTerm_CloseOnEndIfSplit = 1
	" let g:ConqueTerm_CloseOnSuccess = 1
	let g:ConqueTerm_InsertOnEnter = 1
	let g:ConqueTerm_ReadUnfocused = 1   " I fear this may be preventing me from leaving the window!

	let g:yaifa_max_lines = 400   " taglist.vim needs at least 100, minibufexpl.vim needs 312!

	"" Now I am using sessionman.vim
	"" Balls am I.  I am using my own, simplesession.vim !
	"" For sessionman.vim:
	let g:sessionman_save_on_exit = 0     " disabled for now
	let g:sessionlist_stay_open = 1
	let g:sessionman_preview_sessions = 1
	"" For session.vim:
	let g:session_autosave = 1

	" Can't be set here.  Needs to be set late!
	" :set winheight 40

	" SkyBison
	cnoremap <c-k> <c-r>=SkyBison("")<cr><cr>
	" TODO: Would rather do this later so we can check if SkyBison is present.

	let g:recover_always_choose = 1   " diff
	let g:recover_delete_swapfile_if_identical = 1
	let g:recover_delete_swapfile_when_diffing = 1

	let g:ctrlp_map = '<c-t>'
	let g:ctrlp_custom_ignore = {
		\ 'dir':  '\v[\/](CVS|\.git|\.hg|\.svn|node_modules)$',
		\ 'file': '\v\.(exe|so|dll)$'
	\ }
		"\ 'file': '\..*\.sw.$',
		"\ 'link': 'SOME_BAD_SYMBOLIC_LINKS',

	"nmap <C-a> :AsyncFinder<Enter>
	" I usually have RepeatLast enabled.  If so, this works much better:
	"nmap <C-a> q:AsyncFinder<Enter>
	nmap <silent> <C-a> :if exists("g:RepeatLast_Enabled") && g:RepeatLast_Enabled <Bar> :normal q<Enter> <Bar> :endif <Bar> :AsyncFinder<Enter>
	let g:asyncfinder_initial_pattern = '**'
    let g:asyncfinder_ignore_dirs = "['*.AppleDouble*','*.DS_Store*','.git','*.hg*','*.bzr*','CVS','.svn','node_modules']"

	" Neither of these really worked how I wanted.  How about SkyBison?
	nmap <C-d> :e **/*<C-k>

	let g:gitgutter_diff_args = '-w "master@{1 week ago}"'

" }}}



" >>> Options for MY plugins {{{

	let g:hiline = 1
	let g:hiword = 1

	let g:search_centered = 0

	let g:blinking_statusline = 1

	let g:RepeatLast_Enabled = 1
	let g:RepeatLast_TriggerCursorHold = 3
	let g:RepeatLast_SaveToRegister = 'l'
	set ch=2
	" let g:RepeatLast_Show_Debug_Info = 1
	" set ch=3

	let g:coffeeAutoCompileAll = 1
	let g:coffeeShowJSChanges = 1

	let g:breakindent_char = ' '

	" let coffee_compile_on_save=1

	let g:ToggleMaximize_RestoreWhenSwitchingWindow = 1

	let g:NoSwapSuck_CheckSwapfileOnLoad = 0

	let g:wrs_default_height_pct = 90

" }}}



" >>> Options for VIM itself {{{

	set background=dark

	set updatetime=300

	" My defaults, which may be overridden later by filetype rules, plugins, or
	" modeline.
	set sw=3 "shiftwidth
	set ts=3 "tabstop

	" The default textwidth=0 will wrap to screen width, if screen width is <79.  This seems undesirable to me.  If we are wrapping, let's wrap to "the standard width" 80.
	"set textwidth=79
	" On second thought, being a significant whitespace nazi, I don't actually want auto-wrapping when I am typing.  Leaving it at 0 helps to achieve this.

	"" If you need to fix backspace, try one of these:
	" :fixdel
	" :set t_kD=^V<Delete>
	" :!echo "keycode 14 = BackSpace" | loadkeys
	"" All from the manual: :h :fixdel

	"" See help for 'statusline' and %{eval_expr}
	" :set titlestring=[VIM]\ %m\ %F
	"" Had to use BufEnter to act after other plugins using BufEnter!
	"" Might not work here in .vimrc - I was testing from command line.
	" :auto BufEnter * set titlestring=(VIM)\ %m\ %F
	" :auto BufEnter * set titlestring=(VIM)\ %q%w%m\ %F\ %a
	" :auto BufEnter * set titlestring=[VIM]\ %q%w%m\ %F\ %y\ %a
	"" This number does not increase if we flip through with :bn instead of :n
	" :set titlestring=[VIM]%(\ %M%)\ %t%(\ (%{expand(\"%:~:.:h\")})%)%(\ %a%)
	" :auto BufEnter * set titlestring=[VIM]%(\ %M%)\ %t%(\ (%{expand(\"%:~:.:h\")})%)%(\ %a%)
	"" OTOH, it is pretty darn useful to see the arg count even if the buffer number is wrong.
	"" Inaccurate but interesting:
	"" The BufEnter hook is no longer working.
	" :auto BufEnter * set titlestring=[VIM]%(\ %M%)\ %t%(\ (%{expand(\"%:~:.:h\")})%)%(\ (%n/%{bufnr('$')})%)
	" :auto BufEnter * set titlestring=[VIM]%(\ %M%)\ %t%(\ (%{expand(\"%:~:.:h\")})%)%(\ (%n/%{argc()})%)
	"" Accurate:
	" :auto BufEnter * set titlestring=[VIM]%(\ %M%)\ %t%(\ (%{expand(\"%:~:.:h\")})%)%(\ (%{bufnr('$')}\ buffers)%)
	"" Percentage through file instead:
	" :auto BufEnter * set titlestring=[VIM]%(\ %M%)\ %t%(\ (%{expand(\"%:~:.:h\")})%)%(\ [%P]%)

	"" Now prepending all Vim title's with "= " so they are clearly grouped in task list.
	" :set titlestring=\=%(\ %M%)\ %t%(\ (%{expand(\"%:~:.:h\")})%)%(\ [%P]%)
	"" It will only make things worse.  :p

	" if has("gui_kde")
	" 	set guifont=Courier\ 10\ Pitch/10/-1/5/50/0/0/0/1/0
	" endif

	" if has("gui_kde")
	" set guifont=Lucida\ Console/8/-1/5/50/0/0/0/1/0
	" endif

	" if has("gui_kde") || has("gui_x")
		" set guifont=Bitstream\ Vera\ Sans\ Mono/10/-1/5/50/0/0/0/1/0
	" endif

	"" Medium for any linux:
	" :set guifont=-*-lucidatypewriter-*-*-*-*-*-80-*-*-*-*-*-*   "" fail
	"" Small for any linux:
	" :set guifont=-*-fixed-*-*-*-*-*-80-*-*-*-*-*-*

	" :set guifont=Fixed\ Semi-Condensed\ 7
	" :set guifont=Fixed\ Semi-Condensed\ 9
	" :set guifont=Beeb\ Mode\ One\ 6

	"" Good for Debian, a bit naff on Gentoo:
	" :set guifont=Monospace\ 8
	"" Good for Gentoo, missing on Debian:
	" :set guifont=LucidaTypewriter\ 8
	"" Nice small font (a little bit like clean at this size) Works on Debian
	" :set guifont=DejaVu\ Sans\ Mono\ 7
	" :set guifont=Monospace\ 7
	"" Less tall:
	" :set guifont=Liberation\ Mono\ Bold\ 7
	"" Less tall again.  Looks like LucidaTypewriter, which is not visible on Debian.  (Semi-Condensed appears to be the same as the default!)
	" :set guifont=Lucida\ Console\ Semi-Condensed\ 7
	" :set guifont=Lucida\ Console\ Semi-Condensed\ 8
	"" On pod Semi-Condensed was actually wider!  So:
	:set guifont=Lucida\ Console\ 8
	"" Very small and clear; quite like Teletext font
	" :set guifont=MonteCarlo\ Fixed\ 12\ 11
	if exists("&guifont")
		if $SHORTHOST == "pod"
			"" Most Linux offer Mono but it's a little tall
			" :set guifont=Monospace\ 8
			"" On Ubuntu Liberation is slightly shorter
			:set guifont=Liberation\ Mono\ 8
		endif
		if $SHORTHOST == "porridge"
			"" Another Ubuntu, with more pixels
			":set guifont=Monospace\ 11
			":set guifont=Liberation\ Mono\ 11
			"" Screen font; brighter:
			":set guifont=Liberation\ Mono\ 10
			"" Rounded but not so bright, same size boxes but smaller chars!
			":set guifont=Andale\ Mono\ 9
			"" At size 10 this is shorter than Andale.  In fact it is shorter than my xterm 100, although it doesn't look it!
			"" :set guifont=Lucida\ Console\ 10
			"" Actually it's shorter than Andale at size 9 also, although it doesn't look it!
			:set guifont=Lucida\ Console\ 7
			"" And it's quite readable (and short) at size 7, although small.
			"" I know you have come back here to switch away from Lucida Console.  Don't!
		endif
		" Hide the menu and toolbar which I never use.
		:set guioptions-=m
		:set guioptions-=T
	endif


	" set tabline=%!MyTabLine()
	" set showtabline=2 " 2=always
	" autocmd GUIEnter * hi! TabLineFill term=underline cterm=underline gui=underline
	" autocmd GUIEnter * hi! TabLineSel term=bold,reverse,underline \ ctermfg=11 ctermbg=12 guifg=#ffff00 guibg=#0000ff gui=underline

	" ATM If we edit a textfile with wrap set from here, and write a long line, it will auto-newline.  With nowrap it is fine.
	" :set wrap
	:set linebreak
	" :set nolist
	" There is :set list in joey.vim :P
	:set sidescroll=5
	" listchars and showbreak now defined in joey.vim

	" Flashing cursor means lag for gaming!
	":set guicursor=a:blinkoff0

	"" Minimal/informative foldline:
	" :set foldtext=v:folddashes.'['.(v:foldend-v:foldstart+1).']'.getline(v:foldstart)
	"" Append this to hide leading /*
	" .substitute(getline(v:foldstart),'\/\*','','g')
	"" Trim any leading whitespace
	" :set foldtext=v:folddashes.'['.(v:foldend-v:foldstart+1).']\ '.substitute(getline(v:foldstart),'^[\ \	]*','','')

	"" Retain current line's indent, but replace with dashes
	"" BUG: each tab is replaced with one '-' but should be replaced with tabstop of them!
	" :set foldtext=substitute(substitute(getline(v:foldstart),'[^\ \	].*','',''),'[\ \	]','-','g').'['.(v:foldend-v:foldstart+1).']\ '.substitute(getline(v:foldstart),'^[\ \	]*','','')
	"" Fixed version:
	:set foldtext=substitute(substitute(substitute(getline(v:foldstart),'[^\ \	].*','',''),'[\ ]','-','g'),'[\	]',repeat('-',\&tabstop),'g').'['.(v:foldend-v:foldstart+1).']\ '.substitute(getline(v:foldstart),'^[\ \	]*','','')
	"" Alternative version:
	" :set foldtext=substitute(substitute(substitute(getline(v:foldstart),'[^\ \	].*','',''),'[\ ]','-','g'),'[\	]',repeat('-',\&tabstop),'g').substitute(getline(v:foldstart),'^[\ \	]*','','').'\ \ \ ['.(v:foldend-v:foldstart+1).'\ lines]\ '

	" I find groups of windows clearer/easier to navigate when they squash up.
	set winminheight=0

	set formatoptions+=n            " Better indent numbered lists in comments
	set formatoptions+=l            " Don't wrap lines that were already long
	if version >= 703
		set formatoptions+=j            " Remove comment leaders when joining
	end

	"if version >= 703
		"set colorcolumn=+1
	"end

	" Add a few custom filetypes:
	au BufRead,BufNewFile {*.shlib}              set ft=sh
	au BufRead,BufNewFile {*.grm}                set ft=grm
	au BufRead,BufNewFile {*.json}               set ft=javascript
	au BufRead            {*/xchatlogs/*.log}    set ft=irclog readonly
	" From web:
	au BufRead,BufNewFile {/usr/share/X11/xkb/*} set ft=c
	au BufRead,BufNewFile {*.md}                 set ft=markdown

	"" I need to update some of my highlights for 256 color mode, so I'm not
	"" using it at the moment.
	" if $TERM != "linux" && $TERM != "screen"
		" set t_Co=256
	" end

	"" Recognise Node stack-traces:
	"" Basic:
	"let &errorformat .= ',' . '%*[\ ]%m (%f:%l:%c)'
	"" Full:
	" Error: bar
	"     at Object.foo [as _onTimeout] (/Users/Felix/.vim/bundle/vim-nodejs-errorformat/test.js:2:9)
	let &errorformat  = '%AError: %m' . ','
	let &errorformat .= '%Z%*[\ ]%m (%f:%l:%c)' . ','
	"     at Object.foo [as _onTimeout] (/Users/Felix/.vim/bundle/vim-nodejs-errorformat/test.js:2:9)
	let &errorformat .= '%*[\ ]%m (%f:%l:%c)' . ','
	" /Users/Felix/.vim/bundle/vim-nodejs-errorformat/test.js:2
	"   throw new Error('bar');
	"         ^
	let &errorformat .= '%A%f:%l,%Z%p%m' . ','
	" Ignore everything else
	"let &errorformat .= '%-G%.%#'
	" If not working, see project: https://github.com/felixge/vim-nodejs-errorformat/blob/master/ftplugin/javascript.vim

	"" Thought this would make Vim swapfile messages smaller, but it didn't.  :P
	" set shortmess+=A

	"" For the autocompleter:
	"" longest won't select the first result if there are many; it will let you type more to narrow the list.
	"" menuone will display the menu even if there is only one possibility; this allows you to see any meta-info (e.g. the filename containing this word)
	"set completeopt+=longest,menuone
	"" This is pretty nice, but the autocompleter is so great, it often places the thing I want first in the list.  So I can just press <Tab> once.  This seems more of a time-saver.  Use the above only if the thing you want keeps appearing far down a list of many items.
	"" So I am sticking with the default now:
	"set completeopt=menu,preview


" }}}



" >>> Key mappings / Key bindings {{{

	" Most of my good keybinds are stored in ~/.vim/plugins/joeykeymap.vim
	" What follows are bindings I am testing before sharing.

	" Fix broken Backspace under gentoo:
	" :imap  <Left><Del>

	" I never need to use this key, and my Escape key is a bit tempramental.
	map £ <Esc>
	imap £ <Esc>

	" BUG TODO: Sometimes saves a file called session.vim in my .vim/plugins folder!
	"           In fact many folders under ~/.vim/ hold auto executing .vim scripts!
	" Sometimes I quit a vim session when I only really meant to quit the current
	" file.  These intercepts save a session file whenever quitting, so if I want
	" to get the vim session back I can just reload it!
	" When quitting vim in a hurry, save a brief cache of the session:
	" FIXED I HOPE: If you cannot write the file (e.g. you piped to vi -) then these
	"               fail, and prevent the user from quitting!
	"        FIXED: Actually I think that may have been because :qa! mapped only to :qa
	" WINDOWID is the closest we have to a unique session id for now.
	"nnoremap :q<Enter> :mksession! ~/.vim/sessions/session-$WINDOWID.vim<Enter>:q<Enter>
	"nnoremap :qa<Enter> :mksession! ~/.vim/sessions/session-$WINDOWID.vim<Enter>:qa<Enter>
	"nnoremap :qa!<Enter> :mksession! ~/.vim/sessions/session-$WINDOWID.vim<Enter>:qa!<Enter>
	"nnoremap :wq<Enter> :mksession! ~/.vim/sessions/session-$WINDOWID.vim<Enter>:wq<Enter>
	"nnoremap :wqa<Enter> :mksession! ~/.vim/sessions/session-$WINDOWID.vim<Enter>:wqa<Enter>
	"nnoremap :wqa!<Enter> :mksession! ~/.vim/sessions/session-$WINDOWID.vim<Enter>:wqa!<Enter>
	" If you need to avoid using these, just do ::wqa
	" TODO: I also want this to run if I close Vim accidentally, e.g. with Ctrl-w c
	" TODO: Put the above in a loop.

" }}}



" >>> Custom Plugin Loader (a fix for me) {{{

	" Plugins
	" CVS leaves old versions in ~/.vim/plugins/CVS/Base/*.vim
	" These get loaded by Vim!
	" But we can disable auto-loading, and load them manually ourself, without
	" the subdirectories.  This could cause problems, but at time of writing, I
	" could not find any .vim files in subdirs of standard Vim plugin folders.
	"set noloadplugins
	" Original behaviour: runtime! plugin/**/*.vim
	"runtime! plugin/*.vim

	augroup ForbidCVS
		autocmd!
		autocmd SourceCmd */CVS/* :" Do nothing
		"autocmd SourceCmd */CVS/* echo "Not sourcing CVS script: ".expand("<afile>")
	augroup END

" }}}



" >>> Addons (the neat way) {{{

	"" We are using VAM.  http://github.com/MarcWeber/vim-addon-manager
	"" Note that this is NOT Debian's vim-addon-manager package!  Nor is it pathogen.
	"" I build the list, rather than declare it, so lines can be easily added/removed.
	let vamAddons = []
	" call add(vamAddons,"vim-haxe")                       " Haxe syntax
	" call add(vamAddons,'github:jdonaldson/vim-haxe')     " Haxe syntax
	call add(vamAddons,'github:jdonaldson/vaxe')           " Haxe syntax (preferred)
	" call add(vamAddons,'github:derekwyatt/vim-scala')      " Scala syntax and more
	" call add(vamAddons,'/stuff/joey/projects/scala/scala-dist-vim') " Older but does not load this way!
	call add(vamAddons,'github:mbbill/undotree')           " Allows you to view undos.  I need a newer Vim for this!
	call add(vamAddons,'github:majutsushi/tagbar')         " Nests tags in some languages.
	" call add(vamAddons,"VOoM")                           " Another outliner
	" call add(vamAddons,'github:xolox/vim-easytags')      " Runs ctags automatic for you, to update them
	" call add(vamAddons,'github:vim-scripts/UltiSnips')   " Breaks my usual Tab-completion!
	" call add(vamAddons,'github:troydm/easybuffer.vim')
	" call add(vamAddons,'github:chrisbra/NrrwRgn')
	" call add(vamAddons,'github:vim-scripts/YankRing.vim')
	" call add(vamAddons,'github:michaelficarra/vim-coffee-script')   " Coffeescript syntax
	"" DISABLED: YankRing blocks 'P' (paste) from being a repeatable action with '.' - I cannot have that!
	"" Instead of how YankRing does it, I'd quite like to have "2p to paste the second-to-last yank.
	call add(vamAddons,"github:paradigm/SkyBison")          " Immediate feedback on the cmdline.  I never use this, Tab-completion is pretty fine for me.
	call add(vamAddons,"github:joeytwiddle/vim-diff-traffic-lights-colors")
	call add(vamAddons,"github:gokcehan/vim-yacom")      " Toggle comments with <Leader>c
	call add(vamAddons,"github:digitaltoad/vim-jade")    " Jade syntax
	call add(vamAddons,"github:FredKSchott/CoVim")       " Collaborative editing with vim!
	" call add(vamAddons,"github:Raimondi/YAIFA")          " Indent Finder
	call add(vamAddons,"github:vim-scripts/yaifa.vim")   " Indent Finder
	" call add(vamAddons,"github:vim-scripts/vtreeexplorer.vim")   " File Manager (I have this in plugin/ already)
	" call add(vamAddons,"github:kien/ctrlp.vim")          " Quick file finder (I mapped it to Ctrl-T).  Docs: http://kien.github.io/ctrlp.vim/
	call add(vamAddons,"github:joeytwiddle/asyncfinder.vim")   " Another quick file finder (I mapped it to Ctrl-A).
	call add(vamAddons,"github:tpope/vim-fugitive")      " Git helper uses copen a lot, and allows editing indexes.  :Glog :Ggrep
	call add(vamAddons,"github:gregsexton/gitv")         " Addon to fugitive, with range :Gitv!
	"call add(vamAddons,"github:airblade/vim-gitgutter")  " Git meta-info about each line (in left-hand signs column (the gutter), or the background color of each line)
	"call add(vamAddons,"github:mhinz/vim-signify")       " Similar but supports more VCSs!  BUT was pretty slow on some files, and completely locking up vim on some others (e.g.: j/tools/wine and ~/.vim/ftplugin/sh.vim).  Even turning it off with :SignifyToggle took ages!
	call add(vamAddons,"github:terryma/vim-expand-region")   " Grow the visual block easily
	call add(vamAddons,"github:vim-scripts/ScreenShot")  " Take HTML screenshots of your Vim
	call add(vamAddons,"github:tpope/vim-repeat")        " Helps `.` to work with plugins (including fanfingtastic)
	call add(vamAddons,"github:dahu/vim-fanfingtastic")  " multi-line f,t,F,T - works well for me.
	"call add(vamAddons,"github:chrisbra/improvedft")     " Another one to try
	"call add(vamAddons,"github:vim-scripts/SearchComplete") " Tab-completion in the / search interface.  This breaks <Up> and intereferes with :b and and :Grep.
	"call add(vamAddons,"github:goldfeld/vim-seek")       " Quickly seek new position by 2 chars, on `s`

	"call add(vamAddons,"github:Raimondi/vim-buffalo")    " Buffer switcher - needs some extra attention to get it working, or maybe I just need the right vim version/patch.

	" == My Plugins from the Cloud ==
	call add(vamAddons,"github:joeytwiddle/git_shade.vim") " Colors lines in different intensities according to their age in git's history
	call add(vamAddons,"github:joeytwiddle/taglist.vim") " Joey's taglist.vim with vague indentation mode and other madness
	call add(vamAddons,"github:joeytwiddle/zoom.vim")    " Change font size easily
	call add(vamAddons,"github:joeytwiddle/sexy_scroller.vim")   " Smooth animation when scrolling
	call add(vamAddons,"github:joeytwiddle/vim-seek")    " Adding multi-line support
	let g:seek_multi_line = 1
	let g:SeekKey = 'l'
	let g:seek_subst_disable = 1

	" This test does not work!  Yes it does!?
	" if exists("*vam#ActivateAddons") || 1
	let vam_found_dir = $HOME . "/.vim-addon-manager/vim-addon-manager/"
	if isdirectory(vam_found_dir)

		" set runtimepath+=$HOME/.vim-addon-manager/vim-addon-manager/
		let &runtimepath = &runtimepath . "," . vam_found_dir
		call vam#ActivateAddons(vamAddons, {'auto_install' : 1})
		"" or
		" call vam#ActivateAddons(["vim-haxe"])
		" call vam#ActivateAddons(["github:jdonaldson/vaxe"])

		"" For some unknown reason this stopped working!
		"" So here I fix what is needed:
		" set runtimepath+=$HOME/.vim-addon-manager/github-jdonaldson-vaxe/
		"" Oh - the reason was joeysdefaults.vim sourcing debian.vim unnecessarily.

	endif

" }}}



" vim: foldmethod=marker foldenable
