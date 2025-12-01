let
  pkgs = import <nixpkgs> { overlays = [ (import ./overlays/prisma.nix) ]; };
in
pkgs.prisma-engines