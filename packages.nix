{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    #-- linux & gnnome utilities
    htop
    gnome-tweaks
    gnome-extension-manager
    keepassxc
    
    #-- hyprland utilities
    # wofi, waybar, wlogout: kommen über programs.* (wofi.nix, waybar.nix, wlogout.nix)
    dunst          # Benachrichtigungs-Daemon (Notifications)
    wl-clipboard   # Zwischenablage (Copy & Paste) unter Wayland
    grim           # Screenshot-Tool
    slurp          # Bereichsauswahl für Screenshots
    networkmanagerapplet #network applet for waybar
    networkmanager_dmenu # WLAN-Picker via wofi: scannt Netze, auswählen, Passwort eingeben
    nwg-displays   # Grafische App zum Display Konfiguration
    wlr-randr      # Wayland Display Konfiguration
    brightnessctl  # Laptop-Helligkeit
    playerctl      # Sound Play/Pause/Vor/Zurück 
    pavucontrol    # Sound Mixer
    nwg-look       # Themes systemweit
    superfile      # Terminal Manager

    #-- gnome fonts
    nerd-fonts.fira-code
    nerd-fonts.meslo-lg

    #-- internet & communication
    #firefox
    thunderbird
    signal-desktop
    nextcloud-talk-desktop
    discord

    #-- office & latex
    libreoffice
    nextcloud-client
    obsidian
    joplin-desktop # Notizen, Sync via Nextcloud/WebDAV (iOS-App vorhanden)
    drawio
    meld
    pdfarranger

    #-- latex suite
    texliveMedium  # ersetzt das veraltete texlive.combined.scheme-medium
    texstudio
    
    #fixing latex desktop issue 
    gsettings-desktop-schemas
    gtk3
    
    #Multimedia
    gimp
    vlc
    audacity
    spotify

    #-- ASCII ART
    asciiquarium   # ASCII-Aquarium: Fische, Quallen, Wale
    cbonsai        # Bonsai-Baum wächst im Terminal (cbonsai -l -i)
    sl             # Dampflok bei vertipptem ls
    neo            # Matrix-Zeichenregen (moderner cmatrix)
    hollywood      # Hollywood-Hacker-Terminal
    cava           # Audio-Visualizer (PipeWire)
    mapscii        # Zoombare Weltkarte im Terminal

    #-- KI / Entwicklung
    claude-code    # Anthropic Claude Code CLI (Terminal). Start mit `claude` im Projektordner
    jetbrains.pycharm  # Unified PyCharm: 30 Tage Pro-Trial, danach Kern-Features dauerhaft kostenlos
    jetbrains.webstorm # JS/TS IDE: kostenlos für nicht-kommerzielle Nutzung (JetBrains-Account nötig)
  ];

  programs.firefox = {
    enable = true;
    configPath = ".mozilla/firefox";
    profiles.default = {
      name = "Default";
      
      # Suchmaschinen-Konfiguration
      search = {
        force = true;
        default = "ecosia";
        order = [ "ecosia" "ddg" "google" ];
      };

      # Über settings werden die "about:config" Werte gesteuert
      settings = {
        # 1. Privacy auf "Strict" (Streng) setzen
        # 0 = Standard, 4 = Strict
        "browser.contentblocking.category" = "strict";
        
        # 2. Tracking-Schutz und Fingerprinting
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "privacy.fingerprintingProtection" = true;
        
        # 3. HTTPS-Only Modus in allen Fenstern
        "dom.security.https_only_mode" = true;
        
        # 4. Telemetrie deaktivieren (für noch mehr Privatsphäre)
        "datareporting.healthreport.uploadEnabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.server" = "data:,";
        "toolkit.telemetry.archive.enabled" = false;

        # 5. Ecosia spezifische Tweaks (optional)
        "browser.search.official" = false; # Erlaubt eigene Engine-Settings
      };
    };
  };

  programs.git = {
    enable = true;
    signing.format = "openpgp"; # Oder null, je nachdem ob du GPG nutzt. Dies behebt die signing.format Warnung.
    settings = {
      user = {
        name = "embeddedDevices";
        email = "dgoetz@posteo.de";
      }; 

      init.defaultBranch = "main";
      # Automatische SSH-Konvertierung für GitHub-Links
      url."git@github.com:".insteadOf = "https://github.com/";
    }; 
  };

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh"; # Nutzt standardmäßig SSH für alle Operationen
      prompt = "enabled";
    };
  };
}
