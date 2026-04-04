{ lib }:
let
  mvimSpec =
    { pkgs }:
    {
      settings = {
        suffix-path = true;
        suffix-LD = true;
        wrapRc = "MVIM_UNWRAP";
        configDirName = "mvim";
      };
      categories = {
        general = true;
        extra = true;
        tmux = true;
        # zellijVimBridge = "${pkgs.zellijVimBridge}/bin/zellij-vim-bridge";
        colorscheme = "nightfox";
      };
      extra = { };
    };
in
{
  mvim = {
    lua = {
      configDir = ../mvim;
      namespace = "mvim";
      shared.utils = ../utils;
    };

    spec = mvimSpec;

    passthru = spec: {
      tmux-support = spec.categories.tmux or false;
    };
  };

  mvim-nightly = {
    lua = {
      configDir = ../mvim;
      namespace = "mvim";
      shared.utils = ../utils;
    };

    spec =
      { pkgs }:
      lib.recursiveUpdate (mvimSpec { inherit pkgs; }) {
        settings = {
          configDirName = "mvim-nightly";
          neovim-unwrapped = pkgs.neovim-nightly-unwrapped;
        };
      };

    passthru = spec: {
      tmux-support = spec.categories.tmux or false;
    };
  };

  mvim-scrollback = {
    lua = {
      configDir = ../scrollback;
      namespace = "mvim";
      shared.utils = ../utils;
    };

    spec =
      { pkgs }:
      {
        categories = {
          tmux = true;
        };
        settings = {
          suffix-path = true;
          suffix-LD = true;
          wrapRc = true;
          configDirName = "mvim-scrollback";
          neovim-unwrapped = pkgs.neovim-scrollback-unwrapped;
        };
        extra = { };
      };

    passthru = spec: {
      tmux-support = spec.categories.tmux or false;
    };
  };
}
