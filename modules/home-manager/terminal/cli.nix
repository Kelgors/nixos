{pkgs, ...}: {
  home.packages = with pkgs; [
    bat
    eza
    ripgrep
    fd
    fzf
    stow
    trash-cli
    htop
  ];
}
