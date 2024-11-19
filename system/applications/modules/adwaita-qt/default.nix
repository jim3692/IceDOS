{
  lib,
  config,
  pkgs,
  ...
}:

let
  inherit (lib) mapAttrs;
  cfg = config.icedos;

  accentColor =
    if (!cfg.desktop.gnome.enable) then
      cfg.desktop.accentColor
    else
      {
        blue = "#3584e4";
        green = "#3a944a";
        orange = "#ed5b00";
        pink = "#d56199";
        purple = "#9141ac";
        red = "#e62d42";
        slate = "#6f8396";
        teal = "#2190a4";
        yellow = "#c88800";
      }
      .${cfg.desktop.gnome.accentColor};

  accentColorPatch = _: oldAdwaita:
    let
      replaceColor = color: value:
        "-e 's/@define-color ${color} .*+;/@define-color ${color} ${value};/g' \\";
      replaceProperty = selector: property: value:
        "-e 's/(^${selector}.*${property}: )[^;]*(;.*)/\\1${value}\\2/g' \\";

      patch = pkgs.runCommand "adwaita-qt-accent-patch" {
        nativeBuildInputs = [ pkgs.diffutils ];
      } ''
        cd ${oldAdwaita.src}
        original="src/lib/stylesheet/processed/Adwaita-dark.css"
        diff -Naru $original <(
          sed -r \
            ${replaceColor "selected_bg_color" accentColor}
            ${replaceColor "link_color" accentColor}
            ${replaceColor "link_visited_color" accentColor}
            ${replaceColor "scrollbar_slider_active_color" accentColor}
            ${replaceColor "suggested_bg_color" accentColor}
            ${replaceColor "progress_bg_color" accentColor}
            ${replaceColor "checkradio_bg_color" accentColor}
            ${replaceColor "checkradio_borders_color" accentColor}
            ${replaceColor "switch_bg_color" accentColor}
            ${replaceColor "focus_border_color" accentColor}
            ${replaceProperty "checkradio:checked" "background-image" accentColor}
            ${replaceProperty "checkradio:checked:hover" "background-image" accentColor}
            ${replaceProperty "checkradio:checked:active" "background-image" "image(${accentColor})"}
            $original \
        ) \
          | sed "s|$original|a/$original|" \
          | sed "s|/dev/fd/63|b/$original|" >$out || true
      '';
    in { patches = (oldAdwaita.patches or [ ]) ++ [ patch ]; };

  adwaitaQtBuilder =
    (let inherit accentColorPatch; in p: p.overrideAttrs accentColorPatch);
in
{
  environment.systemPackages = with pkgs; [
    (adwaitaQtBuilder adwaita-qt)
    (adwaitaQtBuilder adwaita-qt6)
    kdePackages.qt6ct
    libsForQt5.qt5ct
  ];

  home-manager.users = mapAttrs (user: _: {
    home.file = {
      ".config/qt5ct/qt5ct.conf".source = ./qt5ct.conf;
      ".config/qt6ct/qt6ct.conf".source = ./qt6ct.conf;
    };
  }) cfg.system.users;
}
