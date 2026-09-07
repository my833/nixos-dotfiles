{ config, pkgs, pkgs-unstable, username, ... }:

let
  dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

  configs = {
    nvim = "nvim";
    # git = "git";
    rofi = "rofi";
  };
in

{
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "26.05";
  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo i use nixos";
      nrs = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#nmachine";
      vi = "nvim";
    };
    initExtra = ''
      export PS1="\e[38;5;75m[\#@\t]\e[0m \w\n\$ "
    '';
  };
  # programs.git.enable = true;
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
        pl = "pull";
        br = "branch";
      };
      core = {
        editor = "nvim";
      };
    };
  };
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };

  xdg.configFile = builtins.mapAttrs
    (name: subpath: {
      source = create_symlink "${dotfiles}/${subpath}";
      recursive = true;
    })
    configs;

  home.packages = with pkgs; [
    file
    ripgrep
    nil
    nixfmt
    gcc
    rofi
    lua-language-server
    fd
    libtool
  ];
}
