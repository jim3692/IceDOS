{
  pkgs,
  config,
  inputs,
  lib,
  ...
}:

let
  inherit (lib) foldl' lists splitString;

  pkgMapper =
    pkgList: lists.map (pkgName: foldl' (acc: cur: acc.${cur}) pkgs (splitString "." pkgName)) pkgList;

  pkgFile = lib.importTOML ./packages.toml;
  myPackages = (pkgMapper pkgFile.myPackages);

  cfg = config.icedos;

  codingDeps = (pkgMapper pkgFile.codingDeps);

  # Logout from any shell
  lout = pkgs.writeShellScriptBin "lout" ''
    pkill -KILL -u $USER
  '';

  rebuild = import modules/rebuild.nix {
    inherit pkgs config;
    command = "rebuild";
    update = "false";
  };

  toggle-services = import modules/toggle-services.nix { inherit pkgs; };

  # Trim NixOS generations
  trim-generations = pkgs.writeShellScriptBin "trim-generations" (
    builtins.readFile ../../scripts/trim-generations.sh
  );

  shellScripts = [
    inputs.shell-in-netns.packages.${pkgs.system}.default
    lout
    rebuild
    toggle-services
    trim-generations
  ];
in
{
  imports = [
    ./modules/android-tools.nix
    ./modules/aria2c.nix
    ./modules/bash.nix
    ./modules/brave.nix
    ./modules/btop
    ./modules/celluloid
    ./modules/clamav.nix
    ./modules/codium
    ./modules/container-manager.nix
    ./modules/gamemode.nix
    ./modules/garbage-collect
    ./modules/gdm.nix
    ./modules/git.nix
    ./modules/kernel.nix
    ./modules/kitty.nix
    ./modules/librewolf
    ./modules/libvirtd.nix
    ./modules/mangohud.nix
    ./modules/nvchad
    ./modules/steam.nix
    ./modules/sunshine.nix
    ./modules/tailscale.nix
    ./modules/tmux
    ./modules/waydroid.nix
    ./modules/zsh
  ];

  environment.systemPackages =
    (pkgMapper pkgFile.packages) ++ myPackages ++ codingDeps ++ shellScripts;

  programs = {
    direnv.enable = true;
  };

  services = {
    openssh.enable = true;
    fwupd.enable = true;
    udev.packages = with pkgs; [
      logitech-udev-rules # Needed for solaar to work
    ];
  };
}
