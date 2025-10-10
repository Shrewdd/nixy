{ config, pkgs, ... }:
{
  #######################
  # AUDIO (PIPEWIRE + COMPAT)
  #######################
  security.rtkit.enable = true;
  services.pulseaudio.enable = false;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # jack.enable = false; # Enable if needed
  };
}
