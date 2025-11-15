{ config, lib, pkgs, inputs, ... }:

let
  spicePkgs = inputs.spotify.legacyPackages.${pkgs.system};
in
{
  options.hm.apps.spotify = {
    enable = lib.mkEnableOption "Spotify with Spicetify";
  };

  config = lib.mkIf config.hm.apps.spotify.enable {
    imports = [ inputs.spotify.homeManagerModules.default ];
    
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
