{ pkgs, ... }:
{
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
      yazi
      chafa
      lua-language-server
      emmylua-ls
      stylua
      nixd
      nixfmt
      deadnix
      statix
      basedpyright
      ruff
      clang-tools
      neocmakelsp
      cmake-lint
      cmake-format
      hadolint
      dockerfile-language-server
      docker-compose-language-service
      fourmolu
      hlint
      haskell-language-server
      haskellPackages.cabal-fmt
      vscode-langservers-extracted
      yaml-language-server
      bash-language-server
      shfmt
      shellcheck
      shellharden
      tflint
      opentofu
      terraform-ls
    ];

    extra = [
      lldb
      delve
      gotools
      gopls
      gofumpt
      gomodifytags
      impl
      helm-ls
      texlab
      ltex-ls
      marksman
      markdownlint-cli2
      rust-analyzer
      rustfmt
      clippy
      lldb
      # bacon-ls
      tinymist
      typstyle
      vtsls
      prettier
      eslint
      taplo
    ];
  };

  startupPlugins = with pkgs.vimPlugins; {
    general = [
      lazy-nvim
      snacks-nvim
      plenary-nvim
      ts-comments-nvim
      blink-cmp
      colorful-menu-nvim
      nvim-autopairs
      tabout-nvim
      rainbow-delimiters-nvim
      diffview-nvim
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
      harpoon2
      lazydev-nvim
      clangd_extensions-nvim
      cmake-tools-nvim
      luasnip
      haskell-snippets-nvim
      haskell-tools-nvim
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
          json # this now includes jsonc parsing - nvim-treesitter d2350758
          json5
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
      nightfox-nvim
      tokyonight-nvim
    ];

    extra = [
      nvim-nio
      nvim-treesitter.withAllGrammars
      nvim-dap
      nvim-dap-ui
      nvim-dap-view
      nvim-dap-virtual-text
      nvim-highlight-colors
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

    tmux = [ ];
    # zellij = [ zellij-nav-nvim ];
  };

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

  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/setup-hooks/make-wrapper.sh
  extraWrapperArgs = {
    # test = [ ''--set CATTESTVAR2 "It worked again!"'' ];
  };

  extraPython3Packages = { };
  extraLuaPackages = { };
}
