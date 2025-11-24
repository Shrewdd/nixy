{
  description = "Modular NixOS configuration (I suppose)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    spotify.url = "github:Gerg-L/spicetify-nix";
    anytype.url = "github:squalus/anytype-flake";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, vscode-server, ... }@inputs:
    let
      system = "x86_64-linux";
      
      # Special args to pass to all modules
      specialArgs = {
        inherit inputs;
      };
    in {
      # ===================================
      # NixOS Configurations
      # ===================================
      
      nixosConfigurations = {
        # monsoon
        monsoon = nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
          modules = [
            ./hosts/monsoon/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                extraSpecialArgs = specialArgs;
              };
            }
          ];
        };

        # nomad
        nomad = nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
          modules = [
            ./hosts/nomad/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                extraSpecialArgs = specialArgs;
              };
            }
          ];
        };

        # aurora
        aurora = nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
          modules = [
            ./hosts/aurora/configuration.nix
            home-manager.nixosModules.home-manager
            vscode-server.nixosModules.default
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                extraSpecialArgs = specialArgs;
              };
            }
          ];
        };
      };
    };
}
