# configure swap space using a swap file on the SSD.
{ ... }:

{
  swapDevices = [
    { device = "/swapfile"; size = 16 * 1024; } # 16GB swap file
  ];
}
