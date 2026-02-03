{pkgs, ...}: {
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    autosuggestion.strategy = ["history" "completion"];
    syntaxHighlighting.enable = true;
    history = {
      size = 10000;
      save = 10000;
      share = true;
    };
    shellAliases = {
      ls = "ls --color=auto";
      ll = "ls -lh";
      la = "ls -lah";
      ".." = "cd ..";
      "..." = "cd ../..";
    };
    initContent = ''
      eval "$(zoxide init zsh)"
    '';
  };

  programs.zoxide.enable = true;

  home.packages = with pkgs; [fd zsh-completions];

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
}
