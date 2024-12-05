local json = {}

---@param opts table
function json.read(opts)
	local path = opts.path or vim.fn.stdpath("data") .. "/executeme.json"
	local file = io.open(path, "r")
	if file == nil then
		return "{}"
	end
	local contents = file:read("*a")
	file:close()
	if contents == "" then
		return "{}"
	end
	return contents
end

---@class Opts
---@field path string?
---@field content string

---@param opts Opts
function json.write(opts)
	local path = opts.path or vim.fn.stdpath("data") .. "/executeme.json"
	local content = opts.content
	if content == nil then
		return false, "content is nil"
	end
	local file = io.open(path, "w")
	if file == nil then
		return false, "could not open file"
	end
	local _, err = file:write(content)
	if err then
		return false, "could not write to file"
	end
	file:close()
end

return json
