# NixOS Configuration file
# Help is available in the configuration.nix(5) man page and in the NixOS manual (accessible by running 'nixos-help').

{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix # Include the results of the hardware scan.
      ./hyprland.nix
      #./kde-plasma.nix
      ./fetches.nix
      #./tmp-programs.nix
    ];

  # List packages installed in system profile. To search, run 'nix search wget'
  environment.systemPackages = with pkgs; [
    # GUI PROGRAMS
    kitty
    firefox
    mullvad-browser
    thunderbird
    libreoffice
    vscodium # electron | If buggy: vscodium-fhs
    #threema-desktop # electron | Is outdated and just threema-web in electron
    signal-desktop # electron
    mumble
    #armcord/webcord/(vesktop) # FOSS Discord Client
    pavucontrol
    easyeffects
    #helvum
    spotify # unfree, electron
    tradingview # unfree, electron
    lutris

    # CLI PROGRAMS
    wget
    mtr
    htop
    (btop.override { rocmSupport = true; }) # btop with AMD GPU monitoring support (https://github.com/NixOS/nixpkgs/pull/296468#issuecomment-2304572044)
    iotop-c
    #mc # Midnight Commander | Alternatives: yazi/nnn/lf/ranger
    vim
    #neovim
    git
    unzip
    nvd # Diff for Nix Upgrades

    # SYSTEM CONTROL
    openrgb # https://wiki.nixos.org/wiki/OpenRGB
    #coolercontrol
    mangohud # Alternative: goverlay

    # MISC
    #fish # Shell
    #starship # Shell Prompt
    nixpkgs-fmt # Nix code formatter for nixpkgs (needed for vscodium .nix formatting)
    #flameshot # Doesn't support Wayland yet
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest; # Use latest stable Linux kernel

  programs.steam = {
    enable = true; # unfree, X11, 32bit
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  services.hardware.openrgb.enable = true; # https://wiki.nixos.org/wiki/OpenRGB
  services.fwupd.enable = true;
  #services.openssh.enable = true; # Enable the OpenSSH daemon.

  nixpkgs.config.allowUnfree = true;
  #nixpkgs.config.rocmSupport = true; # Enable support for AMD ROCm config wide (https://github.com/NixOS/nixpkgs/pull/296468#issuecomment-2304572044)

  programs.bash = {
    shellAliases = {
      # 'alias' to check active aliases
      ls = "ls --color=tty";
      ll = "ls -lah";
      l = "ll";
      mv = "mv -i";
      du = "du -ah --max-depth=1 --threshold=4100";
      dotf = "git --git-dir=$HOME/git-repos/dotfiles-nix.git/ --work-tree=/";
    };
  };

  networking.firewall = {
    #enable = false;
    # Open ports:
    #allowedTCPPorts = [ ... ];
    #allowedUDPPorts = [ ... ];
  };

  # GRAPHICS
  programs.gamemode.enable = true; # Enable GameMode to optimise system performance on demand.
  hardware.amdgpu.opencl.enable = true; # Enable OpenCL support using ROCM runtime library.
  hardware.graphics = {
    enable = true; # Enables OpenGL (and possibly Vulkan (Mesa RADV), might be independently enabled by default now)
    enable32Bit = true; # Enables OpenGL for 32 bit apps (and possibly Vulkan (Mesa RADV) for 32 bit apps, might be independently enabled by default now)
    extraPackages = with pkgs; [
      amdvlk # Enables AMDVLK in addition to the Mesa RADV drivers. The program will choose which one to use.
      vulkan-volk # Can increase performance by skipping loader dispatch overhead.
      # Fixes some Vulkan apps (https://www.reddit.com/r/NixOS/comments/17i7zeb/comment/kpjmmqu/):
      vulkan-loader
      vulkan-validation-layers
      vulkan-extension-layer
    ];
    extraPackages32 = with pkgs; [
      driversi686Linux.amdvlk # Enables AMDVLK for 32 bit apps in addition to the Mesa RADV drivers. The program will choose which one to use.
    ];
  };
  #boot.initrd.kernelModules = [ "amdgpu" ]; # Slows down boot by about 3 seconds
  #boot.kernelParams = [
  #  "video=DP-2:3440x1440@175" # Doesn't improve resolution
  #];

  # Garbage collection
  nix.gc = {
    automatic = true; # 'sudo nix-collect-garbage --delete-older-than 7d' Find result files which prevent garbage collection: 'nix-store --gc --print-roots'
    persistent = true;
    dates = "03:00";
    options = "--delete-older-than 7d";
  };

  # Optimise Store (hardlinking files)
  nix.optimise = {
    automatic = true; # 'sudo nix-store --optimise -vv' This option only applies to new files, so we recommend manually optimising your nix store when first setting this option.
    dates = [ "03:15" ];
  };

  # Periodically issue TRIM commands. Continous TRIM is not recommended: (https://wiki.archlinux.org/title/Solid_state_drive#TRIM)
  # The service executes fstrim(8) on all mounted filesystems on devices that support the discard operation.
  services.fstrim = {
    enable = true; # 'sudo fstrim -av'
    interval = "weekly"; # Check history: 'sudo journalctl -u fstrim.service'
  };

  # Disable setting access times on files and dirs to improve SSD lifespan and performance:
  fileSystems."/".options = [ "noatime" "nodiratime" ]; # Can cause issues with some programs (https://stackpointer.io/unix/linux-io-performance-tuning-noatime-nodiratime-relatime/388/)

  # SOUND
  # Remove sound.enable or set it to false if you had it set previously, as sound.enable is only meant for ALSA-based configurations
  security.rtkit.enable = true; # Optional but recommended
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  security.polkit.enable = true; # Framework for programs to request sudo authentication

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.acetux = {
    isNormalUser = true;
    description = "acetux";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ ];
  };

  networking = {
    hostName = "nix-acetux-01"; # Define your hostname.
    networkmanager.enable = true; # Enable networking non-declaratively via NetworkManager
    wireless.enable = false; # Wireless support via wpa_supplicant
  };

  fonts.packages = with pkgs; [
    # List font packages here
  ];
  #fonts.fontconfig.antialias = false; # Disable Font anti-aliasing

  # LOCALE
  time.timeZone = "Europe/Zurich";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_CH.UTF-8";
    LC_IDENTIFICATION = "de_CH.UTF-8";
    LC_MEASUREMENT = "de_CH.UTF-8";
    LC_MONETARY = "de_CH.UTF-8";
    LC_NAME = "de_CH.UTF-8";
    LC_NUMERIC = "de_CH.UTF-8";
    LC_PAPER = "de_CH.UTF-8";
    LC_TELEPHONE = "de_CH.UTF-8";
    LC_TIME = "de_CH.UTF-8";
  };
  # Configure keymap in X11
  #services.xserver.xkb = {
  #  layout = "ch";
  #  variant = "";
  #};
  console = {
    keyMap = "sg"; # Configure console keymap ('sg' = Swiss German)
    # Doesn't work correctly, font at end of Stage 2 and TTY Font reset to default after reboot:
    #earlySetup = true; # Enable setting virtual console options as early as possible (in initrd).
    #font = "${pkgs.tamzen}/share/consolefonts/Tamzen10x20.psf"; # (https://www.reddit.com/r/NixOS/comments/qnk89n/comment/j9b9xy0) | Find font location to list them: 'nix-index' 'nix-locate Lat2-Terminus16'
  };

  boot.loader = {
    timeout = 3;
    efi.canTouchEfiVariables = true;
    systemd-boot = {
      enable = true;
      editor = false; # Whether to allow editing the kernel command-line before boot. It is recommended to set this to false, as it allows gaining root access by passing init=/bin/sh as a kernel parameter. However, it is enabled by default for backwards compatibility.
      configurationLimit = 10; # Maximum number of latest generations in the boot menu. Useful to prevent boot partition running out of disk space.
      consoleMode = "max"; # Set max supported resolution
    };
  };
  #boot.initrd.systemd.enable = true; # SystemD as PID1 for faster Plymouth and TTY resolution initialization (https://www.reddit.com/r/NixOS/comments/qnk89n/comment/j9b9xy0)
  #boot.consoleLogLevel = 4; # Default. Kernel console log level

  # Configure network proxy if necessary:
  #networking.proxy.default = "http://user:password@proxy:port/";
  #networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}