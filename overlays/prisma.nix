final: prev: {
  prisma-engines = prev.prisma-engines.overrideAttrs (old: rec {
    version = "7.0.1";
    src = prev.fetchFromGitHub {
      owner = "prisma";
      repo = "prisma-engines";
      rev = version;
      hash = "sha256-+8k+M2+WySR2CeywYlhU/jd3av/4UeUoEOlO/qHUk5o=";
    };
    cargoHash = prev.lib.fakeSha256;
  });
}
