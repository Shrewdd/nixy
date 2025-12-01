final: prev: {
  prisma-engines = prev.prisma-engines.overrideAttrs (old: rec {
    version = "7.0.1";
    src = prev.fetchFromGitHub {
      owner = "prisma";
      repo = "prisma-engines";
      rev = version;
      hash = "sha256-07rn0bl4a8k9h7c0m8s247pn9dlw9hv3blvgfni7k87q00v0kkgy";
    };
    cargoHash = "sha256-07xy2rz0fwzxl9c29jjsw7mrfd7rl2pyq1ps732qpzcg1g2wddqh";
  });
}
