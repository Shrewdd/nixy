{ config, pkgs, lib, inputs, ... }:
let
	anytypePkg = inputs.anytype.packages.${pkgs.stdenv.system}.default;
in {
	programs.anytype.enable = true;
};
