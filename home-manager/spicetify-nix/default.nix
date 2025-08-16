{ pkgs, lib, inputs, ... }:
{
  imports = [ inputs.spicetify-nix.homeModules.default ];

  programs.spicetify = {
    enable = true;
    extensions = [ "adblockify" ];
    theme = spicePkgs.themes.minimal;
  };
}
