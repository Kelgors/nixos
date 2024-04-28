{pkgs, ...}: {
  programs.chromium = {
    enable = true;
    commandLineArgs = [];
    dictionaries = [
      pkgs.hunspellDictsChromium.en_US
    ];
    extensions = [
      {id = "aeblfdkhhhdcdjpifhhbdiojplfjncoa";}
    ];
  };
}
