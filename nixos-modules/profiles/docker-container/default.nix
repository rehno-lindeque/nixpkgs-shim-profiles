flake: {
  config,
  lib,
  ...
}: let
  cfg = config.profiles.dockerContainer;
in {
  options = {
    profiles.dockerContainer.enable = lib.mkEnableOption ''
      Whether to enable the base profile from which the official Docker images are generated.
    '';
  };

  imports = [
    # Conditionally import the profile module
    (args @ {pkgs, ...}: let
      module = import "${flake.inputs.nixpkgs}/nixos/modules/profiles/docker-container.nix" args;
      config = lib.mkIf cfg.enable (
        # Fix import of channels
        import "${flake.inputs.nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix" args
        # Fix import of profiles
        // {
          profiles.minimal.enable = true;
          profiles.cloneConfig.enable = true;
        }
        // builtins.removeAttrs module ["imports"]
      );
    in {inherit config;})
  ];
}
