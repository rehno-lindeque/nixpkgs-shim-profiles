flake: {
  config,
  lib,
  ...
}: let
  cfg = config.profiles.base;
in {
  options = {
    profiles.base.enable = lib.mkEnableOption ''
      Whether to enable a base configuration including software packages included in the minimal installation CD.
    '';
  };

  imports = [
    # Conditionally import the profile module
    (args @ {pkgs, ...}: let
      module = import "${flake.inputs.nixpkgs}/nixos/modules/profiles/base.nix" args;
      config = lib.mkIf cfg.enable module;
    in {inherit config;})
  ];
}
