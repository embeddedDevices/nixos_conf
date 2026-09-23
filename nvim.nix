{ config, pkgs, ... }:
{

  programs.nixvim = {
    enable = true;
    defaultEditor = true; # Macht Neovim zum Standard für 'git commit' etc.

    # --- Optik & Komfort ---
    colorschemes.catppuccin.enable = true;
    opts = {
      number = true;         # Zeilennummern
      relativenumber = true; # Relative Nummern für schnelles Springen
      shiftwidth = 2;        # 2 Leerzeichen Einrückung
      tabstop = 2;
      expandtab = true;      # Tabs zu Leerzeichen
      mouse = "a";           # Mausunterstützung an
      ignorecase = true;     # Groß-/Kleinschreibung beim Suchen ignorieren
      smartcase = true;
    };

    # --- Plugins (Die "Magie") ---
    plugins = {
      # Schicke Statuszeile unten
      lualine.enable = true;

      # Syntax Highlighting via Treesitter
      treesitter.enable = true;

      # Datei-Explorer (Seitenspalte)
      neo-tree.enable = true;

      # Web Devicons
      web-devicons.enable = true;

      # LSP (Intelligente Code-Hilfe)
      lsp = {
        enable = true;
        servers = {
          nil_ls.enable = true;    # Hilfe für Nix-Dateien
          bashls.enable = true;    # Hilfe für Bash-Scripte
          rust_analyzer = {
            enable = true; # Hilfe für Rust
            installCargo = true;
            installRustc = true;
          };
        };
      };

      # Teleskop (Der ultimative Alles-Finder)
      telescope = {
        enable = true;
        keymaps = {
          "<leader>ff" = "find_files";
          "<leader>fg" = "live_grep";
        };
      };

      # Autovervollständigung (Popups während des Tippens)
      cmp = {
        enable = true;
        settings.autoEnableSources = true;
        settings.sources = [
          { name = "nvim_lsp"; }
          { name = "path"; }
          { name = "buffer"; }
        ];
        settings.mapping = {
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<Tab>" = "cmp.mapping.select_next_item()";
        };
      };
    };

    # --- Eigene Keymaps ---
    keymaps = [
      {
        mode = "n";
        key = "<C-n>";
        action = "<cmd>Neotree toggle<CR>";
        options.desc = "Dateibaum umschalten";
      }
    ];
  };
}
