{ lib, pkgs, inputs, ... }:

let
  spicePkgs = inputs.spotify.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  imports = [ inputs.spotify.homeManagerModules.default ];

  programs.spicetify = {
    enable = true;
    theme = lib.mkDefault spicePkgs.themes.catppuccin;
    colorScheme = lib.mkDefault "mocha";
    enabledExtensions = with spicePkgs.extensions; [
      adblockify
      fullAppDisplay
      shuffle
      powerBar
    ];
  };
}
