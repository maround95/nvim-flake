# see :help nixCats.flake.outputs.categories
# and
# :help nixCats.flake.outputs.categoryDefinitions.scheme
{ pkgs, ... }:
{
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
      emmylua-ls
      stylua
      ## nix
      nixd
      nixfmt-rfc-style
      deadnix
      statix
      ## python
      basedpyright
      ruff
      ## c/c++/cuda + cmake
      clang-tools
      neocmakelsp
      cmake-lint
      cmake-format
      ## docker
      hadolint
      dockerfile-language-server
      docker-compose-language-service
      ## haskell
      fourmolu
      hlint
      haskell-language-server
      haskellPackages.cabal-fmt
      ## json & yaml
      vscode-langservers-extracted # for jsonls
      yaml-language-server
      ## bash
      bash-language-server
      shfmt
      shellcheck
      shellharden
      ## terraform
      tflint
      opentofu
      terraform-ls
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
      ## helm
      helm-ls
      ## latex
      texlab
      ## ltex
      ltex-ls
      ## markdown
      marksman
      markdownlint-cli2
      ## rust
      rust-analyzer
      rustfmt
      clippy
      lldb
      nixCatsBuilds.bacon-ls
      ## typst
      tinymist
      typstyle
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
      diffview-nvim
      # core/editor
      trouble-nvim
      fzf-lua
      mini-ai
      todo-comments-nvim
      which-key-nvim
      neo-tree-nvim
      flash-nvim
      yazi-nvim
      gitsigns-nvim
      undotree
      # core/languages
      lazydev-nvim
      clangd_extensions-nvim
      cmake-tools-nvim
      luasnip
      haskell-snippets-nvim
      haskell-tools-nvim
      # core/protocols
      nvim-lspconfig
      (nvim-treesitter.withPlugins (
        plugins: with plugins; [
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
        ]
      ))
      nvim-treesitter-textobjects
      nvim-ts-autotag
      nvim-treesitter-context
      (none-ls-nvim.overrideAttrs { name = "null-ls"; })
      # core/ui
      pkgs.neovimPlugins.nvim-cokeline
      smartcolumn-nvim
      mini-icons
      nui-nvim
      noice-nvim
      lualine-nvim
      persistence-nvim
      transparent-nvim
      one-small-step-for-vimkind
      pkgs.neovimPlugins.vim-tpipeline-zellij

      # colorschemes
      nightfox-nvim
      tokyonight-nvim
    ];

    extra = [
      nvim-nio
      nvim-treesitter.withAllGrammars
      # extra/debug
      nvim-dap
      nvim-dap-ui
      nvim-dap-view
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

      helm-ls-nvim
      venv-selector-nvim
    ];

    tmux = [
    ];
    zellij = [
      zellij-nav-nvim
    ];
  };

  # not loaded automatically at startup.
  # use with packadd and an autocommand in config to achieve lazy loading
  # NOTE: startupPlugins or optionalPlugins distinction is irrelevant for lazy.nvim
  optionalPlugins = { };

  # shared libraries to be added to LD_LIBRARY_PATH
  # variable available to nvim runtime
  sharedLibraries = {
    general = [ ];
  };

  # environmentVariables:
  # this section is for environmentVariables that should be available
  # at RUN TIME for plugins. Will be available to path within neovim terminal
  environmentVariables = {
    # test = {
    #   CATTESTVAR = "It worked!";
    # };
  };

  # If you know what these are, you can provide custom ones by category here.
  # If you dont, check this link out:
  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/setup-hooks/make-wrapper.sh
  extraWrapperArgs = {
    # test = [ ''--set CATTESTVAR2 "It worked again!"'' ];
  };

  # lists of the functions you would have passed to
  # python.withPackages or lua.withPackages

  # get the path to this python environment
  # in your lua config via
  # vim.g.python3_host_prog
  # or run from nvim terminal via :!<packagename>-python3
  python3.libraries = {
    test = [ (_: [ ]) ];
  };
  # populates $LUA_PATH and $LUA_CPATH
  extraLuaPackages = {
    test = [ (_: [ ]) ];
  };
}
