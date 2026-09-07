{ pkgs, stateVersion, hostname, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
      ./local-packages.nix

      ../../nixos/modules/hardware
      ../../nixos/modules/system
      ../../nixos/modules/users
      ../../nixos/modules/programs
      ../../nixos/modules/services

      ../../nixos/modules/desktop/hyprland.nix
    ];

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = [ pkgs.home-manager ];
  networking.hostName = hostname;

  system.stateVersion = stateVersion;
}
