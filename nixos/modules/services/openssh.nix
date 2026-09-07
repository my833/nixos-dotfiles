{
  services.openssh = {
    enable = true;
    extraConfig = ''
      AcceptEnv COLORTERM
    '';
  };
}
