{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    gcc
  ];

#   # programs.neovim = {
#   #   enable = true;
#   #   viAlias = true;
#   #   vimAlias = true;
#   #   defaultEditor = true;
#   # };
}
