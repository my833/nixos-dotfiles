{ pkgs, ... }:

{
  services.displayManager.ly.enable = true;

  environment.systemPackages = with pkgs; [
    hyprland
    hyprlock
    hypridle
    hyprpaper
    hyprpicker
    hyprpolkitagent
    hyprcursor
    waybar
  ];
  #programs.uwsm.enable = false;
}
