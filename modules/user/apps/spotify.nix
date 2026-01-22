{ lib, pkgs, inputs, ... }:

let
  spicePkgs = inputs.spotify.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  imports = [ inputs.spotify.homeManagerModules.default ];

  programs.spicetify = {
    enable = true;
    enabledExtensions = with spicePkgs.extensions; [
      adblockify
      fullAppDisplay
      shuffle
      powerBar
    ];
  };
}
