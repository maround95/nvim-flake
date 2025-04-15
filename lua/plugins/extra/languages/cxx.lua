local command = vim.fn.exepath("lldb-dap")
if command == "" then
	vim.notify("LLDB is not installed, please install it to use the C/C++ debugger", vim.log.levels.ERROR)
	return {}
end

return {
	{
		"mfussenegger/nvim-dap",
		optional = true,
		-- dependencies = {
		--   -- Ensure C/C++ debugger is installed
		--   "williamboman/mason.nvim",
		--   optional = true,
		--   opts = { ensure_installed = { "lldb" } },
		-- },
		opts = function()
			local dap = require("dap")
			if not dap.adapters["lldb"] then
				require("dap").adapters["lldb"] = {
					type = "executable",
					command = command,
				}
			end
			for _, lang in ipairs({ "c", "cpp" }) do
				dap.configurations[lang] = {
					{
						type = "lldb",
						request = "launch",
						name = "Launch file",
						program = function()
							return vim.fn.input(
								"Path to executable (compiled with -gdwarf-4): ",
								vim.fn.getcwd() .. "/",
								"file"
							)
						end,
						cwd = "${workspaceFolder}",
						runInTerminal = true,
					},
					{
						type = "lldb",
						request = "attach",
						name = "Attach to process",
						pid = require("dap.utils").pick_process,
						cwd = "${workspaceFolder}",
					},

					-- -- FIXME Keep this for future reference for remote attaching, use per-project exrc instead?
					-- -- If you get an "Operation not permitted" error using this, try disabling YAMA:
					-- --  echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
					-- {
					--   name = "Attach to process",
					--   type = 'gdb', -- Adjust this to match your adapter name (`dap.adapters.<name>`)
					--   request = 'attach',
					--   target = 'ares:12345',
					--   -- pid = require('dap.utils').pick_process,
					--   args = {},
					-- },
					-- {
					-- 	name = "lldb-dap: remote attach (ares)",
					-- 	type = "lldb-dap", -- Adjust this to match your adapter name (`dap.adapters.<name>`)
					-- 	request = "attach",
					-- 	program = "/home/maroun/git/Hyprland/main/build/Hyprland",
					-- 	-- attachCommands = {
					-- 	--   "gdb-remote ares:1234",
					-- 	-- },
					-- 	gdb_remote_port = 1234,
					-- 	gdb_remote_hostname = "ares",
					-- },
					-- {
					-- 	name = "codelldb: remote attach (ares)",
					-- 	type = "codelldb", -- Adjust this to match your adapter name (`dap.adapters.<name>`)
					-- 	request = "launch",
					-- 	custom = true,
					-- 	processCreateCommands = {},
					-- 	initCommands = {
					-- 		"platform select remote-linux",
					-- 		"platform connect connect://ares:1234",
					-- 		"settings set target.inherit-env false",
					-- 		"platform process attach --name Hyprland",
					-- 	},
					-- 	args = {},
					-- },
				}
			end
		end,
	},
}
