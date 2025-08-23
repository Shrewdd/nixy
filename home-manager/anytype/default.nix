{ pkgs, lib, inputs, ... }:
let
	anytypePkg = inputs.anytype.packages.${pkgs.stdenv.system}.default;
in
{
	home.packages = [ anytypePkg ];
}
