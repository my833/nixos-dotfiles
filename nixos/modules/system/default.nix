{ pkgs, ... }:

{
  imports = [
    ./config.nix
    # ./overlays.nix
  ];

  boot.loader.grub = {
    enable = true;
    gfxmodeEfi = "text";
    splashImage = null;
    device = "nodev";
    useOSProber = true;
    efiSupport = true;
    extraConfig = ''
      terminal_output console
    ''; #  **** like debian GRUB_terminal=console
  };
  # boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Shanghai";

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      rime-data
      fcitx5-fluent
      fcitx5-gtk
      kdePackages.fcitx5-qt
      qt6Packages.fcitx5-configtool
      (fcitx5-rime.override {
        rimeDataPkgs = [
          pkgs.rime-ice
        ];
      })
    ];
  };
}
