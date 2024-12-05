local real = require("executeme.real_stuff")

local cmd = {}

function cmd.run_cmd_by_index(index)
	local opts = {}
	opts.path = vim.fn.getcwd()
	local err, cmds = real.get_cmds(opts)
	if err == false then
		vim.notify("Index is too big: " .. index, vim.log.levels.ERROR)
	end
	local command = cmds[index]
	-- vim.system({ "tmux", "split-window", "-h", "'" .. command .. "'" }, {
	-- 	cwd = vim.fn.getcwd(),
	-- })
	-- vim.fn.jobstart({ "tmux", "split-window", "-h", "'" .. command .. "'" })
	-- vim.cmd("!tmux split-window -h '" .. command .. "; exit'")
	vim.cmd("vsplit | terminal " .. command)
end

return cmd
