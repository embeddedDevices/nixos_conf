{
  description = "Meine NixOS Flake Konfiguration mit Home-Manager und NixVim-Projekt";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #-- Das Nixvim-Projekt
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hyprexpo Plugin (community fork; the official hyprwm/hyprland-plugins
    # repo retired hyprexpo, so it's no longer in nixpkgs' hyprlandPlugins)
    hyprexpo-src = {
      url = "github:sandwichfarm/hyprexpo";
      flake = false;
    };

    # Claude Desktop: offizielles Linux-Build von Anthropic (.deb aus dem
    # Anthropic-APT-Repo), umgepackt für den Nix-Store. Cowork & Claude Code inklusive.
    # nixpkgs.follows: Mesa/glibc kommen aus demselben nixpkgs wie das System.
    claude-desktop = {
      url = "github:nmcbride/claude-desktop-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Noctalia Shell (v5) für niri. Bewusst OHNE nixpkgs.follows, damit die
    # vorgebauten Pakete aus dem Cachix-Cache (configuration.nix) passen.
    noctalia = {
      url = "github:noctalia-dev/noctalia";
    };
  };

  outputs = { self, nixpkgs, home-manager, nixvim, hyprexpo-src, claude-desktop, noctalia, ... }@inputs:
  let
    # Builds hyprexpo against OUR pinned hyprland/nixpkgs (plugins are ABI-sensitive,
    # so it must be built against the exact hyprland revision that will load it).
    hyprexpoOverlay = final: prev: {
      hyprlandPlugins = (prev.hyprlandPlugins or { }) // {
        hyprexpo = final.callPackage hyprexpo-src { };
      };
    };
  in {
    nixosConfigurations = {

      # --- THINKPAD ---
      nixDennis = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hardware_thinkpad.nix  # Thinkpad-Hardware
          ./configuration.nix      # Programme und Settings
          home-manager.nixosModules.home-manager
          claude-desktop.nixosModules.default
          {
            nixpkgs.overlays = [ hyprexpoOverlay ];

            #-- Claude Desktop (offizielles Linux-Build, siehe inputs)
            programs.claude-desktop = {
              enable = true;
              # Electron erkennt niri/Hyprland nicht als Desktop und würde den
              # Login nur unverschlüsselt ("basic text") speichern -> Secret
              # Service (gnome-keyring) über libsecret erzwingen.
              package = claude-desktop.packages.x86_64-linux.default.override {
                commandLineArgs = "--password-store=gnome-libsecret";
              };
              # Cowork (Agent-Sandbox als QEMU-Micro-VM): braucht /dev/kvm,
              # OVMF-Firmware + virtiofsd unter FHS-Pfaden und vhost_vsock.
              # Das Modul richtet alles ein; kvm-Gruppe wird erst nach
              # Re-Login wirksam. Auf false setzen, wenn Cowork nicht gewünscht.
              cowork.enable = true;
              cowork.kvmUsers = [ "dennis" ];
            };

            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            #-- reicht die Flake-inputs an die Home-Manager-Module weiter
            home-manager.extraSpecialArgs = { inherit inputs; };

            #-- Home-Manager für dennis inkl. Nixvim-Modul
            home-manager.users.dennis = {
              imports = [
                nixvim.homeModules.nixvim  # Macht "programs.nixvim" verfügbar
                noctalia.homeModules.default # Macht "programs.noctalia" verfügbar
                ./home.nix
              ];
            };

            networking.hostName = "nixDennis";
          }
        ];
      };

    };
  };
}
