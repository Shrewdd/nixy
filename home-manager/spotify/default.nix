{ pkgs, lib, inputs, ... }:
let
  spicePkgs = inputs.spotify.legacyPackages.${pkgs.stdenv.system};
in
{
  imports = [ inputs.spotify.homeManagerModules.spicetify ];

  programs.spicetify = {
    enable = true;

    # Everforest theme
    theme = spicePkgs.themes.text;
    colorScheme = "EverforestDarkMedium";

    enabledExtensions = with spicePkgs.extensions; [
      adblockify
      fullAppDisplay
      shuffle
      powerBar
    ];
  };
}