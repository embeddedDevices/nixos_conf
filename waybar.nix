{ config, pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        spacing = 4;
        
        # --- NEU: Abstände für den schwebenden Look ---
        margin-top = 2;
        margin-left = 2;
        margin-right = 2;
        # ----------------------------------------------
        
        #-- waybar design
        modules-left = [ "custom/nix" "hyprland/workspaces" ];
        modules-right = [ "cpu" "memory" "bluetooth" "network" "pulseaudio" "backlight" "battery" "clock" "tray" "custom/power" ];

        #-- NIXOS/HYPRLAND LOGO ---
        "custom/nix" = {
          format = "  "; 
          tooltip = false;
          on-click = "wofi --show drun"; 
        };

        "hyprland/workspaces" = {
          format = "{icon}";
          format-icons = {
            active = "●";
            default = "○";
          };
          #persistent-workspaces = {
          #  "*" = 4; 
          #};
          # true = zeigt immer alle Workspaces auf allen Monitoren an
          # false = zeigt auf einem Monitor nur die Workspaces an, die auch zu ihm gehören
          "all-outputs" = false; 

          # Zwingt Waybar, diese Workspaces IMMER anzuzeigen, auch wenn sie leer sind
          # gleiche Zuordnung wie die workspace_rules in hyprland.lua
          "persistent-workspaces" = {
            "1" = ["DP-6"];
            "2" = ["DP-6"];
            "3" = ["DP-5"];
            "4" = ["DP-5"];
            "5" = ["eDP-1"];
            "6" = ["eDP-1"];
          };
        };
        
        "clock" = {
          format = "{:%a, %d. %b  %H:%M}";
          tooltip = false;
          on-click = "gnome-calendar";
        };

        "cpu" = {
          format = "  {usage}%";
          tooltip = false;
          on-click = "gnome-system-monitor";
        };

        "memory" = {
          format = "  {}%";
          tooltip = false;
          on-click = "gnome-system-monitor";
        };
        
        "bluetooth" = {
          # Standard-Format: Bluetooth ist AN, aber KEIN Gerät ist verbunden
          format = "󰂯 "; 
          #format = "󰂯  Disconnected"; 
          
          # Format, wenn Bluetooth komplett AUSgeschaltet ist
          format-off = "󰂲 "; 
          #format-off = "󰂲  Off"; 
          
          # Format, wenn ein Gerät VERBUNDEN ist
          format-connected = "󰂱 "; 
          #format-connected = "󰂱  {device_alias}"; 
          
          tooltip = true;
          tooltip-format = "{device_alias}";
          on-click = "blueman-manager";
        };

        "network" = {
          format = " ";
          format-ethernet = "󰈀 ";
          format-disconnected = "󰖪 ";
          tooltip-format = "{essid} ({signalStrength}%)";
          on-click = "nm-connection-editor";
        };

        "pulseaudio" = {
          format = "{icon}  {volume}%";
          format-muted = "󰖁  Muted";
          format-icons = ["󰕿" "󰖀" "󰕾"];
          on-click = "pavucontrol";
        };

        "backlight" = {
          format = "{icon}  {percent}%";
          format-icons = ["󰃞" "󰃟" "󰃠"];
        };

        "battery" = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon}  {capacity}%";
          format-charging = "󰂄  {capacity}%";
          format-icons = ["󰁺" "󰁾" "󰁹"];
        };

        #-- Tray für nm-applet und blueman-applet (werden in hyprland.lua gestartet)
        "tray" = {
          icon-size = 16;
          spacing = 8;
        };

        "custom/power" = {
          format = "  ";
          tooltip = false;
          on-click = "wlogout";
        };
      };
    };

    style = ''
      * {
        border: none;
        /* border-radius entfernt, damit die Bar runde Ecken haben darf */
        
        /* "Inter" als Hauptschriftart */
        font-family: "Inter", "JetBrainsMono Nerd Font", "sans-serif"; 
        font-size: 14px;
        font-weight: 600;
      }

      window#waybar {
        background-color: rgba(30, 30, 46, 0.5); 
        color: #cdd6f4;
        
        /* NEU: Abgerundete Ecken für die gesamte Leiste */
        border-radius: 12px; 
      }

      #custom-nix {
        font-size: 18px;
        padding: 0 15px 0 20px;
        color: #cdd6f4;
      }

      #workspaces button {
        padding: 0 8px;
        color: #7f849c;
        background: transparent;
      }

      #workspaces button.active {
        color: #cdd6f4;
      }

      #clock, #cpu, #memory, #backlight, #bluetooth, #battery, #pulseaudio, #network, #tray {
        padding: 0 8px;
        color: #cdd6f4;
      }

      #bluetooth, #network, #pulseaudio {
        margin-left: 15px;
      }

      #custom-power {
        font-size: 16px;
        padding: 0 15px 0 8px;
        color: #f38ba8; 
      }

      #tray {
        padding-right: 15px;
      }

      #battery.warning { color: #f9e2af; }
      #battery.critical { color: #f38ba8; }
    '';
  };
}
