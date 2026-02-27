{lib, ...}: {
  imports = [
    ../../stylix/theme-profiles.nix
    ./workstation.nix
  ];

  nixy.stylix.enable = lib.mkDefault true;
}
