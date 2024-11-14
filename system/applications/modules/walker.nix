{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mapAttrs mkIf;
  cfg = config.icedos;
in
mkIf (cfg.applications.walker) {
  environment.systemPackages = [ pkgs.walker ];

  home-manager.users = mapAttrs (user: _: {
    systemd.user.services.walker = {
      Unit.Description = "Walker - Application Runner";
      Install.WantedBy = [ "graphical-session.target" ];

      Service = {
        ExecStart = "${pkgs.walker}/bin/walker --gapplication-service";
        Restart = "on-failure";
      };
    };
  }) cfg.system.users;
}
