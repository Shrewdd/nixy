{ pkgs, lib, inputs, ... }:

# Forward all arguments to the upstream zen-browser module so this file is a
# valid home-manager module that simply re-exports the upstream module.
inputs.zen-browser.homeModules.beta
