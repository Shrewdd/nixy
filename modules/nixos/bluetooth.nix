{lib, ...}: {
  # ── Bluetooth stack ───────────────────────────────────────────────
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = lib.mkDefault true;
    settings.General = {
      Enable = "Source,Sink,Media,Socket";
      Experimental = true;
    };
  };

  # ── Bluetooth UI ──────────────────────────────────────────────────
  services.blueman.enable = lib.mkDefault true;
}
