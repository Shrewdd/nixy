{pkgs, ...}: {
  # ── Audio stack ───────────────────────────────────────────────────
  # PipeWire provides the server, with ALSA/Pulse/JACK compatibility.
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # ── Scheduling & compatibility ────────────────────────────────────
  # Disable legacy PulseAudio daemon to avoid conflicts with PipeWire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  # ── Tools ─────────────────────────────────────────────────────────
  environment.systemPackages = with pkgs; [pavucontrol];
}
