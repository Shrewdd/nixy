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
}
