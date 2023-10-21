{ config, lib, ... }:

{
  boot = {
    loader = {
      # Allows discovery of UEFI disks
      efi = { canTouchEfiVariables = false; };

      # Use systemd boot instead of grub
      systemd-boot = {
        enable = false;
        configurationLimit = 10;
        # Select the highest resolution for the bootloader
        consoleMode = "max";
      };

      grub.enable = true;
      grub.efiSupport = false;
      grub.devices = [ "nodev" ];

      timeout = 1; # Boot default entry after 1 second
    };

    initrd.secrets =
      lib.mkIf config.boot.grub.enable { "/crypto_keyfile.bin" = null; };

    plymouth.enable = config.boot.animation.enable;
  };
}
