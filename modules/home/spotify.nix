{
  pkgs,
  inputs,
  ...
}: let
  # ── Spicetify package set ─────────────────────────────────────────
  spicePkgs = inputs.spotify.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
  imports = [inputs.spotify.homeManagerModules.default];

  # ── Spotify client ────────────────────────────────────────────────
  programs.spicetify = {
    enable = true;
    enabledExtensions = with spicePkgs.extensions; [
      adblockify
      fullAppDisplay
      shuffle
      powerBar
    ];
  };
}
