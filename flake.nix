{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    niri.url = "github:sodiboo/niri-flake";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    spotify.url = "github:Gerg-L/spicetify-nix";
    anytype.url = "github:squalus/anytype-flake";
  };

  outputs = { self, nixpkgs, home-manager, niri, spotify, anytype, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      # Defines NixOS configurations for different hosts
      nixosConfigurations.monsoon = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/monsoon/configuration.nix
          niri.nixosModules.niri
          home-manager.nixosModules.home-manager
          {
            home-manager.extraSpecialArgs = { inputs = self.inputs; };
            home-manager.users.km = {
              imports = [ ./hosts/monsoon/modules/home-manager.nix ];
            };
          }
        ];
      };
      nixosConfigurations.nomad = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/nomad/configuration.nix
        ];
      };
    };
}
