{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    # Der Wayland Wallpaper Daemon
    awww 

    # Unser selbst geschriebenes Script zum Wechseln
    (writeShellScriptBin "next-wallpaper" ''
      # 1. Definiere den Ordner (Achte darauf, dass er genau so heißt!)
      DIR="$HOME/Pictures/wallpapers"
      
      # Prüfen, ob der Ordner existiert
      if [ ! -d "$DIR" ]; then
        echo "Ordner $DIR existiert nicht!"
        exit 1
      fi

      # Alle Dateien im Ordner in ein Array laden
      FILES=("$DIR"/*)
      
      # Das aktuelle Wallpaper aus dem Cache auslesen
      CURRENT=$(cat ~/.cache/current_wallpaper 2>/dev/null || echo "")

      # Suchen, an welcher Stelle im Ordner wir gerade sind
      INDEX=-1
      for i in "''${!FILES[@]}"; do
        if [[ "''${FILES[$i]}" == "$CURRENT" ]]; then
          INDEX=$i
          break
        fi
      done

      # Den Index um 1 erhöhen (und wieder bei 0 anfangen, wenn am Ende)
      NEXT_INDEX=$(( (INDEX + 1) % ''${#FILES[@]} ))
      NEXT_IMAGE="''${FILES[$NEXT_INDEX]}"

      # Bild mit awww setzen (mit coolem Wisch-Übergang!)
      awww img "$NEXT_IMAGE" --transition-type wipe --transition-duration 1.5
      
      # Das neue Bild für das nächste Mal abspeichern
      echo "$NEXT_IMAGE" > ~/.cache/current_wallpaper
    '')
  ];
}
