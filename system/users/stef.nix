{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

let
  inherit (lib) optional;
  cfg = config.icedos;
in
{
  users.users.stef.packages =
    with pkgs;
    [
      # cemu # Wiuu
      # duckstation # PS1
      # pcsx2 # PS2
      # ppsspp # PSP
      rpcs3 # PS3

      bottles # Wine manager
      flac # Library and tools for encoding and decoding the FLAC lossless audio file format
      # heroic # Cross-platform Epic Games Launcher
      nicotine-plus # p2p music sharing platform
      nodejs_20 # Node package manager
      # prismlauncher # Minecraft launcher
      protontricks # Winetricks for proton prefixes
      spek # Audio file spectrogram analysis
      stremio # Media streaming platform
    ]
    ++ optional (cfg.applications.falkor) inputs.falkor.packages.${pkgs.system}.default
    ++ optional (cfg.applications.suyu) inputs.switch-emulators.packages.${pkgs.system}.suyu;
}
