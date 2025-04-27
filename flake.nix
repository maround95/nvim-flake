{
  description = "Maroun's Neovim flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";

    # neovim-nightly-overlay = {
    #   url = "github:nix-community/neovim-nightly-overlay";
    # };
  };

  # see :help nixCats.flake.outputs
  outputs = {
    nixpkgs,
    nixCats,
    ...
  } @ inputs: let
    inherit (nixCats) utils;
    luaPath = "${./.}";
    forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;

    extra_pkg_config = {
      # allowUnfree = true;
    };

    dependencyOverlays =
      (import ./overlays inputs)
      ++ [
        (utils.standardPluginOverlay inputs)
        # add any other flake overlays here.
      ];

    # see :help nixCats.flake.outputs.categories
    # and
    # :help nixCats.flake.outputs.categoryDefinitions.scheme
    categoryDefinitions = {
      pkgs,
      mkNvimPlugin,
      ...
    }: {
      # to define and use a new category, simply add a new list to a set here,
      # and later, you will include categoryname = true; in the set you
      # provide when you build the package using this builder function.
      # see :help nixCats.flake.outputs.packageDefinitions for info on that section.

      # lspsAndRuntimeDeps:
      # this section is for dependencies that should be available
      # at RUN TIME for plugins. Will be available to PATH within neovim terminal
      # this includes LSPs
      lspsAndRuntimeDeps = with pkgs; {
        general = [
          wget
          curl
          fd
          fzf
          lazygit
          ripgrep
          llvmPackages.clangWithLibcAndBasicRtAndLibcxx
          universal-ctags
          # core/editor
          yazi
          chafa # image previewer
          # lsp & other utils
          ## lua
          lua-language-server
          stylua
          ## nix
          nixd
          alejandra
          deadnix
          statix
          ## python
          basedpyright
          ruff
          black
          isort
          ## c/c++/cuda + cmake
          clang-tools
          neocmakelsp
          cmake-format
          ## json & yaml
          vscode-langservers-extracted # for jsonls
          yaml-language-server
          ## bash
          bash-language-server
          shfmt
          shellharden
        ];

        extra = [
          # extra/languages
          ## cxx
          lldb
          ## go
          delve
          gotools
          gopls
          gofumpt
          gomodifytags
          impl
          ## latex
          texlab
          ## ltex
          ltex-ls
          ## markdown
          marksman
          markdownlint-cli2
          ## rust
          rust-analyzer
          clippy
          lldb
          ## typst
          tinymist
          websocat
          ## typescript
          vtsls
          ## frontend
          nodePackages.prettier
          eslint
          ## toml
          taplo
        ];
      };

      # NOTE: lazy doesnt care if these are in startupPlugins or optionalPlugins
      # also you dont have to download everything via nix if you dont want.
      # but you have the option, and that is demonstrated here.
      startupPlugins = with pkgs.vimPlugins; {
        general = [
          lazy-nvim
          snacks-nvim
          plenary-nvim
          # core/coding
          ts-comments-nvim
          blink-cmp
          colorful-menu-nvim
          nvim-autopairs
          tabout-nvim
          rainbow-delimiters-nvim
          # core/editor
          trouble-nvim
          fzf-lua
          todo-comments-nvim
          which-key-nvim
          neo-tree-nvim
          flash-nvim
          yazi-nvim
          gitsigns-nvim
          undotree
          zellij-nav-nvim
          vim-tmux-navigator
          # core/languages
          lazydev-nvim
          clangd_extensions-nvim
          cmake-tools-nvim
          # core/protocols
          nvim-lspconfig
          (nvim-treesitter.withPlugins (plugins:
            with plugins; [
              bash
              c
              cmake
              cpp
              diff
              html
              javascript
              jsdoc
              json
              json5
              jsonc
              latex
              lua
              luadoc
              luap
              markdown
              markdown_inline
              ninja
              nix
              printf
              python
              query
              regex
              rust
              toml
              vim
              vimdoc
              xml
              yaml
            ]))
          nvim-treesitter-textobjects
          nvim-ts-autotag
          nvim-treesitter-context
          (none-ls-nvim.overrideAttrs {name = "null-ls";})
          # core/ui
          bufferline-nvim
          nightfox-nvim
          smartcolumn-nvim
          mini-icons
          nui-nvim
          noice-nvim
          lualine-nvim
          persistence-nvim
          transparent-nvim
        ];

        extra = [
          nvim-nio
          nvim-treesitter.withAllGrammars
          # extra/debug
          nvim-dap
          nvim-dap-ui
          nvim-dap-virtual-text
          # extra/editor
          nvim-highlight-colors
          # extra/languages
          nvim-dap-python
          nvim-dap-go
          markdown-preview-nvim
          render-markdown-nvim
          rustaceanvim
          crates-nvim
          typst-vim
          typst-preview-nvim
          SchemaStore-nvim
        ];
      };

      # not loaded automatically at startup.
      # use with packadd and an autocommand in config to achieve lazy loading
      # NOTE: this template is using lazy.nvim so, which list you put them in is irrelevant.
      # startupPlugins or optionalPlugins, it doesnt matter, lazy.nvim does the loading.
      # I just put them all in startupPlugins. I could have put them all in here instead.
      optionalPlugins = {};

      # shared libraries to be added to LD_LIBRARY_PATH
      # variable available to nvim runtime
      sharedLibraries = {general = [];};

      # environmentVariables:
      # this section is for environmentVariables that should be available
      # at RUN TIME for plugins. Will be available to path within neovim terminal
      environmentVariables = {test = {CATTESTVAR = "It worked!";};};

      # If you know what these are, you can provide custom ones by category here.
      # If you dont, check this link out:
      # https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/setup-hooks/make-wrapper.sh
      extraWrapperArgs = {
        test = [''--set CATTESTVAR2 "It worked again!"''];
      };

      # lists of the functions you would have passed to
      # python.withPackages or lua.withPackages

      # get the path to this python environment
      # in your lua config via
      # vim.g.python3_host_prog
      # or run from nvim terminal via :!<packagename>-python3
      python3.libraries = {test = [(_: [])];};
      # populates $LUA_PATH and $LUA_CPATH
      extraLuaPackages = {test = [(_: [])];};
    };

    # And then build a package with specific categories from above here:
    # All categories you wish to include must be marked true,
    # but false may be omitted.
    # This entire set is also passed to nixCats for querying within the lua.

    # see :help nixCats.flake.outputs.packageDefinitions
    packageDefinitions = rec {
      nvim = {pkgs, ...}: {
        settings = {
          suffix-path = true;
          suffix-LD = true;
          wrapRc = "NVIM_MAROUN_UNWRAP";
          configDirName = "nvim-maroun";

          hosts = {
            python3.enable = false;
            perl.enable = false;
            node.enable = false;
            ruby.enable = false;
          };
        };
        categories = {
          general = true;
          extra = true;
          test = false;

          debugpy_python = with pkgs;
            lib.getExe (pkgs.python3.withPackages (ps: [ps.debugpy]));
          js_debug_server = "${pkgs.vscode-js-debug}/lib/node_modules/js-debug/src/dapDebugServer.js";

          markdown_css = toString ./assets/terminal.css;
          highlight_css = toString ./assets/highlight.css;
        };
        extra = {};
      };
    };
    # In this section, the main thing you will need to do is change the default package name
    # to the name of the packageDefinitions entry you wish to use as the default.
    defaultPackageName = "nvim";
    # see :help nixCats.flake.outputs.exports
  in
    forEachSystem (system: let
      # the builder function that makes it all work
      nixCatsBuilder =
        utils.baseBuilder luaPath {
          inherit nixpkgs system dependencyOverlays extra_pkg_config;
        }
        categoryDefinitions
        packageDefinitions;
      defaultPackage = nixCatsBuilder defaultPackageName;
      pkgs = import nixpkgs {inherit system;};
    in {
      # these outputs will be wrapped with ${system} by utils.eachSystem

      # this will make a package out of each of the packageDefinitions defined above
      # and set the default package to the one passed in here.
      packages = utils.mkAllWithDefault defaultPackage;

      # choose your package for devShell
      # and add whatever else you want in it.
      devShells = {
        default = pkgs.mkShell {
          name = defaultPackageName;
          packages = [defaultPackage];
          inputsFrom = [];
          shellHook = "";
        };
      };
    })
    // (let
      # we also export a nixos module to allow reconfiguration from configuration.nix
      nixosModule = utils.mkNixosModules {
        inherit
          defaultPackageName
          dependencyOverlays
          luaPath
          categoryDefinitions
          packageDefinitions
          extra_pkg_config
          nixpkgs
          ;
      };
      # and the same for home manager
      homeModule = utils.mkHomeModules {
        inherit
          defaultPackageName
          dependencyOverlays
          luaPath
          categoryDefinitions
          packageDefinitions
          extra_pkg_config
          nixpkgs
          ;
      };
    in {
      # these outputs will be NOT wrapped with ${system}

      # this will make an overlay out of each of the packageDefinitions defined above
      # and set the default overlay to the one named here.
      overlays =
        utils.makeOverlays luaPath {
          inherit nixpkgs dependencyOverlays extra_pkg_config;
        }
        categoryDefinitions
        packageDefinitions
        defaultPackageName;

      nixosModules.default = nixosModule;
      homeModules.default = homeModule;

      inherit utils nixosModule homeModule;
      inherit (utils) templates;
    });
}
