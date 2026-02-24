{...}: {
  imports = [
    ./nix.nix
    ./networking.nix
    ./localization.nix
    ./switch-theme-script.nix
  ];

  users.users.km = {
    isNormalUser = true;
    description = "km";
    extraGroups = ["networkmanager" "wheel"];
  };
}
