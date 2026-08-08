{
  lib,
  pkgs,
  ...
}: {
  # ── File manager ──────────────────────────────────────────────────
  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-archive-plugin # needs an archive manager (file-roller below)
      thunar-volman # auto-mount USB drives etc.
    ];
  };

  # xfconf persists Thunar's own settings (view mode, sidebar, etc.)
  # even though you're not running Xfce as the desktop.
  programs.xfconf.enable = true;

  # ── File services ────────────────────────────────────────────────
  services.gvfs.enable = lib.mkDefault true;
  services.udisks2.enable = lib.mkDefault true;
  services.tumbler.enable = true; # thumbnail generation for images/videos

  environment.systemPackages = [
    pkgs.file-roller
  ];
}
