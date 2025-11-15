{ config, lib, pkgs, ... }:

{
  options.hm.shell.starship = {
    enable = lib.mkEnableOption "Starship prompt";
  };

  config = lib.mkIf config.hm.shell.starship.enable {
    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      
      settings = {
        add_newline = true;
        
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[➜](bold red)";
        };
        
        directory = {
          truncation_length = 3;
          truncate_to_repo = true;
        };
      };
    };
  };
}
