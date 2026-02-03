{...}: {
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        type = "small";
        width = 20;
        height = 13;
      };
      display = {
        separator = "  ";
      };
      modules = [
        {
          type = "title";
          format = "{user-name-colored} @{host-name-colored}";
        }
        {
          type = "separator";
          string = "─";
        }
        "os"
        "kernel"
        "uptime"
        "cpu"
        "gpu"
        "memory"
        "swap"
        "disk"
        "display"
        "shell"
        "de"
        "distro-id"
      ];
    };
  };
}
