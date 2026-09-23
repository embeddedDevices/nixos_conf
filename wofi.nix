{ config, pkgs, ... }:
{
  programs.wofi = {
    enable = true;
    
    settings = {
      allow_images = true;
      image_size = 28;
      width = 600;
      height = 400;
      location = "center";
      show = "drun";
      prompt = "Suchen...";
      # Sorgt dafür, dass es weich schließt und sich gut in Hyprland einfügt
      layer = "top"; 
      normal_window = true; 
    };

    # Das CSS für den abgerundeten Look
    style = ''
      window {
        margin: 0px;
        border: 1px solid #4c566a;
        background-color: rgba(30, 30, 46, 0.5); /* Leicht transparent und dunkel */
        border-radius: 15px; /* abgerundete Ecken */
        font-family: "Sans-Serif";
        font-size: 16px;
      }

      #input {
        margin: 10px;
        border: none;
        border-radius: 10px;
        background-color: rgba(255, 255, 255, 0.1);
        color: #cdd6f4;
        padding: 10px;
      }

      #inner-box {
        margin: 5px;
        border: none;
        background-color: transparent;
      }

      #outer-box {
        margin: 5px;
        border: none;
        background-color: transparent;
      }

      #text {
        margin: 5px;
        color: #cdd6f4;
      }

      #entry:selected {
        background-color: rgba(255, 255, 255, 0.15);
        border-radius: 10px;
        outline: none;
      }
    '';
  };
}
