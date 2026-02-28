{lib, ...}: {
  programs.git = {
    enable = true;
    settings.user = {
      name = lib.mkDefault "qkbp";
      email = lib.mkDefault "qkbpp@protonmail.com";
    };
  };
}
