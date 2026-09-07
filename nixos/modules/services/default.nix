# entry for all system service modules
{ ...  }:

{
  imports = [
    # ./ollama.nix
    # ./immich.nix
    ./caps2esc.nix
    ./openssh.nix
  ];
}
