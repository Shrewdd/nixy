{lib, ...}: {
  imports = [
    ./shell.nix
    ./git.nix
  ];

  programs.home-manager.enable = true;

  home = {
    username = lib.mkDefault "km";
    homeDirectory = lib.mkDefault "/home/km";
  };
}
