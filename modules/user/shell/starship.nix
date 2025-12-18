{ lib, ... }:
{
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
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
        vimcmd_symbol = "[❮](bold green)";
      };

      username = {
        format = "[$user]($style) ";
        show_always = false;
        style_user = "bold blue";
        style_root = "bold red";
      };

      hostname = {
        format = "in [$hostname]($style) ";
        ssh_only = true;
        style = "bold purple";
      };

      directory = {
        format = "in [$path]($style)[$read_only]($read_only_style) ";
        style = "bold cyan";
        truncation_length = 3;
        truncate_to_repo = true;
        read_only = " 󰌾";
        read_only_style = "red";
      };

      git_branch = {
        format = "on [$symbol$branch]($style) ";
        symbol = " ";
        style = "bold purple";
      };

      git_status = {
        format = "([\\[$all_status$ahead_behind\\]]($style) )";
        style = "bold red";
        conflicted = "=";
        ahead = lib.concatStrings [ "⇡$" "{count}" ];
        behind = lib.concatStrings [ "⇣$" "{count}" ];
        diverged = lib.concatStrings [ "⇕⇡$" "{ahead_count}⇣$" "{behind_count}" ];
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
        style = "bold green";
      };

      python = {
        symbol = "󰌠 ";
        format = "[$symbol$version]($style) ";
        style = "bold yellow";
      };

      rust = {
        symbol = "󱘗 ";
        format = "[$symbol$version]($style) ";
        style = "bold red";
      };

      golang = {
        symbol = "󰟓 ";
        format = "[$symbol$version]($style) ";
        style = "bold cyan";
      };

      nix_shell = {
        format = "via [$symbol$state]($style) ";
        symbol = " ";
        style = "bold blue";
        impure_msg = "";
        pure_msg = "pure";
      };

      cmd_duration = {
        format = "took [$duration]($style) ";
        min_time = 2000;
        style = "bold yellow";
      };
    };
  };
}
