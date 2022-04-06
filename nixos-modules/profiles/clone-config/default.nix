flake: {
  config,
  lib,
  ...
}: let
  cfg = config.profiles.cloneConfig;
in {
  options = {
    profiles.cloneConfig.enable = lib.mkEnableOption ''
      Whether to enable a configuration profile which includes a configuration.nix template for an installer.
    '';
  };

  imports = [
    # Conditionally import the profile module
    (args @ {
      pkgs,
      modules,
      ...
    }: let
      module = import "${flake.inputs.nixpkgs}/nixos/modules/profiles/clone-config.nix" args;
      config = lib.mkIf cfg.enable module.config;
    in
      module // {inherit config;})
  ];
}
