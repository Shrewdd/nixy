{ config, pkgs, ... }:

{
  # ===================================
  # AUDIO (PIPEWIRE + COMPAT)
  # ===================================
  security.rtkit.enable = true;
  services.pulseaudio.enable = false;

  # Core PipeWire setup
  services.pipewire = {
    enable = true;             # Master switch for PipeWire
    audio.enable = true;       # Ensure audio graph is enabled
    alsa.enable = true;        # Support ALSA clients via PipeWire
    alsa.support32Bit = true;  # 32-bit ALSA (games / older apps)
    pulse.enable = true;       # PulseAudio compatibility layer for apps
    jack.enable = false;       # Enable if doing pro audio / JACK apps
    wireplumber.enable = true; # Use WirePlumber session manager (default)
  };

}
