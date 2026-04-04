{
  description = "Maroun's Neovim flake";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";

    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";

    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    neovim-nightly-scrollback.url = "github:nix-community/neovim-nightly-overlay/fbd64d42f0fa18898a17a8fa1cef638433dbfc48";

    plugins-vim-tpipeline-zellij = {
      url = "github:maround95/vim-tpipeline-zellij/zellij";
      flake = false;
    };

    plugins-nvim-cokeline = {
      url = "github:maround95/nvim-cokeline";
      flake = false;
    };

    # bacon-ls = {
    #   url = "github:crisidev/bacon-ls";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    let
      flakeModule = import ./flake-module.nix;
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];
      imports = [ flakeModule ];

      flake.flakeModules.default = flakeModule;
    };
}
