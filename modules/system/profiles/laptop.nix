{lib, ...}: {
  imports = [
    ../../shared/stylix/stylix.nix
    ../../shared/stylix/theme-profiles.nix
    ./workstation.nix
  ];

  nixy.stylix.enable = lib.mkDefault true;
}
