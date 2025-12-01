{ final, prev }:

# Prisma overlay (final: prev: { ... })
# - Provides a `prisma-engines` derivation built from the official npm tarball.
# - Uses `builtins.fetchurl` to avoid evaluation-order recursion.
# - Update `version` and the `sha256` to move to newer releases.

in {
  # Import the actual derivation that expects `pkgs` to avoid evaluation
  # ordering issues. This keeps the overlay function lightweight and avoids
  # accidental recursion.
  prisma-engines = (import ./prisma-derivation.nix { pkgs = prev; });
}
