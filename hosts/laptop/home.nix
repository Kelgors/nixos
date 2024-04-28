{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../modules/home-manager/terminal/index.nix
    ../../modules/home-manager/browser/chromium.nix
    ../../modules/home-manager/dev/vscode.nix
    ../../modules/home-manager/gaming/minecraft.nix
  ];
  home.username = "kelgors";
  home.homeDirectory = "/home/kelgors";
  home.stateVersion = "23.11"; # Please read the comment before changing.

  home.packages = with pkgs; [
    # obsidian (Electron version 25.9.0 is EOL)
    synology-drive-client
    virt-viewer
  ];

  home.file = {};
  home.sessionVariables = {};

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
