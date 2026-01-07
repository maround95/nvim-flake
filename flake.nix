{
  description = "Maroun's Neovim flake";

  inputs = {
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

    bacon-ls = {
      url = "github:crisidev/bacon-ls";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # see :help nixCats.flake.outputs
  outputs =
    {
      self,
      nixpkgs,
      nixCats,
      ...
    }@inputs:
    let
      inherit (nixCats) utils;
      forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;
      lib = nixpkgs.lib;

      extra_pkg_config = {
        # allowUnfree = true;
      };

      dependencyOverlays = (import ./overlays inputs) ++ [
        (utils.standardPluginOverlay inputs)
        # add any other flake overlays here.
      ];

      categoryDefinitions = import ./categoryDefinitions.nix;

      # see :help nixCats.flake.outputs.packageDefinitions
      packageDefinitions = rec {
        mvim =
          { pkgs, ... }:
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

              zellijVimBridge = "${pkgs.nixCatsBuilds.zellijVimBridge}/bin/zellij-vim-bridge";

              colorscheme = "nightfox";
            };
            extra = { };
          };

        mvim-nightly =
          { pkgs, ... }@args:
          lib.recursiveUpdate (mvim args) {
            settings = {
              configDirName = "mvim-nightly";
              neovim-unwrapped = pkgs.nixCatsBuilds.neovim-nightly-unwrapped;
            };
          };

        mvim-scrollback =
          { pkgs, ... }:
          {
            categories = {
              tmux = true;
            };
            settings = {
              suffix-path = true;
              suffix-LD = true;
              wrapRc = true;
              configDirName = "mvim-scrollback";
              neovim-unwrapped = pkgs.nixCatsBuilds.neovim-scrollback-unwrapped;
            };
          };
      };

    in
    forEachSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };

        nixCatsBuilder =
          luaPath: packageName:
          let
            packageDef = packageDefinitions.${packageName};
            evaluated = packageDef { inherit pkgs; };
            tmux-support = evaluated.categories.tmux or false;
          in
          utils.baseBuilder luaPath {
            inherit
              nixpkgs
              system
              dependencyOverlays
              extra_pkg_config
              ;
            nixCats_passthru = {
              inherit tmux-support;
            };
          } categoryDefinitions packageDefinitions packageName;
      in
      rec {
        packages =
          let
            mkLuaPath =
              configDir:
              pkgs.runCommand "nvim-config" { } ''
                mkdir -p "$out"

                cp -r ${configDir}/. "$out/"

                chmod -R u+w "$out"

                mkdir -p "$out/lua/mvim"
                cp -r ${./utils} "$out/lua/mvim/utils"
              '';

            mkPackage = name: luaPath: nixCatsBuilder luaPath name;

            configs = {
              mvim = (mkLuaPath ./mvim);
              mvim-nightly = (mkLuaPath ./mvim);
              mvim-scrollback = (mkLuaPath ./scrollback);
            };

            built = lib.mapAttrs mkPackage configs;
          in
          built
          // {
            default = built.mvim;
          };

        devShells = {
          default = pkgs.mkShell {
            name = "mvim-devshell";
            packages = [ ] ++ packages;
            inputsFrom = [ ];
            shellHook = "";
          };
        };
      }
    )
    // (
      let
        mkOverlay =
          {
            namespace ? null,
          }:
          final: prev:
          let
            system = final.stdenv.hostPlatform.system;
            selfPkgs = self.packages.${system};

            exported = {
              inherit (selfPkgs)
                mvim
                mvim-nightly
                mvim-scrollback
                ;
            };
          in
          if namespace == null then exported else { ${namespace} = exported; };

      in
      {
        overlays = {
          default = mkOverlay { };
          namespaced = namespace: mkOverlay { inherit namespace; };
        };
      }
    );
}
