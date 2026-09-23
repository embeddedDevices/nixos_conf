{ config, pkgs, ... }:
{
  #-- GENERELLE LAPTOP ENERGIE-OPTIMIERUNG
  # Aktiviert upower (Wichtig für die exakte Akku-Anzeige in der Waybar!)
  services.upower.enable = true;

  # dieser kleine Service wird abgeschaltet, weil doppelte Funktion
  services.power-profiles-daemon.enable = false;

  # Intelligente CPU-Taktung (auto-cpufreq)
  # Taktet den Prozessor im Akkubetrieb runter und am Stromkabel hoch
  services.auto-cpufreq = {
    enable = true;
    settings = {
      battery = {
        governor = "powersave";
        turbo = "never";
      };
      charger = {
        governor = "performance";
        turbo = "auto";
      };
    };
  };
}
