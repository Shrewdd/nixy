final: prev: {
  prisma-engines = prev.prisma-engines.overrideAttrs (old: rec {
    version = "7.0.1";
    src = prev.fetchFromGitHub {
      owner = "prisma";
      repo = "prisma-engines";
      rev = version;
      hash = "sha256-16lksjhzwkp920lfalgqzxm7fdzyaic65c7c15v29jcndwrkxjgv";
    };
    cargoHash = prev.lib.fakeSha256;
    cargoVendorDir = null;
  });
}
