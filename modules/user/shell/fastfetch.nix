{...}: {
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        type = "small";
        width = 16;
        height = 10;
      };
      display = {
        separator = " ";
      };
      modules = [
        {
          type = "title";
          format = "{user-name-colored}@{host-name-colored}";
        }
        "os"
        "kernel"
        "cpu"
        "memory"
        "shell"
        "uptime"
      ];
    };
  };
}
