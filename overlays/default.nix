/*
  This file imports overlays defined in the following format.
  Plugins will still only be downloaded if included in a category.
  You may copy paste this example into a new file and then import that file here.
*/
# Example overlay:
/*
  importName: inputs: let
    overlay = self: super: {
      ${importName} = {
        # define your overlay derivations here
      };
    };
  in
  overlay
*/
inputs:
let
  overlaySet = {
    # this is how you would add another overlay file
    # for if your customBuildsOverlay gets too long
    # the name here will be the name used when importing items from it in your flake.
    # i.e. these items will be accessed as pkgs.nixCatsBuilds.thenameofthepackage
    nixCatsBuilds =
      importName: inputs:
      let
        overlay =
          final: prev:
          let
            system = prev.stdenv.hostPlatform.system;
          in
          {
            ${importName} = {
              zellijVimBridge = prev.writeShellScriptBin "zellij-vim-bridge" ''
                BRIDGE=/tmp/vim-tpipeline/''${ZELLIJ_SESSION_NAME}
                while inotifywait -e modify "$BRIDGE"; do
                  zellij pipe "zjstatus::pipe::pipe_mvim::$(cat "$BRIDGE"/vimbridge)"
                done
              '';
              bacon-ls = inputs.bacon-ls.defaultPackage.${system};

              neovim-nightly-unwrapped = inputs.neovim-nightly.packages.${system}.default;

              neovim-scrollback-unwrapped =
                inputs.neovim-nightly-scrollback.packages.${system}.default.overrideAttrs
                  (old: {
                    patches = (old.patches or [ ]) ++ [
                      ../patches/gk_gj_sms.patch
                      ../patches/no_sms_markers.patch
                    ];
                  });
            };
          };
      in
      overlay;
  };
in
# calls the functions from the overlay files to create the overlays,
# then puts them in a list.
builtins.attrValues (builtins.mapAttrs (name: value: (value name inputs)) overlaySet)
