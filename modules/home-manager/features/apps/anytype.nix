{ config, lib, pkgs, inputs, ... }:

{
  options.hm.apps.anytype = {
    enable = lib.mkEnableOption "Anytype note-taking app";
  };

  config = lib.mkIf config.hm.apps.anytype.enable {
    home.packages = [ inputs.anytype.packages.${pkgs.stdenv.hostPlatform.system}.default ];
  };
}
