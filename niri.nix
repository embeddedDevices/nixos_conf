{ config, pkgs, ... }:
{
  #-- niri-Konfiguration (KDL) aus ./niri.kdl
  #-- Wird beim Build mit `niri validate` geprüft -> Tippfehler brechen den
  #-- nixos-rebuild ab statt niri beim Login.
  #-- niri selbst wird systemweit über programs.niri (configuration.nix) aktiviert.
  xdg.configFile."niri/config.kdl".source =
    pkgs.runCommand "niri-config.kdl" { nativeBuildInputs = [ pkgs.niri ]; } ''
      niri validate -c ${./niri.kdl}
      cp ${./niri.kdl} $out
    '';

  #-- IBus: GNOME aktiviert i18n.inputMethod (ibus) systemweit. Dessen
  #-- XDG-Autostart (/etc/xdg/autostart/ibus-daemon.desktop, NotShowIn=GNOME;KDE)
  #-- läuft in niri über xdg-desktop-autostart.target und zeigt dann die
  #-- "IBus Notification". Diese User-Datei gleichen Namens überschreibt sie.
  #-- GNOME startet IBus selbst (systemd), Hyprland nutzt kein XDG-Autostart.
  xdg.configFile."autostart/ibus-daemon.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=IBus
    Hidden=true
  '';

  home.packages = with pkgs; [
    xwayland-satellite # X11-Apps unter niri (wird von niri automatisch gestartet)
  ];
}
