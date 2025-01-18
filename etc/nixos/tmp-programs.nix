{ config, pkgs, ... }:

# RUN THESE PROGRAMS WITH 'nix-shell -p <pkg>'

{
  environment.systemPackages = with pkgs; [
    # GUI PROGRAMS
    nwg-look
    mission-center # Win11 like top (taskmanager)
    superTuxKart

    # CLI PROGRAMS
    wev # Analyze key presses in Wayland (X11 = xev)
    xorg.xlsclients # (xlsclients) List programs running on XWayland
    zfxtop # htop for zoomers
    smartmontools # 'sudo smartctl -a /dev/nvme0n1'
    gnome-firmware # fwupd GUI

    # CPU management tools
    cpupower-gui

    # AMD GPU Monitoring
    nvtopPackages.amd
    radeontop
    amdgpu_top
    rgp
    lact # https://wiki.nixos.org/wiki/AMD_GPU#LACT_-_Linux_AMDGPU_Controller

    # Nvidia GPU Monitoring
    nvtopPackages.nvidia
    nvitop

    # GPU Benchmarking and graphics drivers testing tools
    vulkan-tools # 'vulkaninfo --summary' / 'vkcube'
    vulkan-caps-viewer # Vulkan hardware capability viewer
    phoronix-test-suite
    passmark-performancetest # Unfree
    geekbench # unfree
    furmark # Unfree OpenGL and Vulkan Benchmark and Stress Test
    unigine-heaven # unfree
    unigine-superposition # unfree
    mesa-demos # 'glxinfo -B' | Collection of demos and test programs for OpenGL and Mesa
    piglit # OpenGL test suite, and test-suite runner (unsure if this works)
    clinfo # OpenCL info
    clpeak # OpenCL benchmark
    vdpauinfo # Tool to query the Video Decode and Presentation API for Unix (VDPAU) abilities of the system
    libva-utils # 'vainfo' | Collection of utilities and examples to exercise VA-API in accordance with the libva project.
    x86info # Identification utility for the x86 series of processors
  ];
}
