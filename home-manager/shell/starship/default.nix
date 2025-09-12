{ config, lib, ... }:

let
  # Import the Catppuccin Macchiato color palette from the themes directory
  catppuccinMacchiato = import ../../../themes/catppuccin-macchiato.nix;
in
{
  programs.starship = {
    enable = true;
    settings = {
      # Define the overall prompt format: username, directory, git info, languages, time, and character
      format = "$username$directory$git_branch$git_status$nodejs$rust$python$time$line_break$character";
      palette = "catppuccin_macchiato";

      # Username module: Shows the current user with red color
      username = {
        show_always = true;
        style_user = "fg:#${catppuccinMacchiato.red}";
        style_root = "fg:#${catppuccinMacchiato.red}";
        format = "[$user]($style) ";
      };

      # Directory module: Displays current path with peach color and folder icons
      directory = {
        style = "fg:#${catppuccinMacchiato.peach}";
        format = "[$path]($style) ";
        truncation_length = 3;
        truncation_symbol = "…/";
        substitutions = {
          "Documents" = "󰈙 ";
          "Downloads" = " ";
          "Music" = "󰝚 ";
          "Pictures" = " ";
          "Developer" = "󰲋 ";
        };
      };

      # Git branch module: Shows current branch with git icon
      git_branch = {
        symbol = "";
        style = "fg:#${catppuccinMacchiato.yellow}";
        format = "[$symbol $branch]($style) ";
      };

      # Git status module: Displays git status indicators
      git_status = {
        style = "fg:#${catppuccinMacchiato.yellow}";
        format = "[$all_status$ahead_behind]($style) ";
      };

      # Node.js module: Shows Node.js version if in a Node project
      nodejs = {
        symbol = "";
        style = "fg:#${catppuccinMacchiato.green}";
        format = "[$symbol $version]($style) ";
      };

      # Rust module: Shows Rust version if in a Rust project
      rust = {
        symbol = "";
        style = "fg:#${catppuccinMacchiato.green}";
        format = "[$symbol $version]($style) ";
      };

      # Python module: Shows Python version and virtualenv if active
      python = {
        symbol = "";
        style = "fg:#${catppuccinMacchiato.green}";
        format = "[$symbol $version]($style) ";
      };

      # Time module: Displays current time in HH:MM format
      time = {
        disabled = false;
        time_format = "%R";
        style = "fg:#${catppuccinMacchiato.lavender}";
        format = "[$time]($style) ";
      };

      # Character module: Custom prompt character with Vi mode support
      character = {
        success_symbol = "[❯](fg:#${catppuccinMacchiato.green})";
        error_symbol = "[❯](fg:#${catppuccinMacchiato.red})";
        # Use plain text for Vi mode to avoid Unicode warnings
        vimcmd_symbol = "[N](fg:#${catppuccinMacchiato.green})";
        vimcmd_replace_one_symbol = "[R](fg:#${catppuccinMacchiato.lavender})";
        vimcmd_replace_symbol = "[R](fg:#${catppuccinMacchiato.lavender})";
        vimcmd_visual_symbol = "[V](fg:#${catppuccinMacchiato.yellow})";
      };

      # Command duration module: Shows how long commands took
      cmd_duration = {
        format = "took [$duration](fg:#${catppuccinMacchiato.lavender}) ";
      };

      # Color palette: Define Catppuccin Macchiato colors for consistency
      palettes.catppuccin_macchiato = {
        rosewater = "#${catppuccinMacchiato.rosewater}";
        flamingo = "#${catppuccinMacchiato.flamingo}";
        pink = "#${catppuccinMacchiato.pink}";
        mauve = "#${catppuccinMacchiato.mauve}";
        red = "#${catppuccinMacchiato.red}";
        maroon = "#${catppuccinMacchiato.maroon}";
        peach = "#${catppuccinMacchiato.peach}";
        yellow = "#${catppuccinMacchiato.yellow}";
        green = "#${catppuccinMacchiato.green}";
        teal = "#${catppuccinMacchiato.teal}";
        sky = "#${catppuccinMacchiato.sky}";
        sapphire = "#${catppuccinMacchiato.sapphire}";
        blue = "#${catppuccinMacchiato.blue}";
        lavender = "#${catppuccinMacchiato.lavender}";
        text = "#${catppuccinMacchiato.text}";
        subtext1 = "#${catppuccinMacchiato.subtext1}";
        subtext0 = "#${catppuccinMacchiato.subtext0}";
        overlay2 = "#${catppuccinMacchiato.overlay2}";
        overlay1 = "#${catppuccinMacchiato.overlay1}";
        overlay0 = "#${catppuccinMacchiato.overlay0}";
        surface2 = "#${catppuccinMacchiato.surface2}";
        surface1 = "#${catppuccinMacchiato.surface1}";
        surface0 = "#${catppuccinMacchiato.surface0}";
        base = "#${catppuccinMacchiato.base}";
        mantle = "#${catppuccinMacchiato.mantle}";
        crust = "#${catppuccinMacchiato.crust}";
      };
    };
  };
}
