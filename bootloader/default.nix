{ config, ... }:

{
  boot = {
    loader = {
      # Allows discovery of UEFI disks
      efi = {
        canTouchEfiVariables = false;
      };

      # Use systemd boot instead of grub
      systemd-boot = {
        enable = false;
        configurationLimit = 10;
        consoleMode = "max"; # Select the highest resolution for the bootloader
      };

      grub.enable = true;
      grub.efiSupport = false;
      grub.devices = [ "nodev" ];

      timeout = 1; # Boot default entry after 1 second
    };

    plymouth.enable = config.boot.animation.enable;
  };
}
