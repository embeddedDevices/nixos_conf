{ config, pkgs, ... }: {
  # home.username = "dennis";
  # home.homeDirectory = "/home/dennis";
  home.stateVersion = "23.11"; #important for the compatibilty
  #home manager can manage itself
  programs.home-manager.enable = true;

  # --- 1. Dconf: Der systemweite Dark Mode Schalter ---
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  # --- 2. Cursor (Mauszeiger) zentral konfigurieren ---
  # Dies setzt den Cursor für GTK, X11/XWayland und Wayland
  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    x11.enable = true;
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 24;
  };

  # --- 3. GTK & Icons ---
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };

    gtk4.theme = null; #übernimmt das neue Standardverhalten
  };

  # --- 4. Qt Konfiguration ---
  # Qt-Apps übernehmen Theme, Farben und Dialoge vom GTK-Theme (Adwaita-dark)
  # über das in Qt eingebaute GTK3-Plugin (kein adwaita-qt nötig).
  qt = {
    enable = true;
    platformTheme.name = "gtk3";
  };

  # --- 5. XDG Portals (Bugfix für Home Manager Shadowing) ---
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gnome   # niri: Screencast/Screenshare
    ];
    config = {
      common = {
        default = [ "gtk" ];
      };
      Hyprland = {
        default = [ "hyprland" "gtk" ];
        # Dieser Eintrag wird nun endlich vom Home Manager respektiert:
        "org.freedesktop.portal.Settings" = [ "gtk" ];
      };
      # niri: sonst greift "common" (nur gtk) und Screensharing fehlt
      niri = {
        default = [ "gnome" "gtk" ];
        "org.freedesktop.impl.portal.Access" = [ "gtk" ];
        "org.freedesktop.impl.portal.Notification" = [ "gtk" ];
        "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
      };
    };
  };

  #integrarion of the home modules:
  imports = [
    ./hyprland.nix
    ./niri.nix
    ./noctalia.nix
    ./packages.nix
    ./zsh.nix
    ./kitty.nix
    ./nvim.nix
    ./waybar.nix
    ./hyprlock.nix
    ./fastfetch.nix
    ./awww.nix
    ./wofi.nix
    ./wlogout.nix
    ./claude-desktop.nix
  ];
}
