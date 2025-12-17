{ pkgs, inputs, ... }:
{
  home.packages = [ inputs.anytype.packages.${pkgs.stdenv.hostPlatform.system}.default ];
}
