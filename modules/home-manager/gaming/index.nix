{pkgs, ...}: {
  imports = [
    ./minecraft.nix
    ./lutris.nix
  ];

  home.packages = with pkgs; [
    gamemode
    mangohud
  ];
}
