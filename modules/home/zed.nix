{
  pkgs,
  osConfig,
  ...
}: {
  programs.zed-editor = {
    enable = true;
    defaultEditor = true;
    extensions = ["nix" "material-icon-theme" "nvim-nightfox"];
    extraPackages = with pkgs; [
      nixd
      alejandra
    ];
    userSettings = {
      lsp = {
        nixd = {
          settings = {
            options = {
              "home-manager" = {
                expr = "(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.${osConfig.networking.hostName}.options.home-manager.users.type.getSubOptions []";
              };
            };
          };
        };
      };
      languages = {
        Nix = {
          language_servers = ["nixd"];
          formatter.external = {
            command = "alejandra";
          };
          format_on_save = "on";
        };
      };
    };
  };
}
