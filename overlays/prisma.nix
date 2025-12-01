{ self, super }:

# ===================================
# Prisma overlay
# Provides a `prisma-engines` derivation built from the official npm tarball.
# We pin the npm tarball sha256 so builds are reproducible. To update, change
# `version` and run `nix-prefetch-url --unpack` to get a new sha256.
# ===================================

let
  version = "7.0.1";
  src = super.fetchurl {
    url = "https://registry.npmjs.org/prisma/-/prisma-${version}.tgz";
    sha256 = "1jdcxlap9a4pk4zwz65cgf4ghn136fmaw37wjrnbd7c6rnscfz5d";
  };
in
{
  # Expose `prisma-engines` so existing NixOS configs that refer to
  # `pkgs.prisma-engines` will continue to work.
  prisma-engines = super.stdenv.mkDerivation {
    pname = "prisma-engines";
    inherit version;
    src = src;

    nativeBuildInputs = [];

    # npm tarballs usually contain a top-level `package/` directory. We
    # strip the component so the package contents appear at the root.
    unpackPhase = ''
      tar -xzf $src --strip-components=1
    '';

    # installPhase: best-effort layout. Different Prisma versions may store
    # compiled binaries or node native addons in different paths. We copy a
    # few expected locations into the Nix store so runtime env vars from
    # `configuration.nix` continue to point at something usable.
    installPhase = ''
      mkdir -p $out/bin $out/lib

      # Common binaries (schema-engine, prisma-fmt, query-engine)
      for bin in schema-engine prisma-fmt query-engine; do
        if [ -f "./$bin" ]; then
          cp "./$bin" "$out/bin/"
        fi
      done

      # Node native addon: try a few possible locations and normalize the name
      if [ -f ./libquery_engine.node ]; then
        cp ./libquery_engine.node $out/lib/libquery_engine.node
      fi
      if [ -f ./runtime/query-engine-node/index.node ]; then
        cp ./runtime/query-engine-node/index.node $out/lib/libquery_engine.node
      fi
      if [ -f ./query-engine/index.node ]; then
        cp ./query-engine/index.node $out/lib/libquery_engine.node
      fi

      chmod +x $out/bin/* || true
    '';

    meta = with super.lib; {
      description = "Prisma engines bundle (from npm prisma-${version})";
      license = licenses.asl20;
      platforms = platforms.linux;
    };
  };
}
