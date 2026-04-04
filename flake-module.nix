# flake-module.nix
{ inputs, self, ... }:
let
  lib = import ./lib/default.nix { inherit inputs; };
in
{
  flake = {
    inherit lib;
    overlays.default = import ./overlays/default.nix { inherit self; };
  };

  perSystem = { system, pkgs, ... }:
    let
      packages = {
        mvim = lib.mkMvim { inherit system; };
        mvim-nightly = lib.mkMvimNightly { inherit system; };
        mvim-scrollback = lib.mkMvimScrollback { inherit system; };
      };
    in
    {
      packages = packages // { default = packages.mvim; };

      devShells.default = pkgs.mkShell {
        name = "mvim-devshell";
        packages = builtins.attrValues packages;
      };
    };
}
