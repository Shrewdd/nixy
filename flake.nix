{
  description = "Modular NixOS configuration (I suppose)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    spotify.url = "github:Gerg-L/spicetify-nix";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    caelestia-shell = {
      url = "github:caelestia-dots/shell";
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

  outputs = {
    nixpkgs,
    home-manager,
    stylix,
    ...
  } @ inputs: let
    lib = nixpkgs.lib;
    specialArgs = {inherit inputs;};
    hosts = import ./hosts/default.nix {};
    mkHost = _: attrs: let
      system = attrs.system or "x86_64-linux";
      hostModules = attrs.modules or [];
      useHomeManager = attrs.useHomeManager or true;
      useStylix = attrs.useStylix or true;
      optionalModules =
        (lib.optionals useStylix [stylix.nixosModules.stylix])
        ++ (lib.optionals useHomeManager [
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              overwriteBackup = true;
              extraSpecialArgs = specialArgs;
            };
          }
        ]);
    in
      lib.nixosSystem {
        inherit system;
        specialArgs = specialArgs;
        modules = hostModules ++ optionalModules;
      };
  in {
    nixosConfigurations = lib.mapAttrs mkHost hosts;
  };
}
