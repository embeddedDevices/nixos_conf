{ config, pkgs, inputs, ... }:
{
  #-- Noctalia Shell (v5): Bar, Launcher, Notifications, Lockscreen, OSD, Wallpaper
  #-- Home-Manager-Modul kommt aus der Flake (inputs.noctalia.homeModules.default).
  #-- Gestartet wird Noctalia per `spawn-at-startup "noctalia"` in niri.kdl
  #-- (bewusst KEIN systemd-Service, damit es nicht in Hyprland/GNOME mitstartet).
  #-- Diese Settings sind nur Defaults; Änderungen im Settings-Menü (Mod+Comma)
  #-- überschreiben sie zur Laufzeit.
  #-- Doku: https://docs.noctalia.dev/
  programs.noctalia = {
    enable = true;
    settings = {
      theme = {
        mode = "dark";
      };

      wallpaper = {
        enabled = true;
        # gleicher Ordner wie das Hyprland-Skript next-wallpaper
        directory = "${config.home.homeDirectory}/Pictures/wallpapers";
      };

      # geblurrtes Wallpaper in der niri-Overview (siehe layer-rule in niri.kdl)
      backdrop = {
        enabled = true;
      };
    };
  };
}
