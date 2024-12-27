# https://github.com/sjcobb2022/nixos-config/blob/main/hosts/common/optional/greetd.nix

{ pkgs, ... }:

{
  services.greetd = {
    enable = true;
    #package = pkgs.greetd.tuigreet; # Unnecessary
    settings = {
      default_session = {
        #command = "${pkgs.greetd.greetd}/bin/agreety --cmd hyprland"; # greetd
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --remember-session --cmd hyprland"; # tuigreet (https://github.com/apognu/tuigreet/blob/master/README.md#from-nixos)
        #user = "greeter"; # Default
      };
    };
  };

  # https://www.reddit.com/r/NixOS/comments/u0cdpi/tuigreet_with_xmonad_how/
  # This is a life saver
  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal"; # Without this errors will spam on screen
    # Without these bootlogs will spam on screen
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };
}
