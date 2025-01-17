{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mapAttrs;
  cfg = config.icedos;
in
{
  home-manager.users = mapAttrs (user: _: {
    programs = {
      zsh = {
        enable = true;

        # Install powerlevel10k
        plugins = with pkgs; [
          {
            name = "zsh-nix-shell";
            file = "share/zsh-nix-shell/nix-shell.plugin.zsh";
            src = zsh-nix-shell;
          }
        ];
      };
    };

    home.file = {
      ".config/zsh/p10k.zsh".source = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      ".config/zsh/p10k-theme.zsh".source = ./p10k-theme.zsh;
    };
  }) cfg.system.users;

  programs.zsh = {
    enable = true;

    ohMyZsh = {
      enable = true;
      plugins = [
        "git"
        "npm"
        "sudo"
        "systemd"
      ];
    };

    autosuggestions.enable = true;

    syntaxHighlighting.enable = true;

    shellAliases = {
      btrfs-compress = "sudo btrfs filesystem defrag -czstd -r -v"; # Compress given path with zstd
      list-pkgs = "nix-store --query --requisites /run/current-system | cut -d- -f2- | sort | uniq"; # List installed nix packages
      reboot-uefi = "sudo systemctl reboot --firmware-setup";
      repair-store = "nix-store --verify --check-contents --repair"; # Verifies integrity and repairs inconsistencies between Nix database and store
      ssh = "TERM=xterm-256color ssh"; # SSH with colors
    };

    interactiveShellInit = ''
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi

      [[ ! -f ~/.config/zsh/p10k.zsh ]] || source ~/.config/zsh/p10k.zsh
      [[ ! -f ~/.config/zsh/p10k-theme.zsh ]] || source ~/.config/zsh/p10k-theme.zsh
      unsetopt PROMPT_SP
    '';
  };

  users.defaultUserShell = pkgs.zsh; # Use ZSH shell for all users
}
