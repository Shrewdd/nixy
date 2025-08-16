{ pkgs, lib, inputs, ... }:
{
  imports = [ inputs.spicetify-nix.homeModules.default ];

  programs.spicetify = {
    enable = true;
    extensions = [ "no-ads" ];
  };
}
