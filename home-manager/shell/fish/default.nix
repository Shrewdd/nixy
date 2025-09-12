{ pkgs, lib, ... }:
{
  programs.fish = {
    enable = true;
    # High-contrast autosuggestions
    interactiveShellInit = ''
      set -g fish_color_autosuggestion brcyan
    '';
  };

  programs.bash = {
    enable = true;
  # Ensure Bash execs Fish in interactive shells
    initExtra = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" \
            && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };
}
