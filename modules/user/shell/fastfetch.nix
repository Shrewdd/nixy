{...}: {
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        type = "kitty-direct";
        source = "${toString ./../shared/logos/nixos.png}";
        width = 34;
        padding = {
          top = 8;
          bottom = 8;
          right = 5;
          left = 5;
        };
      };
      display = {
        separator = " -> ";
      };
      modules = [
        "break"
        {
          type = "custom";
          format = "╭────────────────────── Hardware ──────────────────────╮";
          outputColor = "red";
        }
        {
          type = "title";
          key = "  PC";
          keyColor = "green";
          format = "{user-name-colored} on {host-name-colored}";
        }
        {
          type = "cpu";
          key = "│ ├󰍛 CPU";
          format = "{name} {freq-max}";
          keyColor = "green";
        }
        {
          type = "gpu";
          key = "│ ├󰍛 GPU";
          keyColor = "green";
          format = "{vendor} {name}";
        }
        {
          type = "disk";
          key = "│ ├󱛟 Disk";
          keyColor = "green";
        }
        {
          type = "memory";
          key = "└ └󰍛 Memory";
          keyColor = "green";
        }
        {
          type = "custom";
          format = "╰──────────────────────────────────────────────────────╯";
          outputColor = "red";
        }
        "break"
        {
          type = "custom";
          format = "╭────────────────────── Software ──────────────────────╮";
          outputColor = "red";
        }
        {
          type = "os";
          key = "  OS";
          keyColor = "yellow";
          format = "NixOS {version-id}";
        }
        {
          type = "kernel";
          key = "│ ├ Kernel";
          keyColor = "yellow";
        }
        {
          type = "shell";
          key = "│ ├ Shell";
          keyColor = "yellow";
          format = "{1}";
        }
        {
          type = "packages";
          key = "│ ├󰏖 Packages";
          keyColor = "yellow";
        }
        {
          type = "uptime";
          key = "└ └ Uptime";
          keyColor = "yellow";
        }
        {
          type = "custom";
          format = "╰──────────────────────────────────────────────────────╯";
          outputColor = "red";
        }
        "break"
        {
          type = "de";
          key = "  DE";
          keyColor = "blue";
          format = "{1}";
        }
        {
          type = "wm";
          key = "│ ├ Compositor";
          keyColor = "blue";
          format = "{1}";
        }
        {
          type = "lm";
          key = "│ ├ Login";
          keyColor = "blue";
          format = "{1}";
        }
        {
          type = "terminal";
          key = "│ ├ Terminal";
          keyColor = "blue";
          format = "{1}";
        }
        {
          type = "icons";
          key = "│ ├󰄛 Icons";
          keyColor = "blue";
        }
        {
          type = "colors";
          paddingLeft = 20;
          symbol = "circle";
        }
        "break"
      ];
    };
  };
}
