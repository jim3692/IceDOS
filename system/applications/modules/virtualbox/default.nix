{
  config,
  lib,
  ...
}:

let
  inherit (lib) mkIf;

  cfg = config.icedos.system.virtualisation;
in mkIf (cfg.virtualbox) {

  # Workaround for Kernel 6.12+
  boot.kernelParams = [ "kvm.enable_virt_at_load=0" ];

  virtualisation.virtualbox.host = {
    enable = true;

    # Enable host-only networking
    addNetworkInterface = true;

    # Enable USB3 passthough
    enableExtensionPack = false;

    # Conflicts with addNetworkInterface
    enableKvm = false;
  };
}
