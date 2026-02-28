# ── Server – headless base ──────────────────────────────────────────────
#
# Minimal profile for headless machines.  No desktop, no Home Manager —
# just the core NixOS foundation.
#
{...}: {
  imports = [
    ../nixos/core.nix
  ];
}
