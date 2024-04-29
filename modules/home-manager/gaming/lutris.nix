{pkgs, ...}: {
  home.packages = with pkgs; [
    (
      pkgs.symlinkJoin {
        name = "lutris";
        paths = [
          (pkgs.lutris.override {
            extraPkgs = pkgs: [
              winePackages.stable
              wine64Packages.stable
              winetricks
            ];
          })
        ];
        buildInputs = [pkgs.makeWrapper];
        ## https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/setup-hooks/make-wrapper.sh
        # Fix GOG login webview blank by disabling compositing
        postBuild = ''
          wrapProgram $out/bin/lutris \
            --set WEBKIT_DISABLE_COMPOSITING_MODE 1
        '';
      }
    )
  ];
}
