{}: {
  # ── monsoon ───────────────────────────────────────────────────────
  # Main Hyprland desktop.
  monsoon = {
    system = "x86_64-linux";
    useHomeManager = true;
    useStylix = true;
    modules = [./monsoon/configuration.nix];
  };

  # ── nomad ─────────────────────────────────────────────────────────
  # Laptop KDE profile.
  nomad = {
    system = "x86_64-linux";
    useHomeManager = true;
    useStylix = true;
    modules = [./nomad/configuration.nix];
  };
}
