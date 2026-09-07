# configure nixpkgs overlays (unstable packages, custom overlays, etc...)
{ inputs, ... }:

{
  nixpkgs.overlays = [
    (final: prev:
      let
        system = prev.stdenv.hostPlatform.system;
        unstable-pkgs = import inputs.nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
          config.allowUnsupportedSystem = true;
        };
      in
      {
        # inherit (unstable-pkgs) ;
        unstable = unstable-pkgs;
      }
    )
  ];
}
