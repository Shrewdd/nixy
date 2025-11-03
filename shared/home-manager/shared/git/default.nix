{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    settings.user = {
      name = "qkbp";
      email = "qkbpp@protonmail.com";
    };
  };
}
