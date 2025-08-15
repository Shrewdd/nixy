{ pkgs, lib, inputs, ... }:

# Re-export the zen-browser home-manager module from the `zen-browser` flake input.
# This preserves the original behavior where `home.nix` previously imported
# `inputs.zen-browser.homeModules.beta` directly.

inputs.zen-browser.homeModules.beta
