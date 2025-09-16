{ pkgs, lib, inputs, ... }:
let
  spicePkgs = inputs.spotify.legacyPackages.${pkgs.stdenv.system};
in
{
  imports = [ inputs.spotify.homeManagerModules.spicetify ];

  programs.spicetify = {
    enable = false;

    # Catppuccin theme with Macchiato colors
    theme = spicePkgs.themes.catppuccin;
    colorScheme = "macchiato";

    enabledExtensions = with spicePkgs.extensions; [
      adblockify
      fullAppDisplay
      shuffle
      copyToClipboard
      powerBar
    ];
  };
}