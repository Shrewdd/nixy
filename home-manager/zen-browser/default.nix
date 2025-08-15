{ pkgs, lib, inputs, ... }:

# Make this a proper home-manager module by importing the upstream zen-browser
# module. This ensures the file evaluates as a module when included from
# `home.nix`.
{
	imports = [ inputs.zen-browser.homeModules.beta ];
}
