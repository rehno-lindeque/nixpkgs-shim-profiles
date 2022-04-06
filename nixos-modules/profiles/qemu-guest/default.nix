flake: {
  config,
  lib,
  ...
}: let
  cfg = config.profiles.qemuGuest;
in {
  options = {
    profiles.qemuGuest.enable = lib.mkEnableOption ''
      Whether to enable a profile with common configuration used in virtual machines running under QEMU (using virtio).
    '';
  };

  imports = [
    # Conditionally import the profile module
    (args: let
      module = import "${flake.inputs.nixpkgs}/nixos/modules/profiles/qemu-guest.nix" args;
      config = lib.mkIf cfg.enable module;
    in {inherit config;})
  ];
}
