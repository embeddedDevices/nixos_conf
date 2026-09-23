{ pkgs, ... }:
{
  # Claude Desktop selbst wird systemweit über das NixOS-Modul des Flakes
  # installiert (flake.nix -> programs.claude-desktop).
  # Hier nur die Tools für MCP-Server per stdio (npx/uvx), die über den
  # normalen PATH des Users gefunden werden.
  # ha-mcp (Home Assistant) wird per HTTP-URL angebunden, braucht kein lokales Tool.
  home.packages = with pkgs; [
    nodejs   # npx für stdio-MCP-Server
    uv       # uvx für Python-MCP-Server (z.B. mcp-proxy)
  ];

  # Hinweis: NIXOS_OZONE_WL=1 (configuration.nix) -> App läuft nativ unter Wayland.
  # Login-Tokens landen im Secret Service (gnome-keyring, über GNOME aktiv).
}
