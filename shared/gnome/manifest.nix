{ pkgs, lib, ... }:

# ===================================
# GNOME SHARED MANIFEST
# ===================================
#
# Data-only manifest for GNOME hosts. Hosts import and merge these values.
# - `packages`: items to add to `environment.systemPackages`
# - `gnomeExclusions`: `environment.gnome.excludePackages`
# - `programs`: small `programs.*` option sets (merge with host options)
# - `services`: small `services.*` option sets
#
{
	packages = with pkgs; [
    vscode
    gnomeExtensions.appindicator
	];

	gnomeExclusions = with pkgs; [
	epiphany
	geary
    gnome-music
    gnome-terminal
	gnome-tour
	];

	programs = {
	localsend = { enable = true; openFirewall = true; };
    vscode = { enable = true; };
	};

	services = {
	flatpak = { enable = true; };
	udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

	};
}
