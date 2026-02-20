{lib, ...}: {
  imports = [
    ../shell/zsh.nix
    ../shell/starship.nix
    ../shell/btop.nix
    ../shell/fastfetch.nix
    ../dev/git.nix
  ];

  programs.home-manager.enable = true;

  home = {
    username = lib.mkDefault "km";
    homeDirectory = lib.mkDefault "/home/km";
  };
}
