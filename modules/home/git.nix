{lib, ...}: {
  # ── Git client ────────────────────────────────────────────────────
  programs.git = {
    enable = true;

    # ── Identity defaults ───────────────────────────────────────────
    settings.user = {
      name = lib.mkDefault "qkbp";
      email = lib.mkDefault "qkbpp@protonmail.com";
    };
  };
}
