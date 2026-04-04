{ inputs }:
final: prev:
let
  system = prev.stdenv.hostPlatform.system;
in
{
  # zellijVimBridge = prev.writeShellScriptBin "zellij-vim-bridge" ''
  #   BRIDGE=/tmp/vim-tpipeline/''${ZELLIJ_SESSION_NAME}
  #   while inotifywait -e modify "$BRIDGE"; do
  #     zellij pipe "zjstatus::pipe::pipe_mvim::$(cat "$BRIDGE"/vimbridge)"
  #   done
  # '';

  # bacon-ls = inputs.bacon-ls.defaultPackage.${system};

  neovim-nightly-unwrapped = inputs.neovim-nightly.packages.${system}.default;

  neovim-scrollback-unwrapped =
    inputs.neovim-nightly-scrollback.packages.${system}.default.overrideAttrs
      (old: {
        patches = (old.patches or [ ]) ++ [
          ../patches/gk_gj_sms.patch
          ../patches/no_sms_markers.patch
        ];
      });
}
// (inputs.nixCats.utils.standardPluginOverlay inputs) final prev
