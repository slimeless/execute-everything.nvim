local real = require("executeme.real_stuff")
local popup = require("plenary.popup")
local utils = require("executeme.utils")
Executeme_bufh = nil
Executeme_win_id = nil

local function close_window()
	local lines = vim.api.nvim_buf_get_lines(Executeme_bufh, 0, -1, false)
	utils.clean_empty_lines(lines)
	vim.api.nvim_win_close(Executeme_win_id, true)
	vim.notify(vim.inspect(lines))
	local err, out = real.replace_cmd({ path = vim.fn.getcwd(), cmd_list = lines })
	if err == false then
		vim.notify("Error: " .. out, vim.log.levels.ERROR)
	end
end

local function run_command()
	local current_line = vim.api.nvim_get_current_line()
	vim.notify(vim.inspect(current_line))
	if current_line == "" then
		return
	end
	vim.api.nvim_win_close(Executeme_win_id, true)
	vim.cmd("vsplit | terminal " .. current_line)
end

local function create_window()
	local width = 60
	local height = 10
	local bufnr = vim.api.nvim_create_buf(false, false)
	local win_id, win = popup.create(bufnr, {
		title = "Executeme",
		highlight = "HarpoonWindow",
		line = math.floor(((vim.o.lines - height) / 2) - 1),
		col = math.floor((vim.o.columns - width) / 2),
		minwidth = width,
		minheight = height,
		borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
	})
	return {
		bufnr = bufnr,
		winid = win_id,
		win = win,
	}
end

local ui = {}

---@class UiOpts
---@field lines string[]

---@param opts UiOpts
function ui.create(opts)
	local window_data = create_window()
	Executeme_bufh = window_data.bufnr
	Executeme_win_id = window_data.winid
	local win = window_data.win
	-- TODO: change deprecated functions
	vim.api.nvim_win_set_option(win.border.win_id, "winhl", "Normal:HarpoonBorder")
	vim.api.nvim_buf_set_lines(Executeme_bufh, 0, -1, false, opts.lines)
	vim.api.nvim_win_set_option(Executeme_win_id, "number", true)
	vim.api.nvim_buf_set_name(Executeme_bufh, "Executeme")
	vim.api.nvim_buf_set_option(Executeme_bufh, "filetype", "Executeme")
	vim.api.nvim_buf_set_option(Executeme_bufh, "buftype", "acwrite")
	vim.api.nvim_buf_set_option(Executeme_bufh, "bufhidden", "delete")
	vim.keymap.set("n", "q", function()
		close_window()
	end, { buffer = Executeme_bufh, silent = true })
	vim.keymap.set("n", "<CR>", function()
		run_command()
	end, { buffer = Executeme_bufh, silent = true })
end

return ui
