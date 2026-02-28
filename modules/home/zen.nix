{inputs, ...}: {
  imports = [inputs.zen-browser.homeModules.twilight];

  programs.zen-browser = {
    enable = true;
    policies = {
      OfferToSaveLogins = false;
      PasswordManagerEnabled = false;
      DisableFirefoxStudies = true;
      NoDefaultBookmarks = true;
    };

    profiles.default = {
      id = 0;
      settings = {
        "browser.startup.page" = 3;
      };
    };
  };

  stylix.targets.zen-browser.profileNames = ["default"];
}
