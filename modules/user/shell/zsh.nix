{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
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
    initExtra = ''
      if command -v fzf >/dev/null 2>&1; then
        export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --preview-window=down:60%'
        export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
        if typeset -f fzf-file-widget >/dev/null; then bindkey '^T' fzf-file-widget; fi
        if typeset -f fzf-history-widget >/dev/null; then bindkey '^R' fzf-history-widget; fi
        if typeset -f fzf-cd-widget >/dev/null; then bindkey '^[c' fzf-cd-widget; fi
      fi
      eval "$(zoxide init zsh)"
    '';
  };

  programs.fzf.enable = true;
  programs.zoxide.enable = true;

  home.packages = with pkgs; [ fd ripgrep ];

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
