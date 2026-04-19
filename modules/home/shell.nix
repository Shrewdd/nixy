{
  pkgs,
  lib,
  ...
}: {
  # ── Fish ───────────────────────────────────────────────────────────
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
    '';
  };

  # ── Starship (HyDE style) ──────────────────────────────────────────
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  home.file.".config/starship/starship.toml".source = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/HyDE-Project/HyDE/main/Configs/.config/starship/starship.toml";
    sha256 = "sha256-qxVRjTixNMt+VGlEqUC8rHx5zRJmBYzyCkpmumttah4=";
  };

  # ── Shell utilities ────────────────────────────────────────────────
  home.packages = with pkgs; [fd];

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
