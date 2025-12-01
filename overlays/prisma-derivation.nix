{ pkgs, version ? "7.0.1", sha256 ? "1jdcxlap9a4pk4zwz65cgf4ghn136fmaw37wjrnbd7c6rnscfz5d" }:

let
  src = builtins.fetchurl {
    url = "https://registry.npmjs.org/prisma/-/prisma-${version}.tgz";
    inherit sha256;
  };
in pkgs.stdenv.mkDerivation {
  pname = "prisma-engines";
  inherit version src;

  nativeBuildInputs = [];

  unpackPhase = ''
    mkdir -p $TMPDIR/src
    tar -xzf $src -C $TMPDIR/src --strip-components=1
    export SRC_DIR=$TMPDIR/src
  '';

  installPhase = ''
    mkdir -p $out/bin $out/lib

    for bin in schema-engine prisma-fmt query-engine; do
      if [ -f "$SRC_DIR/$bin" ]; then
        cp "$SRC_DIR/$bin" "$out/bin/"
      fi
    done

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
}
