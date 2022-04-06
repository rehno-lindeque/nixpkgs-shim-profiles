flake: {
  config,
  lib,
  ...
}: let
  cfg = config.profiles.graphical;
in {
  options = {
    profiles.graphical.enable = lib.mkEnableOption ''
      Whether to enable a graphical configuration profile based on the plasma5 desktop and including software
      used by the graphical installation CD.
    '';
  };

  imports = [
    # Conditionally import the profile module
    (args @ {pkgs, ...}: let
      module = import "${flake.inputs.nixpkgs}/nixos/modules/profiles/graphical.nix" args;
      config = lib.mkIf cfg.enable module;
    in {inherit config;})
  ];
}
