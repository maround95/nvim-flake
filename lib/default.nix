{ inputs }:
let
  inherit (inputs.nixCats) utils;
  lib = inputs.nixpkgs.lib;

  categoryDefinitions = import ../nix/category-definitions.nix;
  presets = import ../nix/presets.nix { inherit lib; };
  buildOverlay = import ../nix/build-overlay.nix { inherit inputs; };

  reservedArgs = [
    "system"
    "categories"
    "settings"
    "extra"
    "lua"
    "overrideSpec"
  ];

  mkLuaPath =
    pkgs: lua:
    pkgs.runCommand "nvim-config" { } (
      ''
        mkdir -p "$out"
        cp -r ${lua.configDir}/. "$out/"
        chmod -R u+w "$out"
      ''
      + lib.concatStrings (
        lib.mapAttrsToList (target: src: ''
          mkdir -p "$out/lua/${lua.namespace}"
          cp -r ${src} "$out/lua/${lua.namespace}/${target}"
        '') (lua.shared or { })
      )
    );

  mkPackage =
    presetName:
    args@{
      system ? null,
      categories ? { },
      settings ? { },
      extra ? { },
      lua ? { },
      overrideSpec ? (_: spec: spec),
      ...
    }:
    let
      # TODO: Each package instantiates its own (same) instance - good for public API, not good for standalone
      buildPkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [ buildOverlay ];
      };

      preset = presets.${presetName};
      baseSpec = preset.spec { pkgs = buildPkgs; };
      mergedSpec = lib.recursiveUpdate baseSpec {
        categories = (builtins.removeAttrs args reservedArgs) // categories;
        inherit settings extra;
      };
      spec = overrideSpec args mergedSpec;
    in
    assert system != null;
    utils.baseBuilder (mkLuaPath buildPkgs (preset.lua // lua)) {
      pkgs = buildPkgs;
      nixCats_passthru = preset.passthru spec;
    } categoryDefinitions { ${presetName} = _: spec; } presetName;
in
{
  mkMvim = mkPackage "mvim";
  mkMvimNightly = mkPackage "mvim-nightly";
  mkMvimScrollback = mkPackage "mvim-scrollback";
}
