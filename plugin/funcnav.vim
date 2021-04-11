nnoremap <C-p> :call FindFunc() <CR>

function! s:GetMaxLen(matches)
	let l:max = 0
	for m in a:matches
		if len(m) > l:max
			let l:max = strlen(m)
		endif
	endfor
	return l:max
endfunction

function! FuncWindowMoveDown()
	let l:num = nvim_win_get_cursor(s:winId)
		if l:num[0] < s:winHeight
			call nvim_buf_clear_namespace(s:bufh, -1, l:num[0]-1, l:num[0]+1)
			let l:num[0] = l:num[0] + 1
			call nvim_buf_add_highlight(s:bufh, -1, "QuickFixLine", l:num[0]-1, 0, -1)
		endif
	call nvim_win_set_cursor(s:winId, l:num)
endfunction

function! FuncWindowMoveUp()
	let l:num = nvim_win_get_cursor(s:winId)
		if l:num[0] > 1
			call nvim_buf_clear_namespace(s:bufh, -1, l:num[0]-1, l:num[0]+1)
			let l:num[0] = l:num[0]  - 1
			call nvim_buf_add_highlight(s:bufh, -1, "QuickFixLine", l:num[0]-1, 0, -1)
		endif
	call nvim_win_set_cursor(s:winId, l:num)
endfunction

function! GotoLine()
	let l:line = getline(".")
	let l:lineNum = matchstr(l:line, "\\d\\+")

	let l:num = nvim_win_get_cursor(s:sourceWindow)
	call nvim_buf_clear_namespace(s:sourceBuffer, -1, 0, -1)

	call nvim_win_set_cursor(s:sourceWindow, [str2nr(l:lineNum), 0])
	call nvim_buf_add_highlight(s:sourceBuffer, -1, "QuickFixLine", str2nr(l:lineNum)-1, 0, -1)
endfunction

function! FindFunc()
	let s:name = "FunctionExplorer"
	let l:indentNum = 4

	let s:bufn = bufnr(s:name)
	"let s:win = win_findbuf(s:bufn)

	if s:bufn > 0 "If buffer already exists close it
		call nvim_buf_delete(s:bufn, {})
	else

		let s:sourceWindow = win_getid()

		let s:sourceBuffer = nvim_win_get_buf(s:sourceWindow)
		let s:bufData = nvim_buf_get_lines(s:sourceBuffer, 0, -1, 0)

		let s:matches = {}
		let l:pattern = "\^\\s*def .*"

		let l:displayData = []

		let l:lineNum = 1
		for b in s:bufData

			let l:match = matchstr(b, l:pattern)

			if len(l:match)
				let s:matches[b] = l:lineNum	
				let l:indent = ""
				for i in range(l:indentNum - len(l:lineNum))
					let l:indent = l:indent . " "
				endfor
				call add(l:displayData, l:lineNum . l:indent . matchstr(b, "\\S.*"))
			endif

			let l:lineNum += 1
		endfor
"
		"let s:matches = execute("g/" . l:pattern)
		"let s:matches = split(s:matches, "\n")

		let l:height = nvim_win_get_height(0)
		let l:width = nvim_win_get_width(0)


		if len(s:matches) > 1
			let s:bufh = nvim_create_buf(0, 1)
			call nvim_buf_set_name(s:bufh, s:name)
			call nvim_buf_set_lines(s:bufh, 0, len(s:matches), 0, l:displayData)
			call nvim_buf_add_highlight(s:bufh, -1, "QuickFixLine", 0, 0, -1)
			let l:winWidth = s:GetMaxLen(keys(s:matches)) + l:indentNum + 4
			let s:winHeight = len(s:matches)

			let s:winId = nvim_open_win(s:bufh, 1, {"relative":"win", "width":l:winWidth, "height":s:winHeight, "row":0, "col":l:width, "anchor":"NE"})

			let l:command = ':call GotoLine()<cr>'
			call nvim_buf_set_keymap(s:bufh, 'n', '<cr>', l:command, {})
			call nvim_buf_set_keymap(s:bufh, 'n', 'j', ":call FuncWindowMoveDown()<cr>", {})
			call nvim_buf_set_keymap(s:bufh, 'n', 'k', ":call FuncWindowMoveUp()<cr>", {})
		else
			echo "No Python functions found"
		endif
	endif


endfunction


