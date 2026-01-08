{
  description = "Modular NixOS configuration (I suppose)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    spotify.url = "github:Gerg-L/spicetify-nix";
    anytype.url = "github:squalus/anytype-flake";
    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, stylix, ... }@inputs:
    let
      lib = nixpkgs.lib;
      specialArgs = { inherit inputs; };
      hosts = import ./hosts/default.nix { inherit inputs; };
      mkHost = _: attrs:
        let
          system = attrs.system or "x86_64-linux";
          hostModules = attrs.modules or [ ];
        in
        lib.nixosSystem {
          inherit system;
          specialArgs = specialArgs;
          modules = hostModules ++ [
            stylix.nixosModules.stylix
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
    in {
      nixosConfigurations = lib.mapAttrs mkHost hosts;
    };
}
