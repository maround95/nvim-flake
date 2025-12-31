return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          keys = {
            { "<leader>ch", "<cmd>LspClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
          },
          root_markers = {
            "compile_commands.json",
            "compile_flags.txt",
            "configure.ac", -- AutoTools
            "Makefile",
            "configure.ac",
            "configure.in",
            "config.h.in",
            "meson.build",
            "meson_options.txt",
            "build.ninja",
            ".git",
          },
          capabilities = {
            offsetEncoding = { "utf-16" },
          },
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--fallback-style=llvm",
          },
          init_options = {
            usePlaceholders = true,
            completeUnimported = true,
            clangdFileStatus = true,
          },
        },
      },
      setup = {
        clangd = function(_, opts)
          local clangd_ext_opts = Utils.plugin.opts("clangd_extensions.nvim")
          require("clangd_extensions").setup(
            vim.tbl_deep_extend("force", clangd_ext_opts or {}, { server = opts })
          )
          return false
        end,
      },
    },
  },
  {
    "p00f/clangd_extensions.nvim",
    lazy = true,
    config = function() end,
    opts = {
      inlay_hints = {
        inline = false,
      },
      ast = {
        --These require codicons (https://github.com/microsoft/vscode-codicons)
        role_icons = {
          type = "",
          declaration = "",
          expression = "",
          specifier = "",
          statement = "",
          ["template argument"] = "",
        },
        kind_icons = {
          Compound = "",
          Recovery = "",
          TranslationUnit = "",
          PackExpansion = "",
          TemplateTypeParm = "",
          TemplateTemplateParm = "",
          TemplateParamObject = "",
        },
      },
    },
  },
  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      -- Ensure C/C++ debugger is installed
      "mason-org/mason.nvim",
      optional = true,
      opts = { ensure_installed = { "codelldb" } },
    },
    opts = function()
      local dap = require("dap")
      if not dap.adapters["codelldb"] then
        require("dap").adapters["codelldb"] = {
          type = "executable",
          command = "codelldb",
        }
      end

      dap.adapters.gdb = {
        type = "executable",
        command = "gdb",
        args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
      }

      for _, lang in ipairs({ "c", "cpp" }) do
        dap.configurations[lang] = {
          {
            name = "Select and attach to process",
            type = "gdb",
            request = "attach",
            program = function()
              return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end,
            pid = function()
              local name = vim.fn.input('Executable name (filter): ')
              return require("dap.utils").pick_process({ filter = name })
            end,
            cwd = '${workspaceFolder}'
          },
        }
      end

      -- local dap = require("dap")
      -- if not dap.adapters["codelldb"] then
      -- 	require("dap").adapters["codelldb"] = {
      -- 		type = "server",
      -- 		host = "localhost",
      -- 		port = "${port}",
      -- 		executable = {
      -- 			command = "codelldb",
      -- 			args = {
      -- 				"--port",
      -- 				"${port}",
      -- 			},
      -- 		},
      -- 	}
      -- end
      -- for _, lang in ipairs({ "c", "cpp" }) do
      -- 	dap.configurations[lang] = {
      -- 		{
      -- 			type = "codelldb",
      -- 			request = "launch",
      -- 			name = "Launch file",
      -- 			program = function()
      -- 				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
      -- 			end,
      -- 			cwd = "${workspaceFolder}",
      -- 		},
      -- 		{
      -- 			type = "codelldb",
      -- 			request = "attach",
      -- 			name = "Attach to process",
      -- 			pid = require("dap.utils").pick_process,
      -- 			cwd = "${workspaceFolder}",
      -- 		},
      -- 	}
      -- end

      -- -- FIXME: Keep this for future reference for remote attaching, use per-project exrc instead?
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
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "cpp", "cuda" },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    optional = true,
    opts = function(_, opts)
      opts.sorting = opts.sorting or {}
      opts.sorting.comparators = opts.sorting.comparators or {}
      table.insert(opts.sorting.comparators, 1, require("clangd_extensions.cmp_scores"))
    end,
  },
}
