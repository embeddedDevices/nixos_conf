{ config, pkgs, ... }:
{
  programs.fastfetch = {
    enable = true;
    
    settings = {
      logo = {
        source = "nixos"; # Zwingt das NixOS-Logo
        padding = {
          top = 2;
          right = 6;
          left = 2;
        };
      };
      display = {
        separator = " ➜  "; # Das Trennzeichen zwischen Key und Value
      };
      modules = [
        # --- 1. HARDWARE ---
        {
          type = "custom";
          format = "╭─────────── Hardware ───────────╮";
        }
        { type = "host";    key = "│  PC      "; keyColor = "green"; }
        { type = "cpu";     key = "│  CPU     "; keyColor = "green"; }
        { type = "gpu";     key = "│ 󰢮 GPU     "; keyColor = "green"; }
        { type = "display"; key = "│ 󰍹 Display "; keyColor = "green"; }
        { type = "memory";  key = "│  Memory  "; keyColor = "green"; }
        { type = "disk";    key = "╰  Disk    "; keyColor = "green"; }
        { type = "break"; } # Abstand zur nächsten Box

        # --- 2. SOFTWARE ---
        {
          type = "custom";
          format = "╭─────────── Software ───────────╮";
        }
        { type = "os";       key = "│  OS      "; keyColor = "yellow"; }
        { type = "kernel";   key = "│  Kernel  "; keyColor = "yellow"; }
        { type = "packages"; key = "│ 󰏖 Packages"; keyColor = "yellow"; }
        { type = "shell";    key = "│  Shell   "; keyColor = "yellow"; }
        { type = "de";       key = "│ 󰧨 DE      "; keyColor = "blue"; }
        { type = "wm";       key = "│  WM      "; keyColor = "blue"; }
        { type = "theme";    key = "│ 󰉼 Theme   "; keyColor = "blue"; }
        { type = "terminal"; key = "│  Terminal"; keyColor = "blue"; }
        { type = "terminalfont"; key = "╰  Font    "; keyColor = "blue"; }
        { type = "break"; }

        # --- 3. UPTIME & ALTER ---
        {
          type = "custom";
          format = "╭──────── Uptime / Age ──────────╮";
        }
        { type = "uptime";   key = "│ 󰅐 Uptime  "; keyColor = "magenta"; }
        { type = "datetime"; key = "╰  Date    "; keyColor = "magenta"; }
      ];
    };
  };
}
