{ config, lib, pkgs, ... }:

{
  options.features.hardware.audio = {
    enable = lib.mkEnableOption "Audio support (PipeWire)";
  };

  config = lib.mkIf config.features.hardware.audio.enable {
    # Enable PipeWire
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    # Disable PulseAudio (PipeWire replaces it)
    services.pulseaudio.enable = false;

    # Enable real-time audio (for low latency)
    security.rtkit.enable = true;

    # Audio control GUI
    environment.systemPackages = with pkgs; [
      pavucontrol
    ];
  };
}
