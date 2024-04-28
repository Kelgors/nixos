{pkgs, ...}: {
  home.packages = with pkgs; [
    makemkv
    handbrake
  ];
}
