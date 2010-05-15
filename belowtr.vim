" Vim color file
" Maintainer:  Ebon Elza <ebonelza@gmail.com>
" Last Change: 2010-03-17
"
" belowtr.vim - Based on zmrok.vim color scheme by Krzysztof Goj, with
" elements from wombat256.vim by David Liang, wombat.vim by Lars Nielsen,
" and desert256.vim by Henry So Jr.  Reminiscient of the palette used in the
" game Below the Root.
"

set background=dark

if version > 580
  hi clear
  if exists('syntax_on')
    syntax reset
  endif
endif

let g:colors_name='belowtr'

if !has("gui_running") && &t_Co != 88 && &t_Co != 256
	finish
endif


" functions {{{
" returns an approximate grey index for the given grey level
fun <SID>grey_number(x)
	if &t_Co == 88
		if a:x < 23
			return 0
		elseif a:x < 69
			return 1
		elseif a:x < 103
			return 2
		elseif a:x < 127
			return 3
		elseif a:x < 150
			return 4
		elseif a:x < 173
			return 5
		elseif a:x < 196
			return 6
		elseif a:x < 219
			return 7
		elseif a:x < 243
			return 8
		else
			return 9
		endif
	else
		if a:x < 14
			return 0
		else
			let l:n = (a:x - 8) / 10
			let l:m = (a:x - 8) % 10
			if l:m < 5
				return l:n
			else
				return l:n + 1
			endif
		endif
	endif
endfun

" returns the actual grey level represented by the grey index
fun <SID>grey_level(n)
	if &t_Co == 88
		if a:n == 0
			return 0
		elseif a:n == 1
			return 46
		elseif a:n == 2
			return 92
		elseif a:n == 3
			return 115
		elseif a:n == 4
			return 139
		elseif a:n == 5
			return 162
		elseif a:n == 6
			return 185
		elseif a:n == 7
			return 208
		elseif a:n == 8
			return 231
		else
			return 255
		endif
	else
		if a:n == 0
			return 0
		else
			return 8 + (a:n * 10)
		endif
	endif
endfun

" returns the palette index for the given grey index
fun <SID>grey_color(n)
	if &t_Co == 88
		if a:n == 0
			return 16
		elseif a:n == 9
			return 79
		else
			return 79 + a:n
		endif
	else
		if a:n == 0
			return 16
		elseif a:n == 25
			return 231
		else
			return 231 + a:n
		endif
	endif
endfun

" returns an approximate color index for the given color level
fun <SID>rgb_number(x)
	if &t_Co == 88
		if a:x < 69
			return 0
		elseif a:x < 172
			return 1
		elseif a:x < 230
			return 2
		else
			return 3
		endif
	else
		if a:x < 75
			return 0
		else
			let l:n = (a:x - 55) / 40
			let l:m = (a:x - 55) % 40
			if l:m < 20
				return l:n
			else
				return l:n + 1
			endif
		endif
	endif
endfun

" returns the actual color level for the given color index
fun <SID>rgb_level(n)
	if &t_Co == 88
		if a:n == 0
			return 0
		elseif a:n == 1
			return 139
		elseif a:n == 2
			return 205
		else
			return 255
		endif
	else
		if a:n == 0
			return 0
		else
			return 55 + (a:n * 40)
		endif
	endif
endfun

" returns the palette index for the given R/G/B color indices
fun <SID>rgb_color(x, y, z)
	if &t_Co == 88
		return 16 + (a:x * 16) + (a:y * 4) + a:z
	else
		return 16 + (a:x * 36) + (a:y * 6) + a:z
	endif
endfun

" returns the palette index to approximate the given R/G/B color levels
fun <SID>color(r, g, b)
	" get the closest grey
	let l:gx = <SID>grey_number(a:r)
	let l:gy = <SID>grey_number(a:g)
	let l:gz = <SID>grey_number(a:b)

	" get the closest color
	let l:x = <SID>rgb_number(a:r)
	let l:y = <SID>rgb_number(a:g)
	let l:z = <SID>rgb_number(a:b)

	if l:gx == l:gy && l:gy == l:gz
		" there are two possibilities
		let l:dgr = <SID>grey_level(l:gx) - a:r
		let l:dgg = <SID>grey_level(l:gy) - a:g
		let l:dgb = <SID>grey_level(l:gz) - a:b
		let l:dgrey = (l:dgr * l:dgr) + (l:dgg * l:dgg) + (l:dgb * l:dgb)
		let l:dr = <SID>rgb_level(l:gx) - a:r
		let l:dg = <SID>rgb_level(l:gy) - a:g
		let l:db = <SID>rgb_level(l:gz) - a:b
		let l:drgb = (l:dr * l:dr) + (l:dg * l:dg) + (l:db * l:db)
		if l:dgrey < l:drgb
			" use the grey
			return <SID>grey_color(l:gx)
		else
			" use the color
			return <SID>rgb_color(l:x, l:y, l:z)
		endif
	else
		" only one possibility
		return <SID>rgb_color(l:x, l:y, l:z)
	endif
