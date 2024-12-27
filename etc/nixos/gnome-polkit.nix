# Polkit auth agent used for Hyprland

# unit gets created here:
# /etc/systemd/user/polkit-gnome-authentication-agent-1.service

#systemctl status --user polkit-gnome-authentication-agent-1.service

{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    polkit_gnome
  ];

  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
}
