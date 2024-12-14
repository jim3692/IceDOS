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

  emulators =
    with pkgs;
    [
      # cemu # Wiuu
      # duckstation # PS1
      # pcsx2 # PS2
      # ppsspp # PSP
      rpcs3 # PS3
    ]
    ++ optional (cfg.applications.suyu) inputs.switch-emulators.packages.${pkgs.system}.suyu;

  gaming = with pkgs; [
    # heroic # Cross-platform Epic Games Launcher
    # prismlauncher # Minecraft launcher
    protontricks # Winetricks for proton prefixes
  ];
in
{
  users.users.stef.packages =
    with pkgs;
    [
      bottles # Wine manager
      flac # Library and tools for encoding and decoding the FLAC lossless audio file format
      nicotine-plus # p2p music sharing platform
      nodejs_20 # Node package manager
      spek # Audio file spectrogram analysis
      stremio # Media streaming platform
    ]
    ++ emulators
    ++ gaming;
}
