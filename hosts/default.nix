{ inputs }:
{
  aurora = {
    system = "x86_64-linux";
    modules = [ ./aurora/configuration.nix ];
  };

  monsoon = {
    system = "x86_64-linux";
    modules = [ ./monsoon/configuration.nix ];
  };

  nomad = {
    system = "x86_64-linux";
    modules = [ ./nomad/configuration.nix ];
  };
}
