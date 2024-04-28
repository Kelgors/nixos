{pkgs, ...}: {
  home.file.".local/share/fcd.sh".source = ./assets/fcd.sh;
  home.file.".local/bin/clean".source = ./assets/clean.sh;
  home.file.".local/bin/tma".source = ./assets/tma.sh;
  home.file.".local/bin/livegrep".source = ./assets/livegrep.sh;

  home.sessionPath = ["$HOME/.local/bin"];

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    dotDir = ".config/zsh";
    oh-my-zsh.enable = true;
    shellAliases = {
      ls = "eza";
      ll = "eza -l";
      lla = "eza -la";
      htop = "htop -u $USER";
      rm = "trash-put";
      rrm = "${pkgs.coreutils}/bin/rm";
      fcd = "source $HOME/.local/share/fcd.sh";
    };
  };
}
