local json = require("executeme.json_stuff")
local real = {}

---@class AddProfileOpts
---@field path string
---@field cmd string
---@param opts AddProfileOpts
function real.add_profile(opts)
	if opts.cmd == nil then
		return false, "cmd is nil"
	end
	if opts.path == nil then
		return false, "path is nil"
	end
	local json_base = json.read({})
	local profiles = vim.json.decode(json_base)
	local profile_cmds = profiles[opts.path]
	if profile_cmds == nil then
		profile_cmds = {}
	end
	local profile = {}
	profile[opts.path] = vim.list_extend(profile_cmds, { opts.cmd })
	local merged = vim.tbl_deep_extend("force", profiles, profile)
	local encoded = vim.json.encode(merged)
	vim.notify("profile:" .. vim.inspect(profile))
	vim.notify("merged:" .. vim.inspect(merged))

	local err, json_out = json.write({ content = encoded })
	if err then
		return false, json_out
	end
	return true
end

---@class DeleteIndexedCmdOpts
---@field path string
---@field index number
---@param opts DeleteIndexedCmdOpts
function real.delete_cmd(opts)
	if opts.index == nil then
		return false, "cmd is nil"
	end
	if opts.path == nil then
		return false, "path is nil"
	end
	local json_base = json.read({})
	local profiles = vim.json.decode(json_base)
	local profile_cmds = profiles[opts.path]
	if profile_cmds == nil then
		return true
	end
	if vim.fn.len(profile_cmds) < opts.index then
		return true
	end
	for i, v in ipairs(profile_cmds) do
		if v == opts.index then
			table.remove(profile_cmds, i)
			break
		end
	end
	profiles[opts.path] = profile_cmds
	vim.notify("profile:" .. vim.inspect(profiles))
	local encoded = vim.json.encode(profiles)
	local err, json_out = json.write({ content = encoded })
	if err then
		return false, json_out
	end
end

---@class ReplaceCmdOpts
---@field path string
---@field cmd_list string[]
---@param opts ReplaceCmdOpts
function real.replace_cmd(opts)
	if opts.cmd_list == nil then
		return false, "cmd_list is nil"
	end
	if opts.path == nil then
		return false, "path is nil"
	end
	local json_base = json.read({})
	local profiles = vim.json.decode(json_base)
	profiles[opts.path] = opts.cmd_list
	local encoded = vim.json.encode(profiles)
	local err, json_out = json.write({ content = encoded })
	if err then
		return false, json_out
	end
	return true
end

---@class GetCmdsOpts
---@field path string
---@param opts GetCmdsOpts
function real.get_cmds(opts)
	if opts.path == nil then
		return false, "path is nil"
	end
	local json_base = json.read({})
	local profiles = vim.json.decode(json_base)
	local profile_cmds = profiles[opts.path]
	if profile_cmds == nil then
		return true, {}
	end
	return true, profile_cmds
end

return real
