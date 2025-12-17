{ lib, ... }:
{
  programs.git = {
    enable = true;
    userName = lib.mkDefault "qkbp";
    userEmail = lib.mkDefault "qkbpp@protonmail.com";
  };
}
