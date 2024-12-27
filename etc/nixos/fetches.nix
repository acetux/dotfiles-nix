{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    #archey4 (https://github.com/HorlogeSkynet/archey4)
    #screenfetch
    #neofetch
    fastfetch
    #macchina
    #nerdfetch
    #fet-sh
    nitch
    #pfetch-rs #pfetch
    #afetch
    #bfetch

    #cpufetch
    #ghfetch
    #onefetch
  ];
}
