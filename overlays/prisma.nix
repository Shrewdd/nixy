{ final, prev }:

# Prisma overlay (final: prev: { ... })
# - Provides a `prisma-engines` derivation built from the official npm tarball.
# - Uses `builtins.fetchurl` to avoid evaluation-order recursion.
# - Update `version` and the `sha256` to move to newer releases.

let
  pkgs = prev;
  version = "7.0.1";
  src = builtins.fetchurl {
    url = "https://registry.npmjs.org/prisma/-/prisma-${version}.tgz";
    sha256 = "1jdcxlap9a4pk4zwz65cgf4ghn136fmaw37wjrnbd7c6rnscfz5d";
  };
in
{
  # Expose `prisma-engines` so existing NixOS configs that refer to
  # `pkgs.prisma-engines` will continue to work.
  prisma-engines = pkgs.stdenv.mkDerivation {
    pname = "prisma-engines";
    inherit version src;

    nativeBuildInputs = [];

    # Unpack the npm tarball into a temporary directory and copy expected
    # runtime artifacts into the Nix store layout.
    unpackPhase = ''
      mkdir -p $TMPDIR/src
      tar -xzf $src -C $TMPDIR/src --strip-components=1
      export SRC_DIR=$TMPDIR/src
    '';

    installPhase = ''
      mkdir -p $out/bin $out/lib

      # Common binaries (schema-engine, prisma-fmt, query-engine)
      for bin in schema-engine prisma-fmt query-engine; do
        if [ -f "$SRC_DIR/$bin" ]; then
          cp "$SRC_DIR/$bin" "$out/bin/"
        fi
      done

      # Node native addon: try a few possible locations and normalize the name
      if [ -f "$SRC_DIR/libquery_engine.node" ]; then
        cp "$SRC_DIR/libquery_engine.node" $out/lib/libquery_engine.node
      fi
      if [ -f "$SRC_DIR/runtime/query-engine-node/index.node" ]; then
        cp "$SRC_DIR/runtime/query-engine-node/index.node" $out/lib/libquery_engine.node
      fi
      if [ -f "$SRC_DIR/query-engine/index.node" ]; then
        cp "$SRC_DIR/query-engine/index.node" $out/lib/libquery_engine.node
      fi

      chmod +x $out/bin/* || true
    '';

    meta = with pkgs.lib; {
      description = "Prisma engines bundle (from npm prisma-${version})";
      license = licenses.asl20;
      platforms = platforms.linux;
    };
  };

  # Example: if you want to override the top-level `prisma` package from nixpkgs
  # to use this version, you can uncomment the following block. This is optional
  # and commented by default because the upstream `prisma` package layout may
  # differ between nixpkgs versions.
  #
  # (if prev ? prisma then {
  #   prisma = prev.prisma.overrideAttrs (old: {
  #     inherit src version;
  #   });
  # } else {})
}
