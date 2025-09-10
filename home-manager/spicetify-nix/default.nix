{ pkgs, lib, inputs, ... }:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
  theme = import ../../themes/catppuccin-macchiato.nix;
in
{
  imports = [ inputs.spicetify-nix.homeManagerModules.spicetify ];

  programs.spicetify = {
    enable = true;

    # Catppuccin theme with Macchiato colors
    theme = spicePkgs.themes.catppuccin;
    colorScheme = "macchiato";

    enabledExtensions = with spicePkgs.extensions; [
      adblockify
      fullAppDisplay
      shuffle
      copyToClipboard
      powerBar
      volumePercentage
    ];
  };
}