{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
  };
  
  outputs = { self, nixpkgs, home-manager, ... }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
  in
  {
    nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
      system = system;
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        { home-manager.extraSpecialArgs = { inputs = self.inputs; }; }
        {
          home-manager.users.km = {
            imports = [ ./home-manager/home.nix ];
          };
        }
      ];
    };
  };
}
