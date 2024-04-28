# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/nixos/kernel.nix
    ../../modules/nixos/nvidia.nix
    ../../modules/nixos/sound.nix
    ../../modules/nixos/locale.nix
  ];

  # Define your hostname.
  networking.hostName = "Kelgors-Desktop";
  # Enable flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enables wireless support via wpa_supplicant.
  networking.wireless.enable = false;
  # Enable networking
  networking.networkmanager.enable = true;
  # Enable CUPS to print documents.
  services.printing.enable = false;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "kelgors";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kelgors = {
    isNormalUser = true;
    description = "";
    extraGroups = ["networkmanager" "wheel"];
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {
      "kelgors" = import ./home.nix;
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    wget
    unzip
    xsel
  ];

  programs.steam.enable = true;

  # List services that you want to enable:
  systemd.user.timers."trash-cli" = {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "Thu *-*-* 0:*:*";
      Persistent = true;
    };
  };

  systemd.user.services."trash-cli" = {
    script = "${pkgs.trash-cli}/bin/trash-cli 3";
    serviceConfig = {
      Type = "oneshot";
      User = "kelgors";
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
