{ config, lib, pkgs, inputs, ... }:

{
  options.hm.apps.anytype = {
    enable = lib.mkEnableOption "Anytype note-taking app";
  };

  config = lib.mkIf config.hm.apps.anytype.enable {
    imports = [ inputs.anytype.homeManagerModules.default ];
    
    programs.anytype = {
      enable = true;
    };
  };
}
