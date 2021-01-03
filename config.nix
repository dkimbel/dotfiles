{ self, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        # Favor security over backwards compatibility
        # see nixpkgs/nixos/modules/system/boot/loader/systemd-boot/systemd-boot.nix
        editor = false;
      };
      efi.canTouchEfiVariables = true;
    };
    # Specify that we have a LUKS encrypted partition.
    initrd.luks.devices = {
      root = {
        device = "/dev/nvme0n1p2";
        preLVM = true;
      };
    };
  };

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
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  programs = {
    ssh.startAgent = true;
  };

  security = {
    hideProcessInformation = true;
    protectKernelImage = true;
  };

  services = {
    interception-tools.enable = true; # caps2esc
  };

  system = {
    autoUpgrade = {
      enable = true;
      allowReboot = true;
    };
    configurationRevision = pkgs.lib.mkIf (self ? rev) self.rev;
    stateVersion = "20.09";
  };

  time.timeZone = "America/Phoenix";

  users.users.dk = {
    createHome = true;
    extraGroups = [ "wheel" "video" "audio" "disk" "networkmanager" ];
    group = "users";
    home = "/home/dk";
    isNormalUser = true;
    uid = 1000;
    packages = with pkgs; [
      efibootmgr
      htop
      interception-tools # caps2esc
      tree
      wget
      which
    ];
  };

}
