return {
	-- lspconfig
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPost", "BufNewFile", "BufWritePre" },
		opts_extend = { "servers.*.keys" },
		opts = {
			-- Enable this to enable the builtin LSP inlay hints on Neovim.
			-- Be aware that you also will need to properly configure your LSP server to
			-- provide the inlay hints.
			inlay_hints = {
				enabled = true,
				exclude = { "vue" }, -- filetypes for which you don't want to enable inlay hints
			},
			-- Enable this to enable the builtin LSP code lenses on Neovim.
			-- Be aware that you also will need to properly configure your LSP server to
			-- provide the code lenses.
			codelens = {
				enabled = false,
			},
			-- Enable this to enable the builtin LSP folding on Neovim.
			-- Be aware that you also will need to properly configure your LSP server to
			-- provide the folds.
			folds = {
				enabled = true,
			},
			-- options for vim.lsp.buf.format
			-- `bufnr` and `filter` is handled by the LazyVim formatter,
			-- but can be also overridden when specified
			format = {
				formatting_options = nil,
				timeout_ms = nil,
			},
			-- LSP Server Settings
			-- Sets the default configuration for an LSP client (or all clients if the special name "*" is used).
			---@alias vim.lsp.ConfigExt vim.lsp.Config|{mason?:boolean, enabled?:boolean, keys?:LazyKeysLspSpec[]}
			---@type table<string, vim.lsp.ConfigExt|boolean>
			servers = {
				-- configuration for all lsp servers
				["*"] = {
					capabilities = {
						workspace = {
							fileOperations = {
								didRename = true,
								willRename = true,
							},
						},
					},
            -- stylua: ignore
            keys = {
              { "gd", vim.lsp.buf.definition, desc = "Goto Definition", has = "definition" },
              { "gr", vim.lsp.buf.references, desc = "References", nowait = true },
              { "gI", vim.lsp.buf.implementation, desc = "Goto Implementation" },
              { "gy", vim.lsp.buf.type_definition, desc = "Goto T[y]pe Definition" },
              { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
              { "K", function() return vim.lsp.buf.hover() end, desc = "Hover" },
              { "gK", function() return vim.lsp.buf.signature_help() end, desc = "Signature Help", has = "signatureHelp" },
              { "<c-k>", function() return vim.lsp.buf.signature_help() end, mode = "i", desc = "Signature Help", has = "signatureHelp" },
              { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "x" }, has = "codeAction" },
              { "<leader>cc", vim.lsp.codelens.run, desc = "Run Codelens", mode = { "n", "x" }, has = "codeLens" },
              { "<leader>cC", vim.lsp.codelens.refresh, desc = "Refresh & Display Codelens", mode = { "n" }, has = "codeLens" },
              { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File", mode ={"n"}, has = { "workspace/didRenameFiles", "workspace/willRenameFiles" } },
              { "<leader>cr", vim.lsp.buf.rename, desc = "Rename", has = "rename" },
              { "]]", function() Snacks.words.jump(vim.v.count1) end, has = "documentHighlight",
                desc = "Next Reference", enabled = function() return Snacks.words.is_enabled() end },
              { "[[", function() Snacks.words.jump(-vim.v.count1) end, has = "documentHighlight",
                desc = "Prev Reference", enabled = function() return Snacks.words.is_enabled() end },
              { "<a-n>", function() Snacks.words.jump(vim.v.count1, true) end, has = "documentHighlight",
                desc = "Next Reference", enabled = function() return Snacks.words.is_enabled() end },
              { "<a-p>", function() Snacks.words.jump(-vim.v.count1, true) end, has = "documentHighlight",
                desc = "Prev Reference", enabled = function() return Snacks.words.is_enabled() end },
            },
				},
				-- lua_ls = {
				-- enabled = true,
				-- mason = false, -- set to false if you don't want this server to be installed with mason
				-- Use this to add any additional keymaps
				-- for specific lsp servers
				-- ---@type LazyKeysSpec[]
				-- keys = {},
				-- settings = {},
				-- },
			},
			-- you can do any additional lsp server setup here
			-- return true if you don't want this server to be setup with lspconfig
			---@type table<string, fun(server:string, opts: vim.lsp.Config):boolean?>
			setup = {
				-- example to setup with typescript.nvim
				-- tsserver = function(_, opts)
				--   require("typescript").setup({ server = opts })
				--   return true
				-- end,
				-- Specify * to use this function as a fallback for any server
				-- ["*"] = function(server, opts) end,
			},
		},
		---@param opts PluginLspOpts
		config = vim.schedule_wrap(function(_, opts)
			-- setup keymaps
			for server, server_opts in pairs(opts.servers) do
				if type(server_opts) == "table" and server_opts.keys then
					require("mvim.plugins.lsp.utils.keymaps").set(
						{ name = server ~= "*" and server or nil },
						server_opts.keys
					)
				end
			end

			-- inlay hints
			if opts.inlay_hints.enabled then
				Snacks.util.lsp.on({ method = "textDocument/inlayHint" }, function(buffer)
					if
						vim.api.nvim_buf_is_valid(buffer)
						and vim.bo[buffer].buftype == ""
						and not vim.tbl_contains(opts.inlay_hints.exclude, vim.bo[buffer].filetype)
					then
						vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
					end
				end)
			end

			-- folds
			if opts.folds.enabled then
				Snacks.util.lsp.on({ method = "textDocument/foldingRange" }, function()
					if Utils.set_default("foldmethod", "expr") then
						Utils.set_default("foldexpr", "v:lua.vim.lsp.foldexpr()")
					end
				end)
			end

			-- code lens
			if opts.codelens.enabled and vim.lsp.codelens then
				Snacks.util.lsp.on({ method = "textDocument/codeLens" }, function(buffer)
					vim.lsp.codelens.refresh()

					-- TODO: lua_ls scans the entire project every codelens refresh request, very distracting
					vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
						buffer = buffer,
						callback = vim.lsp.codelens.refresh,
					})
				end)
			end

			if opts.servers["*"] then
				vim.lsp.config("*", opts.servers["*"])
			end

			-- TODO: Deal with mason for non-nix
			for server, sopts in pairs(opts.servers) do
				if server == "*" then
					goto continue
				end

				sopts = sopts == true and {} or (not sopts) and { enabled = false } or sopts --[[@as vim.lsp.ConfigExt]]

				if sopts.enabled == false then
					goto continue
				end

				local setup = opts.setup[server] or opts.setup["*"]
				if not (setup and setup(server, sopts)) then
					vim.lsp.config(server, sopts) -- configure the server
					vim.lsp.enable(server)
				end

				::continue::
			end
		end),
	},

	{
		"mason-org/mason.nvim",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			-- enabled = Utils.nixCats.lazyAdd(true, false),
			enabled = false, -- TODO: Re-enable once mason works
			config = function() end,
		},
		-- enabled = Utils.nixCats.lazyAdd(true, false),
		enabled = false, -- TODO: Get Mason working for non-nix
		cmd = "Mason",
		keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
		build = ":MasonUpdate",
		opts_extend = { "ensure_installed" },
		opts = {},
		---@param opts MasonSettings | {ensure_installed: string[]}
		config = function(_, opts)
			require("mason").setup(opts)
			local mr = require("mason-registry")
			mr:on("package:install:success", function()
				vim.defer_fn(function()
					-- trigger FileType event to possibly load this newly installed LSP server
					require("lazy.core.handler.event").trigger({
						event = "FileType",
						buf = vim.api.nvim_get_current_buf(),
					})
				end, 100)
			end)

			mr.refresh(function()
				for _, tool in ipairs(opts.ensure_installed) do
					local p = mr.get_package(tool)
					if not p:is_installed() then
						p:install()
					end
				end
			end)
		end,
	},
	{
		"folke/snacks.nvim",
		opts = {
			words = { enabled = true },
		},
	},
}
