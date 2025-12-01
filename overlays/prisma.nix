final: prev: {
  # Prisma overlay (final: prev: { ... })
  # - Provides a `prisma-engines` derivation built from the official npm tarball.
  # - Uses `builtins.fetchurl` to avoid evaluation-order recursion.
  # - Update `version` and the `sha256` in `prisma-derivation.nix` to move to newer releases.

  # Import the derivation that expects `pkgs` to avoid evaluation-order issues.
  prisma-engines = (import ./prisma-derivation.nix { pkgs = prev; });
}
