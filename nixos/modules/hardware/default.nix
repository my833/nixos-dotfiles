# entry point for all hardware-related configuration modules (graphics, bluetooth, hardware-related, ...)
{ ... }:

{
  imports = [
    ./audio.nix
    ./graphics.nix
    ./bluetooth.nix
    # ./swap.nix
    ./thermald.nix
  ];
}
