local M = {}

local isNixCats = vim.g[ [[nixCats-special-rtp-entry-nixCats]] ] ~= nil

-- NOTE: You might want to move the lazy-lock.json file
local function get_lockfile_path()
	if isNixCats and type(nixCats.settings.unwrappedCfgPath) == "string" then
		return nixCats.settings.unwrappedCfgPath .. "/lazy-lock.json"
	else
		return vim.fn.stdpath("config") .. "/lazy-lock.json"
	end
end

---Downloads lazy if necessary and adds it to the rtp
---@return string lazy_path Path where lazy resides
function M.download_lazy()
	local function regularLazyDownload()
		local path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
		if not vim.uv.fs_stat(path) then
			vim.fn.system({
				"git",
				"clone",
				"--filter=blob:none",
				"https://github.com/folke/lazy.nvim.git",
				"--branch=stable", -- latest stable release
				path,
			})
		end
		return path
	end

	local lazy_path

	if not isNixCats then
		-- No nixCats? Not nix. Do it normally
		lazy_path = regularLazyDownload()
		vim.opt.rtp:prepend(lazy_path)
	else
		-- Nix, lazy already in rtp
		lazy_path = nixCats.pawsible({ "allPlugins", "start", "lazy.nvim" })
		-- we probably dont have to download lazy either
		if lazy_path == nil then
			lazy_path = regularLazyDownload()
		end
	end

	return lazy_path
end

---lazy.nvim wrapper
---@overload fun(lazy_path: string, lazySpec: any, opts: table)
---@overload fun(lazy_path: string, opts: table)
function M.setup(lazy_path, lazySpec, opts)
	local lazySpecs = nil
	local lazyCFG = nil
	if opts == nil and type(lazySpec) == "table" and lazySpec.spec then
		lazyCFG = lazySpec
	else
		lazySpecs = lazySpec
		lazyCFG = opts
	end

	if isNixCats then
		local oldPath
		local lazypatterns
		local fallback
		if type(lazyCFG) == "table" and type(lazyCFG.dev) == "table" then
			lazypatterns = lazyCFG.dev.patterns
			fallback = lazyCFG.dev.fallback
			oldPath = lazyCFG.dev.path
		end

		local myNeovimPackages = nixCats.vimPackDir .. "/pack/myNeovimPackages"

		local newLazyOpts = {
			lockfile = get_lockfile_path(),
			performance = {
				rtp = {
					reset = false,
				},
			},
			dev = {
				path = function(plugin)
					local path = nil
					if type(oldPath) == "string" and vim.fn.isdirectory(oldPath .. "/" .. plugin.name) == 1 then
						path = oldPath .. "/" .. plugin.name
					elseif type(oldPath) == "function" then
						path = oldPath(plugin)
						if type(path) ~= "string" then
							path = nil
						end
					end
					if path == nil then
						if vim.fn.isdirectory(myNeovimPackages .. "/start/" .. plugin.name) == 1 then
							path = myNeovimPackages .. "/start/" .. plugin.name
						elseif vim.fn.isdirectory(myNeovimPackages .. "/opt/" .. plugin.name) == 1 then
							path = myNeovimPackages .. "/opt/" .. plugin.name
						else
							path = "~/projects/" .. plugin.name
						end
					end
					return path
				end,
				patterns = lazypatterns or { "" },
				fallback = fallback == nil and true or fallback,
			},
		}
		lazyCFG = vim.tbl_deep_extend("force", lazyCFG or {}, newLazyOpts)
		-- do the reset we disabled without removing important stuff
		local cfgdir = nixCats.configDir
		vim.opt.rtp = {
			cfgdir,
			nixCats.nixCatsPath,
			nixCats.pawsible.allPlugins.ts_grammar_path,
			vim.fn.stdpath("data") .. "/site",
			lazy_path,
			vim.env.VIMRUNTIME,
			vim.fn.fnamemodify(vim.v.progpath, ":p:h:h") .. "/lib/nvim",
			cfgdir .. "/after",
		}
	end

	if lazySpecs then
		require("lazy").setup(lazySpecs, lazyCFG)
	else
		require("lazy").setup(lazyCFG)
	end
end

return M
