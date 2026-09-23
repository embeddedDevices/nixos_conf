{ config, pkgs, ... }:
{

  #-- kitty als Standard-Terminal (Shell: zsh aus configuration.nix, Editor: nvim)
  home.sessionVariables.TERMINAL = "kitty";

  #-- Standard-Terminal für Apps, die xdg-terminal-exec nutzen (z.B. Nautilus, .desktop-Dateien mit Terminal=true)
  xdg.terminal-exec = {
    enable = true;
    settings.default = [ "kitty.desktop" ];
  };

  programs.kitty = {
    enable = true;

    # Schriftart konfigurieren (stelle sicher, dass der Font auf dem System installiert ist)
    font = {
      name = "FiraCode Nerd Font";
      size = 12;
    };

    # Ein Theme auswählen (Kitty bringt viele von Haus aus mit)
    themeFile = "Catppuccin-Mocha"; 

    # Kitty-spezifische Einstellungen (entspricht der kitty.conf)
    settings = {
      scrollback_lines = 10000;
      enable_audio_bell = false;
      update_check_interval = 0; # In NixOS übernimmt Nix das Updaten
      window_padding_width = 4;
      background_opacity = "0.92";

      # --- Tab-Bar Konfiguration ---
      
      # Position der Tab-Leiste (unten)
      tab_bar_edge = "bottom";
      
      # Aktiviert den Powerline-Stil (erlaubt Formen)
      tab_bar_style = "powerline";
      
      # Macht die Ränder der Tabs schön rund!
      tab_powerline_style = "round";
      
      # (Optional) Zentriert die Tabs oder setzt sie nach links ("left", "center", "right")
      tab_bar_align = "left"; 

      # (Optional) Ein bisschen Abstand der Leiste zum Fensterrand
      tab_bar_margin_width = "0.0";
      tab_bar_margin_height = "0.0 0.0";

      # --- Tab-Farben (Passend zum Rainbow-Look) ---
      # Du kannst die Farben natürlich an dein restliches Theme anpassen
      active_tab_foreground   = "#1e1e2e";
      active_tab_background   = "#cba6f7"; # Ein schönes Violett für den aktiven Tab
      active_tab_font_style   = "bold";
      
      inactive_tab_foreground = "#bac2de";
      inactive_tab_background = "#313244";
      inactive_tab_font_style = "normal";
    };

    # Tastenkombinationen (Keybindings)
    keybindings = {
      "ctrl+c" = "copy_or_interrupt";
      "ctrl+v" = "paste_from_clipboard";
      "ctrl+shift+enter" = "new_window_with_cwd";
    };

    # Extra Konfiguration als roher String (falls etwas über 'settings' nicht geht)
    extraConfig = ''
      # Hier kannst du rohe kitty.conf Befehle einfügen
      hide_window_decorations no 
    '';
  };

}

