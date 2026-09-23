{ config, lib, pkgs, ... }:

{
  programs.wlogout = {
    enable = true;

    # 1. Layout: Welche Buttons sollen angezeigt werden?
    layout = [
      { label = "lock"; action = "hyprlock"; text = "lock"; keybind = "l"; }
      { label = "logout"; action = "sh -c \"command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'\""; text = "logout"; keybind = "e"; }
      { label = "shutdown"; action = "systemctl poweroff"; text = "shutdown"; keybind = "s"; }
      { label = "suspend"; action = "systemctl suspend"; text = "suspend"; keybind = "u"; }
      { label = "reboot"; action = "systemctl reboot"; text = "reboot"; keybind = "r"; }
    ];

    # 2. Styling im Catppuccin Mocha Design
    style = ''
      * {
          background-image: none;
          font-family: "Fira Code", "Noto Sans", sans-serif;
          font-size: 20px;
      }

      /* Der halbtransparente, dunkle Hintergrund */
      window {
          background-color: rgba(30, 30, 46, 0.6); /* Catppuccin Base mit 60% Deckkraft */
      }

      button {
          /* color: #cdd6f4; */
          color: transparent;
          background-color: rgba(49, 50, 68, 0.8); /* Catppuccin Surface0 */
          border: 2px solid rgba(180, 190, 254, 0.5); /* Lavender Akzent, halbtransparent */
          border-radius: 20px;
          margin: 20px;
          box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.4);
          
          /* Standard-Icons von wlogout laden und zentrieren */
          background-repeat: no-repeat;
          background-position: center;
          background-size: 25%;

          padding-top: 0px;
      }

      /* Hover-Effekt: Wenn man mit der Maus drüberfährt */
      button:focus, button:active, button:hover {
          background-color: rgba(180, 190, 254, 0.2); /* Leichtes Lavender als Hintergrund */
          border: 2px solid #b4befe; /* Lavender Rahmen voll sichtbar */
          outline-style: none;
      }

      /* Verknüpfung der Icons (wlogout bringt diese standardmäßig mit) */
      #lock { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/lock.png")); }
      #logout { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/logout.png")); }
      #suspend { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/suspend.png")); }
      #shutdown { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/shutdown.png")); }
      #reboot { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/reboot.png")); }
    '';
  };
}
