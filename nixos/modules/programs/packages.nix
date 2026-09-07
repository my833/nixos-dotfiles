# configure system-wide user-facing packages
{ pkgs, pkgsUnstable, ... }:

{
  environment.systemPackages = (with pkgs; [
    bibata-cursors
    wget
    curl
    neovide
    git
    git-lfs
    foot
    nil
    nixfmt
    lua-language-server
    tmux

    zip
    xz
    unzip
    p7zip

    # utils
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processor https://github.com/mikefarah/yq
    # eza # A modern replacement for ‘ls’
    fzf # A command-line fuzzy finder
    fd

    dnsutils # `dig` `dnslookupu`
    aria2
    socat

    file
    which
    tree

    #gcc
    gdb
    gnumake
    python3
    luaPackages.tree-sitter-cli

    btop  # replacement of htop/nmon
    iotop # io monitoring
    iftop # network monitoring

    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files
  ]) ++ (with pkgsUnstable; [
    emacs
    v2rayn
  ]);

  programs = {
    firefox.enable = true;

    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };

    gamemode.enable = false;
  };

  # environment.variables = {
  #   VAR1 = "a";
  # };
}
