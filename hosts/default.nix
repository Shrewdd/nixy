{}: {
  # ── monsoon ───────────────────────────────────────────────────────
  monsoon = {
    system = "x86_64-linux";
    useHomeManager = true;
    useStylix = true;
    modules = [./monsoon/configuration.nix];
  };

  # ── nomad ─────────────────────────────────────────────────────────
  nomad = {
    system = "x86_64-linux";
    useHomeManager = true;
    useStylix = true;
    modules = [./nomad/configuration.nix];
  };
}
