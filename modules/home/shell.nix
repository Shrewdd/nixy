{
  pkgs,
  lib,
  config,
  ...
}: {
  # ── Zsh ────────────────────────────────────────────────────────────
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

  # ── Starship ───────────────────────────────────────────────────────
  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      format = lib.concatStrings [
        "$username"
        "$hostname"
        "$directory"
        "$git_branch"
        "$git_status"
        "$nodejs"
        "$python"
        "$rust"
        "$golang"
        "$nix_shell"
        "$line_break"
        "$character"
      ];

      add_newline = true;

      character = {
        success_symbol = "[❯](bold ${config.stylix.base16Scheme.base0B})";
        error_symbol = "[❯](bold ${config.stylix.base16Scheme.base08})";
        vimcmd_symbol = "[❮](bold ${config.stylix.base16Scheme.base0B})";
      };

      username = {
        format = "[$user]($style) ";
        show_always = false;
        style_user = "bold ${config.stylix.base16Scheme.base0D}";
        style_root = "bold ${config.stylix.base16Scheme.base08}";
      };

      hostname = {
        format = "in [$hostname]($style) ";
        ssh_only = true;
        style = "bold ${config.stylix.base16Scheme.base0E}";
      };

      directory = {
        format = "in [$path]($style)[$read_only]($read_only_style) ";
        style = "bold ${config.stylix.base16Scheme.base0C}";
        truncation_length = 3;
        truncate_to_repo = true;
        read_only = " 󰌾";
        read_only_style = "${config.stylix.base16Scheme.base08}";
      };

      git_branch = {
        format = "on [$symbol$branch]($style) ";
        symbol = " ";
        style = "bold ${config.stylix.base16Scheme.base0E}";
      };

      git_status = {
        format = "([\\[$all_status$ahead_behind\\]]($style) )";
        style = "bold ${config.stylix.base16Scheme.base08}";
        conflicted = "=";
        ahead = lib.concatStrings ["⇡$" "{count}"];
        behind = lib.concatStrings ["⇣$" "{count}"];
        diverged = lib.concatStrings ["⇕⇡$" "{ahead_count}⇣$" "{behind_count}"];
        untracked = "?";
        stashed = "$";
        modified = "!";
        staged = "+";
        renamed = "»";
        deleted = "✘";
      };

      nodejs = {
        symbol = "󰎙 ";
        format = "[$symbol$version]($style) ";
        style = "bold ${config.stylix.base16Scheme.base0B}";
      };

      python = {
        symbol = "󰌠 ";
        format = "[$symbol$version]($style) ";
        style = "bold ${config.stylix.base16Scheme.base0A}";
      };

      rust = {
        symbol = "󱘗 ";
        format = "[$symbol$version]($style) ";
        style = "bold ${config.stylix.base16Scheme.base08}";
      };

      golang = {
        symbol = "󰟓 ";
        format = "[$symbol$version]($style) ";
        style = "bold ${config.stylix.base16Scheme.base0C}";
      };

      nix_shell = {
        format = "via [$symbol$state]($style) ";
        symbol = " ";
        style = "bold ${config.stylix.base16Scheme.base0D}";
        impure_msg = "";
        pure_msg = "pure";
      };

      cmd_duration = {
        format = "took [$duration]($style) ";
        min_time = 2000;
        style = "bold ${config.stylix.base16Scheme.base0A}";
      };
    };
  };

  # ── Btop ───────────────────────────────────────────────────────────
  programs.btop = {
    enable = true;
    settings = {
      color_theme = lib.mkDefault "Default";
      theme_background = false;
    };
  };

  # ── Fastfetch ──────────────────────────────────────────────────────
  programs.fastfetch = {
    enable = true;
    settings = {
      display = {
        separator = " : ";
      };
      modules = [
        {
          type = "custom";
          format = "┌──────────────────────────────────────────────────┐";
        }
        {
          type = "os";
          key = "  󰣇 OS";
          format = "{2}";
          keyColor = "red";
        }
        {
          type = "kernel";
          key = "  󰌽 Kernel";
          format = "{2}";
          keyColor = "red";
        }
        {
          type = "packages";
          key = "  󰏗 Packages";
          keyColor = "green";
        }
        {
          type = "display";
          key = "  󰍹 Display";
          format = "{1}x{2} @ {3}Hz [{7}]";
          keyColor = "green";
        }
        {
          type = "terminal";
          key = "  󰞳 Terminal";
          keyColor = "yellow";
        }
        {
          type = "wm";
          key = "  󱗃 WM";
          format = "{2}";
          keyColor = "yellow";
        }
        {
          type = "custom";
          format = "└──────────────────────────────────────────────────┘";
        }
        "break"
        {
          type = "title";
          key = "  ";
          format = "{6} {7} {8}";
        }
        {
          type = "custom";
          format = "┌──────────────────────────────────────────────────┐";
        }
        {
          type = "cpu";
          format = "{1} @ {7}";
          key = "  󰍛 CPU";
          keyColor = "blue";
        }
        {
          type = "gpu";
          format = "{1} {2}";
          key = "  󰊴 GPU";
          keyColor = "blue";
        }
        {
          type = "memory";
          key = "  󰍛 Memory";
          keyColor = "magenta";
        }
        {
          type = "disk";
          key = "  󱦟 OS Age";
          folders = "/";
          keyColor = "red";
          format = "{days} days";
        }
        {
          type = "uptime";
          key = "  󱫐 Uptime";
          keyColor = "red";
        }
        {
          type = "custom";
          format = "└──────────────────────────────────────────────────┘";
        }
        {
          type = "colors";
          paddingLeft = 2;
          symbol = "circle";
        }
        "break"
      ];
    };
  };
}
