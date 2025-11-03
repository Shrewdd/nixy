{ pkgs, lib, ... }:
{
  programs.zsh = {
    enable = true;
    # Basic zsh config
    initExtra = ''
      # Add any custom zsh init here
    '';
  };

  programs.bash = {
    enable = true;
    # Ensure Bash execs Zsh in interactive shells
    initExtra = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "zsh" \
            && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.zsh}/bin/zsh $LOGIN_OPTION
      fi
    '';
  };
}
