local utils = {}
local real = require("executeme.real_stuff")
local default = {
	["py"] = "python %",
	["rs"] = "cargo run",
	["lua"] = "nvim -l",
	["c"] = "clang -o %:p % && ./%:p",
}

---@param t string[]
function utils.clean_empty_lines(t)
	for i = #t, 1, -1 do
		if t[i] == "" then
			table.remove(t, i)
		end
	end
end

---@param project_extension string
---@param default_cmds table
---@param project string
function utils.add_default(project_extension, default_cmds, project)
	if project == nil then
		return false
	end
	local list = real.get_cmds({ path = project })
	if #list == 0 then
		return false
	end
	local cmds = vim.tbl_deep_extend("force", default_cmds, default)
	if cmds[project_extension] == nil then
		return false
	end
	real.add_profile({ path = project, cmd = cmds[project_extension] })
	return true
end

return utils
