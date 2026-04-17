{inputs, ...}: {
  imports = [inputs.zen-browser.homeModules.twilight];

  # ── Browser config ────────────────────────────────────────────────
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

  # ── Stylix integration ────────────────────────────────────────────
  stylix.targets.zen-browser.profileNames = ["default"];
}
