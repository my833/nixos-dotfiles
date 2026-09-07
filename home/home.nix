{ config, username, homeStateVersion, ... }:

let
  dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/home/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

  # Standard .config/directory
  configs = {
    dunst = "dunst";
    foot = "foot";
    hypr = "hypr";
    neovide = "neovide";
    nvim = "nvim";
    rofi = "rofi";
    waybar = "waybar";
  };
in

{
  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = homeStateVersion;
  };

  xdg.configFile = builtins.mapAttrs (name: subpath: {
    source = create_symlink "${dotfiles}/${subpath}";
    recursive = true;
  }) configs;

  # home.file.".local/share/fonts/SarasaTermSCNerd-Unhinted".source =
  #   create_symlink "${dotfiles}/fonts/SarasaTermSCNerd-Unhinted";

  imports = [
    ./modules/myfont.nix
  ];

  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
      nrs = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#nmachine";
      ll = "ls -l";
      la = "ls -a";
      ".." = "cd ..";
      "..." = "cd ../..";
    };
    initExtra = ''
      export PS1="[\e[38;5;75m\#@\t\e[0m] \w\n\$ "
    '';
  };
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "fake";
        email = "fake@fake.com";
      };
      alias = {
        ci = "commit";
        co = "checkout";
        st = "status";
        br = "branch";
        pl = "pull";
      };
    };
  };
}
