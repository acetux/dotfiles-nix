{ config, pkgs, ... }:

let
  unstable = import <nixos-unstable> { };
in

{
  imports =
    [
      ./gnome-polkit.nix # Polkit authenticator for GUI programs in Hyprland
      #./greetd.nix # Alternative to Ly for Hyprland
    ];

  environment.systemPackages = with pkgs; [
    terminator
    krusader

    waybar
    wpaperd
    rofi-wayland
    #rose-pine-cursor # Doesn't appear in nwg-look. "Installed" manually.
    playerctl
    #hyprpolkitagent # Polkit auth agent
    #lxqt.lxqt-policykit # Polkit auth agent
    #xdg-desktop-portal-hyprland # Gets installed when hyprland=enabled (https://wiki.hyprland.org/Hypr-Ecosystem/xdg-desktop-portal-hyprland/) (For copy-paste, screen-sharing, etc.)
    wl-clip-persist # Persists clipboard when the copied from program stops running

    # Dependencies for Mechabar (https://github.com/Sejjy/MechaBar):
    python3
    wlogout
    #networkmanager
  ];
  #security.soteria.enable = true; # Polkit auth agent
  programs.hyprlock.enable = true; # Sets up hyprlock with PAM support and hypridle
  #programs.waybar.enable = true; # This makes waybar appear duplicated because it creates a SystemD unit (Either enable this OR 'exec-once = waybar' in hyprland.conf)

  # Dependencies for Mechabar (https://github.com/Sejjy/MechaBar):
  fonts.packages = with pkgs; [
    unstable.nerd-fonts.jetbrains-mono # Remove "unstable." & "let unstable import" on line 3 when NixOS 25.05 is released
  ];

  programs.hyprland = {
    enable = true;
    #xwayland.enable = true; # Default: enable (XWayland is a compatibility layer that allows X11 applications to run on top of Wayland)
  };
  environment.sessionVariables.NIXOS_OZONE_WL = "1"; # Hint electron apps to use Wayland

  # Display Manager
  services.displayManager = {
    ly = {
      enable = true; #https://discourse.nixos.org/t/how-to-use-ly-display-manager/13753/10
      settings = { };
    };
  };

  # Media keyboard keys (Doesn't work - now implemented directly in Hyprland conf)
  #services.actkbd = {
  #  enable = true;
  #  bindings = [
  #    { keys = [ 172 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/playerctl play-pause"; }
  #    #{ keys = [ 114 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/runuser -l YOUR_USER -c 'amixer -q set Master 5%- unmute'"; }
  #    #{ keys = [ 115 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/runuser -l YOUR_USER -c 'amixer -q set Master 5%+ unmute'"; }
  #  ];
  #};
}
