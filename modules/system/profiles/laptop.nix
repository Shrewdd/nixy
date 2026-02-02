{lib, ...}: {
  imports = [
    ../../shared/stylix/stylix.nix
    ./workstation.nix
  ];

  nixy.stylix.enable = lib.mkDefault true;
}
