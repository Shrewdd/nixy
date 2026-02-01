{}: {
  aurora = {
    system = "x86_64-linux";
    useHomeManager = false;
    useStylix = false;
    modules = [./aurora/configuration.nix];
  };

  monsoon = {
    system = "x86_64-linux";
    useHomeManager = true;
    useStylix = true;
    modules = [./monsoon/configuration.nix];
  };

  nomad = {
    system = "x86_64-linux";
    useHomeManager = true;
    useStylix = true;
    modules = [./nomad/configuration.nix];
  };
}