endfun

" returns the palette index to approximate the 'rrggbb' hex string
fun <SID>rgb(rgb)
	let l:r = ("0x" . strpart(a:rgb, 0, 2)) + 0
	let l:g = ("0x" . strpart(a:rgb, 2, 2)) + 0
	let l:b = ("0x" . strpart(a:rgb, 4, 2)) + 0
	return <SID>color(l:r, l:g, l:b)
endfun

" sets the highlighting for the given group
fun <SID>X(group, fg, bg, attr)
	if a:fg != ""
		exec "hi ".a:group." guifg=#".a:fg." ctermfg=".<SID>rgb(a:fg)
	endif
	if a:bg != ""
		exec "hi ".a:group." guibg=#".a:bg." ctermbg=".<SID>rgb(a:bg)
	endif
	if a:attr != ""
		if a:attr == 'italic'
			exec "hi ".a:group." gui=".a:attr." cterm=none"
		else
			exec "hi ".a:group." gui=".a:attr." cterm=".a:attr
		endif
	endif
endfun
" }}}


" General colors
" Normal:f8f8f8:0e0e0e:none
call <SID>X('Normal',	    	'c8c8c8',	'0e0e0e',	'none')
call <SID>X('Cursor',       '000000', '00ee00', 'none')
call <SID>X('NonText',      '505050', '0f0f0f', 'none')
call <SID>X('LineNr',       '505050', '000000', 'none')
call <SID>X('Visual',       'ecee90', '597418', 'none')
call <SID>X('StatusLine',   'fff000', '202080', 'bold')
call <SID>X('StatusLineNC', '505050', '1d1d1d', 'none') " whoa #291929 is a nice purple
call <SID>X('VertSplit',    '292929', '202020', 'none')
call <SID>X('Folded',       '808088', '131313', 'bold,italic')


" Netrw, NERDTree
call <SID>X('Directory',    '6360b8', '',       'bold')
call <SID>X('treeOpenable', '393952', '',       'none')
call <SID>X('treePart',     '393952', '',       'none')


" Vim >= 7.0 specific colors
if version >= 700
  call <SID>X('CursorLine',   '',       '131313', 'none')
  call <SID>X('CursorColumn', '',       '131313', 'none')
  call <SID>X('MatchParen',   '000000', 'ffcc20', 'bold')
  call <SID>X('Pmenu',        '141414', 'cda869', 'none')
  call <SID>X('PmenuSel',     'f8f8f8', '9b703f', 'none')
  call <SID>X('PmenuSbar',    '',       'daefa3', 'none')
  call <SID>X('PmenuThumb',   '8f9d6a', '',       'none')
endif


" Syntax highlighting
call <SID>X('Comment',      '636068', '',       'italic')
call <SID>X('Error',        'ee0000', '141414', 'bold')
call <SID>X('Todo',         'ee0000', '141414', 'bold')
call <SID>X('Constant',     'cf4726', '',       'none')
call <SID>X('Exception',    'cf593c', '',       'none')
call <SID>X('Operator',     'dfcc77', '',       'none')
call <SID>X('Special',      'e58602', '',       'none') " Parentheses
call <SID>X('SpecialChar',  'fd9502', '',       'none')
call <SID>X('String',       '77a837', '',       'italic')
call <SID>X('Character',    'ffce43', '',       'none')
call <SID>X('Number',       'a03305', '',       'none')
call <SID>X('Statement',    '99591e', '',       'bold') " 6D3E2A
call <SID>X('Keyword',      'b55a05', '',       'bold')
call <SID>X('Label',        '342c24', '',       'bold')
call <SID>X('Identifier',   '816358', '',       'none')
call <SID>X('Type',         'c7ca87', '',       'none')
call <SID>X('Function',     'c7ca87', '',       'none')
call <SID>X('StorageClass', 'c7ca87', '',       'none')
call <SID>X('PreProc',      '6d3e2a', '',       'none')

" delete functions {{{
delf <SID>X
delf <SID>rgb
delf <SID>color
delf <SID>rgb_color
delf <SID>rgb_level
delf <SID>rgb_number
delf <SID>grey_color
delf <SID>grey_level
delf <SID>grey_number
" }}}

" vim: set fdm=marker:
