{ pkgs, lib, inputs, ... }:
{
	imports = [ inputs.zen-browser.homeModules.twilight ];

	programs.zen-browser = {
		enable = true;
		policies = {
			Preferences = {
				# Warns the user when attempting to close multiple tabs
				"browser.tabs.warnOnClose" = {
					Value = true;
					Status = "locked";
				};
				# Enables custom stylesheets (userChrome.css and userContent.css) for UI customization
				"toolkit.legacyUserProfileCustomizations.stylesheets" = {
					Value = true;
					Status = "locked";
				};
			};
		};
	};
}
