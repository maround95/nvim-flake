{ self }:
final: _prev:
let
  packages = self.packages.${final.stdenv.hostPlatform.system};
in
{
  inherit (packages)
    mvim
    mvim-nightly
    mvim-scrollback
    ;
}
