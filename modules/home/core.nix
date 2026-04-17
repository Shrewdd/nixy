{lib, ...}: {
  # ── Home imports ──────────────────────────────────────────────────
  imports = [
    ./shell.nix
    ./git.nix
  ];

  # ── Home Manager ──────────────────────────────────────────────────
  programs.home-manager.enable = true;

  # ── User defaults ─────────────────────────────────────────────────
  home = {
    username = lib.mkDefault "km";
    homeDirectory = lib.mkDefault "/home/km";
  };
}
