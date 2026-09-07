{ config, lib, pkgs, username, hostname, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = hostname;

  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Shanghai";

  services.displayManager.ly.enable = true;
  services.xserver = {
    enable = true;
    autoRepeatDelay = 200;
    autoRepeatInterval = 35;
  };
  services.openssh = {
    enable = true;
    extraConfig = ''
      AcceptEnv COLORTERM
    '';
  };
  services.interception-tools =
    let
      itools = pkgs.interception-tools;
      itols-caps = pkgs.interception-tools-plugins.caps2esc;
    in
    {
      enable = true;
      plugins = [ itols-caps ];
      udevmonConfig = pkgs.lib.mkDefault ''
        - JOB: "${itools}/bin/intercept -g $DEVNODE | ${itols-caps}/bin/caps2esc | ${itools}/bin/uinput -d $DEVNODE"
          DEVICE:
            EVENTS:
              EV_KEY: [KEY_CAPSLOCK, KEY_ESC]
      '';
    };


  users.users.${username}= {
    isNormalUser = true;
    extraGroups = [ "wheel" "uinput" ];
    packages = with pkgs; [
      tree
    ];
  };

  programs.firefox.enable = true;
  programs.hyprland.enable = true;
  # programs.niri.enable = true;
  programs.waybar.enable = true;

  security.polkit.enable = true;

  environment.systemPackages = with pkgs; [
    git
    vim
    neovim
    luaPackages.tree-sitter-cli
    wget
    foot
    fuzzel
    xwayland-satellite
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.substituters = [ "https://mirrors.ustc.edu.cn/nix-channels/store" "https://cache.nixos.org" ];
  system.stateVersion = "26.05";

}

