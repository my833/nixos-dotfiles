{ pkgs, ... }:

let
  myfont = pkgs.stdenvNoCC.mkDerivation {
    pname = "my-font";
    version = "0.0.1";

    src = pkgs.fetchurl {
      url = "https://gh-proxy.org/https://github.com/laishulu/Sarasa-Term-SC-Nerd/releases/download/v2.3.1/SarasaTermSCNerd-Unhinted.ttf.7z";
      hash = "sha256-K2slWXl1EK225hwykyaOtJ4/D9S1LuY4rwSyUX/Y5h4=";
    };

    dontUnpack = true;

    nativeBuildInputs = [
      pkgs.p7zip
    ];

    installPhase = ''
      mkdir -p $out/share/fonts/SarasaTermSCNerd-Unhinted
      7z x $src -o./font-src

      find ./font-src -type f \( \
        -iname "*.ttf" -o \
        -iname "\*.otf" \
      \) -exec cp {} $out/share/fonts/SarasaTermSCNerd-Unhinted/ \;
    '';
  };
in
{
  home.packages = [
    myfont
  ];
}
