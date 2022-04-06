flake: {
  config,
  lib,
  ...
}: let
  cfg = config.profiles.demo;
in {
  options = {
    profiles.demo.enable = lib.mkEnableOption ''
      Whether to enable demo configuration profile which includes a demo user with demo password and autologin.
    '';
  };

  imports = [
    # Conditionally import the profile module
    (args @ {pkgs, ...}: let
      module = import "${flake.inputs.nixpkgs}/nixos/modules/profiles/demo.nix" args;
      config =
        lib.mkIf cfg.enable
        # Fix import of graphical profile
        {
          profiles.graphical.enable = true;
        }
        // builtins.removeAttrs module ["imports"];
    in {inherit config;})
  ];
}
