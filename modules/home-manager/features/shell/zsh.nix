{ config, lib, pkgs, ... }:

{
  options.hm.shell.zsh = {
    enable = lib.mkEnableOption "Zsh shell with autosuggestions and syntax highlighting";
  };

  config = lib.mkIf config.hm.shell.zsh.enable {
    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      
      shellAliases = {
        ls = "ls --color=auto";
        ll = "ls -lh";
        la = "ls -lah";
        ".." = "cd ..";
        "..." = "cd ../..";
      };

      initContent = ''
        # Add any custom zsh init here
      '';
    };

    # Make Bash exec Zsh in interactive shells
    programs.bash = {
      enable = true;
      initExtra = ''
        if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "zsh" \
              && -z ''${BASH_EXECUTION_STRING} ]]
        then
          shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
          exec ${pkgs.zsh}/bin/zsh $LOGIN_OPTION
        fi
      '';
    };
  };
}
