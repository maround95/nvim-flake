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
        # the builder function that makes it all work
        nixCatsBuilder =
          luaPath: nixCats_passthru:
          utils.baseBuilder luaPath {
            inherit
              nixpkgs
              system
              dependencyOverlays
              extra_pkg_config
              nixCats_passthru
              ;
          } categoryDefinitions packageDefinitions;
        pkgs = import nixpkgs { inherit system; };
      in
      rec {
        # these outputs will be wrapped with ${system} by utils.eachSystem

        # this will make a package out of each of the packageDefinitions defined above
        # and set the default package to the one passed in here.
        packages = rec {
          default = mvim;

          # TODO: single source of truth for tmux-support
          mvim = nixCatsBuilder "${./mvim}" { tmux-support = true; } "mvim";
          mvim-nightly = nixCatsBuilder "${./mvim}" { tmux-support = true; } "mvim-nightly";
          mvim-scrollback = nixCatsBuilder "${./scrollback}" { tmux-support = true; } "mvim-scrollback";
        };

        devShells = {
          default = pkgs.mkShell {
            name = "mvim-devshell";
            packages = [ ] // packages;
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
