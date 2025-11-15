{ config, lib, pkgs, ... }:

{
  options.hm.dev.git = {
    enable = lib.mkEnableOption "Git version control";
    
    userName = lib.mkOption {
      type = lib.types.str;
      default = "qkbp";
      description = "Git user name";
    };

    userEmail = lib.mkOption {
      type = lib.types.str;
      default = "qkbpp@protonmail.com";
      description = "Git user email";
    };
  };

  config = lib.mkIf config.hm.dev.git.enable {
    programs.git = {
      enable = true;
      userName = config.hm.dev.git.userName;
      userEmail = config.hm.dev.git.userEmail;
    };
  };
}
