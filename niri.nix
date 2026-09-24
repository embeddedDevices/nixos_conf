{ config, pkgs, ... }:
{
  #-- niri-Konfiguration (KDL) aus ./niri.kdl
  #-- Wird beim Build mit `niri validate` geprüft -> Tippfehler brechen den
  #-- nixos-rebuild ab statt niri beim Login.
  #-- niri selbst wird systemweit über programs.niri (configuration.nix) aktiviert.
  xdg.configFile = {
    "niri/config.kdl".source =
      pkgs.runCommand "niri-config.kdl" { nativeBuildInputs = [ pkgs.niri ]; } ''
        niri validate -c ${./niri.kdl}
        cp ${./niri.kdl} $out
      '';
  }

  #-- XDG-Autostart-Einträge abschalten, die sonst in niri mitstarten
  #-- (niri startet xdg-desktop-autostart.target; Hyprland nutzt kein XDG-Autostart,
  #-- GNOME hat eigene WLAN-/Bluetooth-Menüs und startet IBus selbst):
  #--  - ibus-daemon: GNOME aktiviert i18n.inputMethod (ibus) systemweit -> in niri
  #--    kommt sonst die "IBus Notification". GNOME startet IBus selbst.
  #--  - nm-applet / blueman: doppelte WLAN-/Bluetooth-Icons neben Noctalias eigenen
  #--    Modulen. In Hyprland werden beide per exec_cmd (hyprland.lua) gestartet.
  #-- Eine User-Datei gleichen Namens mit Hidden=true überschreibt /etc/xdg/autostart.
  // builtins.listToAttrs (map
    (name: {
      name = "autostart/${name}.desktop";
      value.text = ''
        [Desktop Entry]
        Type=Application
        Name=${name}
        Hidden=true
      '';
    })
    [ "ibus-daemon" "nm-applet" "blueman" ]);

  home.packages = with pkgs; [
    xwayland-satellite # X11-Apps unter niri (wird von niri automatisch gestartet)
  ];
}
