flake: {
  config,
  lib,
  ...
}: let
  cfg = config.profiles.installationDevice;
in {
  options = {
    profiles.installationDevice.enable = lib.mkEnableOption ''
      Whether to enable a basic configuration profile intended for installation devices like CDs.
    '';
  };

  imports = [
    # Conditionally import the profile module
    (args @ {pkgs, ...}: let
      module = builtins.removeAttrs (import "${flake.inputs.nixpkgs}/nixos/modules/profiles/installation-device.nix" args) ["imports"];
      config = lib.mkIf cfg.enable (
        # Fix import of hardware
        (import "${flake.inputs.nixpkgs}/nixos/modules/installer/scan/detected.nix" args).config
        // import "${flake.inputs.nixpkgs}/nixos/modules/installer/scan/not-detected.nix" args
        # Fix import of channels
        // import "${flake.inputs.nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix" args
        # Fix import of profiles
        // {
          profiles.cloneConfig.enable = true;
        }
        // module.config
      );
    in
      module // {inherit config;})
  ];
}
