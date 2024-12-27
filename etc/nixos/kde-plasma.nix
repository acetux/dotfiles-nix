{ config, pkgs, ... }:

{
  services.desktopManager.plasma6.enable = true;

  services.displayManager = {
    sddm = {
      wayland.enable = true;
      #theme = "";
      #settings = { };
    };
  };
}
