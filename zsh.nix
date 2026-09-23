{ config, pkgs, ... }:
{
  #zsh: fzf - Der Fuzzy Finder
  programs.fzf = {
      enable = true;
      enableZshIntegration = true;
  };

  #zsh: zoxide - Das smartere "cd"
  programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [
        "--cmd cd" # Ersetzt das Standard 'cd' direkt durch zoxide (optional, aber praktisch)
      ];
  };

  #zsh: eza - Der moderne "ls" Ersatz
  programs.eza = {
      enable = true;
      enableZshIntegration = true;
      icons = "auto"; # Zeigt Datei-Icons an (braucht Nerd Fonts, die wir ja schon haben!)
      git = true;     # Zeigt Git-Status in der Listenansicht
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # Powerlevel10k als Plugin laden
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];

    # Shell-Aliase (Abkürzungen)
    shellAliases = {
      v = "nvim";
      #ll = "ls -l";
      ls = "eza";
      ll = "eza -l";
      la = "eza -la";
      lt = "eza --tree"; # Zeigt Ordner als Baumstruktur an
      #update = "sudo nixos-rebuild switch --flake .#nixDennis";
      ts = "tailscale status";
      tup = "sudo tailscale up";
      tdown = "sudo tailscale down";
    };

    # Konfiguration für Oh My Zsh (optional)
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" ];
      #theme = "powerlevel10k"; # Oder ein anderes Theme deiner Wahl
      #jonathan: a good theme with a line between commands
      #agnoster: A powerline-style theme that shows Git status.
      #robbyrussell: The default theme, simple and clean.
      #powerlevel10k: A highly customizable theme that’s visually stunning.

    };

    # Zusätzliche Einstellungen für die .zshrc
    initContent = ''
      # EDITOR=nvim kommt über programs.nixvim.defaultEditor (nvim.nix)
      # Powerlevel10k Konfiguration einbinden
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    '';
  };
}
