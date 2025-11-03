{ config, pkgs, ... }:

{
  imports = [
    ./anytype/default.nix
    ./ghostty/default.nix
    ./git/default.nix
    ./rofi/default.nix
    ./shell/btop/default.nix
    ./shell/zsh/default.nix
    ./shell/fastfetch/default.nix
    ./spotify/default.nix
    ./zen-browser/default.nix
  ];
}