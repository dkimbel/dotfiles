{ self, pkgs, nixpkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot = {
    # Specify that we have a LUKS encrypted partition.
    initrd.luks.devices = {
      root = {
        device = "/dev/nvme0n1p2";
        preLVM = true;
      };
    };
    # Use a newer-than-stable Linux kernel
    kernelPackages = pkgs.linuxPackages_5_10;
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        configurationLimit = 20;
        # Favor security over backwards compatibility
        # see nixpkgs/nixos/modules/system/boot/loader/systemd-boot/systemd-boot.nix
        editor = false;
        enable = true;
      };
    };
  };

  # Packages available by default for all users: essentials only
  environment.systemPackages = with pkgs; [
    git
    vim
  ];

  networking = {
    hostName = "p51";
    interfaces = {
      enp36s0.useDHCP = true;
      wlp0s20f3.useDHCP = true;
    };
    networkmanager.enable = true;
  };

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    package = pkgs.nixFlakes;
    # Pin the nixpkgs flake to the nixpkgs I'm using to build my system. For
    # more details, see the 'PINNING NIXPKGS' section near the end of
    # https://www.tweag.io/blog/2020-07-31-nixos-flakes
    registry.nixpkgs.flake = nixpkgs;
  };

  programs = {
    ssh.startAgent = true;
  };

  security = {
    hideProcessInformation = true;
    protectKernelImage = true;
  };

  services = {
    # Enable caps2esc, so Caps Lock key will map to ctrl when held and esc
    # when tapped
    interception-tools.enable = true;
  };

  system = {
    # add a "configurationRevision" key to the output of `nixos-version --json`,
    # with the flake's git commit hash as its value
    configurationRevision =
      if self ? rev
      then self.rev
      else throw "Git tree is dirty! Please stage and commit changes.";
    stateVersion = "20.09";
  };

  time.timeZone = "America/Phoenix";

  users.users.dk = {
    extraGroups = [ "wheel" "video" "audio" "disk" "networkmanager" ];
    # isNormalUser removes the need for createHome, group, and home settings
    isNormalUser = true;
    packages = with pkgs; [
      efibootmgr
      htop
      tree
      wget
      which
    ];
    uid = 1000;
  };

}
