{ config, lib, pkgs, inputs, ... }:

let
  spicePkgs = inputs.spotify.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  options.hm.apps.spotify = {
    enable = lib.mkEnableOption "Spotify with Spicetify";
  };

  imports = [
    inputs.spotify.homeManagerModules.default
  ];
  
  config = lib.mkIf config.hm.apps.spotify.enable {
    programs.spicetify = {
      enable = true;
      theme = spicePkgs.themes.catppuccin;
      colorScheme = "mocha";
      
      # Extensions
      enabledExtensions = with spicePkgs.extensions; [
        adblockify
        fullAppDisplay
        shuffle
        powerBar
      ];
    };
  };
}
