# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ #-- include the results of the hardware scan...
      #-- Hardware (hardware_thinkpad.nix) wird über die flake.nix geladen
      ./power.nix
    ];

  #- 1 -- BOOTLOADER & KERNEL
  #main configuration
  #--use the systemd-boot efi boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  #--use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  #- 2 -- NETWORK & LOCALISATION
  #-- hostname wird in der flake.nix gesetzt

  #--configure network connections interactively with nmcli or nmtui.
  #--& mac-randomization
  networking.networkmanager = {
    enable = true;
    wifi.macAddress = "stable"; # Generiert eine feste Fake-MAC pro WLAN
  };

  #-- Firewall: IPP (631) und mDNS (5353) für Drucken/Scannen, Tailscale
  networking.firewall = {
    enable = true;
    # Tailscale: Fix für das NixOS-Firewall-Routing mit Tailscale
    checkReversePath = "loose"; 
    # Tailscale: Direkte P2P-Verbindungen erzwingen willst (bessere Performance)
    allowedUDPPorts = [ 631 5353 config.services.tailscale.port ];
    # Ports fuer Drucker/CUPS
    allowedTCPPorts = [ 631 ];
  };

  #--set your time zone.
  time.timeZone = "Europe/Berlin";

  #--select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "de";
  #   useXkbConfig = true; # use xkb.options in tty.
  };

  #--hardware-bluetooth settings ---
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false; # true, Schaltet Bluetooth beim Hochfahren direkt an
  services.blueman.enable = true;         # Aktiviert das Applet für die Waybar

  #--nix-settings:
  #--set flakes environment & auto optimise
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
      #-- Binary-Cache für Noctalia (spart das lokale Kompilieren)
      extra-substituters = [ "https://noctalia.cachix.org" ];
      extra-trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
    };

    #--automatic storage cleaning
    #--gargabe collector
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d"; 
     };
  };

  #- 3 -- PROGRAMMS
  nixpkgs.config.allowUnfree = true;
  # dconf wird durch GNOME (services.desktopManager.gnome) bereits aktiviert

  #ZSH systemweit aktivieren
  programs.zsh.enable = true; 

  #--hyprland on system (activation)
  programs.hyprland.enable = true;

  #--niri (scrollendes Tiling) mit Noctalia Shell als dritte Session in GDM
  #--Konfiguration: niri.kdl / niri.nix, Shell: noctalia.nix (Home-Manager)
  programs.niri.enable = true;
  #--das niri-Modul setzt GDM-Default per mkDefault auf "niri"; GNOME bleibt Standard
  services.displayManager.defaultSession = "gnome";
  
  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
   environment.systemPackages = with pkgs; [
     #Standard-Tools
     vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     wget
   ];
  
  #-- xdg-desktop-portal: kommt automatisch über programs.hyprland (hyprland-Portal)
  #-- und GNOME (gnome- + gtk-Portal); Portal-Präferenzen stehen in home.nix

  #--fonts system: nerd fonts for waybar icons
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    inter
  ];
  
  #-- Qt-Theme (QT_QPA_PLATFORMTHEME) wird in home.nix über qt.platformTheme gesetzt

  #--environment variable for electron apps use wayland
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  #- 4 -- SERVICES
  #-- desktop environment
  #-- display manager & desktop environment 
  #-- kein eigener X-Server nötig: GNOME/GDM und Hyprland laufen unter Wayland,
  #-- X11-Apps laufen über XWayland. Das Tastaturlayout gilt trotzdem.
  services.xserver = {
    xkb.layout = "de";
    xkb.options = "eurosign:e,caps:escape";
  };

  # Gnome als Fallback/Alternative
  services.desktopManager.gnome.enable = true;
  # GDM Login-Bildschirm
  services.displayManager.gdm.enable = true;

  #-- GNOME-Dienste für Nautilus (gvfs, tinysparql, localsearch, gnome-keyring)
  #-- werden durch services.desktopManager.gnome bereits aktiviert.

  #-- POWER Setup for Monitor
  services.logind.settings = {
    # Neu: Statt extraConfig nutzen wir jetzt die strukturierte settings-API
    Login = {
      HandleLidSwitch = "ignore";
      HandleLidSwitchExternalPower = "ignore";
      HandleLidSwitchDocked = "ignore";
    };
  };

  #-- PRINTING
  #--enable cups to print documents.
  services.printing = {
   enable = true;  
   #printers special drivers
   drivers = [
     pkgs.gutenprint    # Generische Treiber für viele Modelle
     pkgs.gutenprint-bin # Manchmal notwendig für spezielle Canon/Epson Modelle
     pkgs.hplip         # WICHTIG: Für HP Drucker
     pkgs.brlaser       # Für Brother Laserdrucker
     pkgs.epson-escpr   # EPSON ET18-10 need mostly the ESC/P-R driver
   ];
   browsing = true;
   defaultShared = true;
  };

  #printers wlan connection 
  services.avahi = {
   enable = true;
   nssmdns4 = true; # Erlaubt Software, .local Domains aufzulösen
   openFirewall = true; # Öffnet Ports für die Drucker-Suche
  };

  #-- Sound: PipeWire
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  #-- Mullvad VPN Daemon
  services.mullvad-vpn = {
    enable = true;
    # pkgs.mullvad-vpn no longer bundles the daemon, only the GUI.
    # Use gui.enable instead of setting `package` to pkgs.mullvad-vpn.
    gui.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
   users.users.dennis = {
     isNormalUser = true;
     description = "Dennis";
     extraGroups = ["networkmanager" "wheel" "video" "audio" ]; # Enable ‘sudo’ for the user.
     shell = pkgs.zsh; #ZSH als Standard-Shell für meinen Benutzer festlegen.
     # Kein Passwort im (öffentlichen) Repo! Nach Neuinstallation setzen mit:
     #   sudo nixos-enter --root /mnt -c 'passwd dennis'
  };

  #-- Tailscale-Dienst
  #-- Das installiert auch automatisch das `tailscale` CLI-Tool systemweit.
  services.tailscale.enable = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?

}
