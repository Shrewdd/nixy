{ lib, ... }:

let
  defaultPalette = import ../../shared/theme/catppuccin-latte-base16.nix;
  palette = config.stylix.base16Scheme or config.nixy.stylix.base16Scheme or defaultPalette;
  hex = name: let
    raw = if lib.hasAttr name palette && palette.${name} != null then palette.${name}
          else if lib.hasAttr name defaultPalette && defaultPalette.${name} != null then defaultPalette.${name}
          else "000000";
  in
    "#" + raw;
  stylixTheme = lib.concatStringsSep "\n" [
    ":root {"
    "  --background-primary: ${hex "base00"};"
    "  --background-secondary: ${hex "base01"};"
    "  --background-tertiary: ${hex "base02"};"
    "  --background-floating: ${hex "base03"};"
    "  --text-normal: ${hex "base05"};"
    "  --text-muted: ${hex "base04"};"
    "  --text-link: ${hex "base0D"};"
    "  --interactive-normal: ${hex "base0D"};"
    "  --interactive-muted: ${hex "base09"};"
    "  --brand-experiment: ${hex "base0D"};"
    "  --accent: ${hex "base0A"};"
    "}"
  ];
in
{
  programs.vesktop = {
    enable = true;
    settings = {
      appBadge = lib.mkDefault false;
      checkUpdates = lib.mkDefault false;
      customTitleBar = lib.mkDefault false;
      disableMinSize = lib.mkDefault true;
      minimizeToTray = lib.mkDefault false;
      staticTitle = lib.mkDefault true;
      splashBackground = lib.mkDefault (hex "base00");
      splashColor = lib.mkDefault (hex "base05");
      splashTheming = lib.mkDefault true;
      tray = lib.mkDefault false;
    };
    vencord = {
      settings = {
        useQuickCss = lib.mkDefault true;
        enabledThemes = lib.mkDefault [ "stylix.css" ];
      };
      themes = {
        "stylix.css" = lib.mkDefault stylixTheme;
      };
    };
  };
}
