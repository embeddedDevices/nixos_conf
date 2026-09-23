{ config, pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";
    plugins = [ pkgs.hyprlandPlugins.hyprexpo ];
    extraConfig = builtins.readFile ./hyprland.lua;
  };
}
