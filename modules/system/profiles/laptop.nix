{lib, ...}: {
  imports = [
    ../../shared/stylix.nix
    ./workstation.nix
  ];

  nixy.stylix.enable = lib.mkDefault true;
}
