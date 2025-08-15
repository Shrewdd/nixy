{ pkgs, lib, ... }:

# Module for zen-browser related home-manager configuration.
# Pulled out from `home.nix` so it can live in its own folder while being worked on.
{
  programs.zen-browser = {
    enable = true;
    # Add additional zen-browser settings here when needed, e.g.
    # settings = { ... };
  };
}
