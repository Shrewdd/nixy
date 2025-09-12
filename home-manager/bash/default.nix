{ pkgs, ... }:

{
  programs.bash = {
    enable = true;
    enableCompletion = true;
  };

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };
}
