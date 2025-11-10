local M = {}

local LazyUtil = require("lazy.core.util")

-- Make this a transparent wrapper around lazy utils.
-- Useful functions include try() and error().
setmetatable(M, {
	__index = function(t, k)
		if LazyUtil[k] then
			return LazyUtil[k]
		end
		---@diagnostic disable-next-line: no-unknown
		t[k] = require("utils." .. k)
		return t[k]
	end,
})

---@param fn fun()
function M.on_very_lazy(fn)
	vim.api.nvim_create_autocmd("User", {
		pattern = "VeryLazy",
		callback = function()
			fn()
		end,
	})
end

local _defaults = {} ---@type table<string, boolean>

-- Determines whether it's safe to set an option to a default value.
--
-- It will only set the option if:
-- * it is the same as the global value
-- * it's current value is a default value
-- * it was last set by a script in $VIMRUNTIME
---@param option string
---@param value string|number|boolean
---@return boolean was_set
function M.set_default(option, value)
	local l = vim.api.nvim_get_option_value(option, { scope = "local" })
	local g = vim.api.nvim_get_option_value(option, { scope = "global" })

	_defaults[("%s=%s"):format(option, value)] = true
	local key = ("%s=%s"):format(option, l)

	if l ~= g and not _defaults[key] then
		-- Option does not match global and is not a default value
		-- Check if it was set by a script in $VIMRUNTIME
		local info = vim.api.nvim_get_option_info2(option, { scope = "local" })
		---@param e vim.fn.getscriptinfo.ret
		local scriptinfo = vim.tbl_filter(function(e)
			return e.sid == info.last_set_sid
		end, vim.fn.getscriptinfo())
		local by_rtp = #scriptinfo == 1 and vim.startswith(scriptinfo[1].name, vim.fn.expand("$VIMRUNTIME"))
		if not by_rtp then
			return false
		end
	end

	vim.api.nvim_set_option_value(option, value, { scope = "local" })
	return true
end

M.norm = function(path)
	if path:sub(1, 1) == "~" then
		local home = vim.uv.os_homedir()
		if home:sub(-1) == "\\" or home:sub(-1) == "/" then
			home = home:sub(1, -2)
		end
		path = home .. path:sub(2)
	end
	path = path:gsub("\\", "/"):gsub("/+", "/")
	return path:sub(-1) == "/" and path:sub(1, -2) or path
end

M.dedup = function(list)
	local ret = {}
	local seen = {}
	for _, v in ipairs(list) do
		if not seen[v] then
			table.insert(ret, v)
			seen[v] = true
		end
	end
	return ret
end

return M
