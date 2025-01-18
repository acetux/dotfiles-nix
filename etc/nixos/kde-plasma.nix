{ config, pkgs, ... }:

{
  services.desktopManager.plasma6.enable = true; # Runs on Wayland (kwayland/qtwayland) with XWayland enabled
  services.xserver.enable = false; # Makes sure X11 support is disabled
  #services.displayManager.defaultSession = "plasmax11"; #test if x11 support is enabled by default

  environment.plasma6.excludePackages = [
    #plasma-browser-integration
    #konsole
    #(lib.getBin qttools) # Expose qdbus in PATH
    #ark
    #elisa
    #gwenview
    #okular
    #kate
    #khelpcenter
    #dolphin
    #baloo-widgets # baloo information in Dolphin
    #dolphin-plugins
    #spectacle
    #ffmpegthumbs
    #krdp
    xwaylandvideobridge # This would expose Wayland windows to X11 for screen capture
  ];

  # Default:
  #services.displayManager = {
  #  sddm = {
  #    wayland.enable = true;
  #    theme = "breeze";
  #    #settings = { };
  #  };
  #};
}
