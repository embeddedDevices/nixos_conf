{ config, lib, pkgs, ... }:

{
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        hide_cursor = true;
        grace = 0;
        no_fade_in = false;
      };

      # 1. Hintergrund (Abgedunkelter Blur für Dark Theme)
      background = [
        {
          monitor = "";
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
          noise = 0.0117;
          contrast = 0.8916;
          brightness = 0.5;         # Reduzierte Helligkeit für das Dark Theme
          vibrancy = 0.1696;
          vibrancy_darkness = 0.5;  # Verstärkt die dunklen Töne im Blur
        }
      ];

      # 2. Uhrzeit
      label = [
        {
          monitor = "";
          text = "$TIME";
          font_size = 100;
          font_family = "Fira Code, Noto Sans";
          position = "0, 100";
          halign = "center";
          valign = "center";
          color = "rgb(205, 214, 244)"; # Catppuccin Mocha: Text
          shadow_passes = 2;
        }
        
        # 3. Datum
        {
          monitor = "";
          text = "cmd[update:60000] echo \"$(date +\"%A, %d. %B %Y\")\"";
          font_size = 25;
          font_family = "Fira Code, Noto Sans";
          position = "0, 0";
          halign = "center";
          valign = "center";
          color = "rgb(205, 214, 244)"; # Catppuccin Mocha: Text
          shadow_passes = 2;
        }
      ];

      # 4. Passwort-Eingabefeld im Catppuccin-Stil
      input-field = [
        {
          monitor = "";
          size = "250, 50";
          position = "0, -100";
          dots_center = true;
          fade_on_empty = false;
          
          # Catppuccin Mocha Farben
          font_color = "rgb(205, 214, 244)";
          inner_color = "rgba(30, 30, 46, 0.6)";
          outer_color = "rgba(180, 190, 254, 0.5)";
          check_color = "rgb(166, 227, 161)";
          fail_color = "rgb(243, 139, 168)";
          
          fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
          outline_thickness = 2;
          placeholder_text = "<span foreground=\"##a6adc8\"><i>Passwort...</i></span>";
          shadow_passes = 2;
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
