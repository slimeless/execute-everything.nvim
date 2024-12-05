local real = require("executeme.real_stuff")
local ui = require("executeme.ui_stuff")
local M = {}

M.setup = function()
	vim.api.nvim_create_user_command("ExecutemeAddCmd", function()
		local opts = {}
		opts.path = vim.fn.getcwd()
		opts.cmd = "echo 'hello'"
		local res, err = real.add_profile(opts)
		if res == false then
			vim.notify("Error: " .. err, vim.log.levels.ERROR)
		end
	end, {})
	vim.api.nvim_create_user_command("ExecutemeDeleteCmd", function()
		local opts = {}
		opts.path = vim.fn.getcwd()
		opts.index = 1
		local res, err = real.delete_cmd(opts)
		if res == false then
			vim.notify("Error: " .. err, vim.log.levels.ERROR)
		end
	end, {})
	vim.api.nvim_create_user_command("ExecutemeReplaceCmd", function()
		local opts = {}
		opts.path = vim.fn.getcwd()
		opts.cmd_list = { "ls", "cd" }
		local res, err = real.replace_cmd(opts)
		if res == false then
			vim.notify("Error: " .. err, vim.log.levels.ERROR)
		end
	end, {})
	vim.api.nvim_create_user_command("Executeme", function()
		local opts = {}
		opts.path = vim.fn.getcwd()
		local err, res = real.get_cmds(opts)
		if err == false then
			vim.notify("Error: " .. res, vim.log.levels.ERROR)
		end
		if type(res) == "table" then
			ui.create({ lines = res })
		end
	end, {})
end

return M
