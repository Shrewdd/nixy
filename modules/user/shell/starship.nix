{
  lib,
  config,
  ...
}: {
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;

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
}
