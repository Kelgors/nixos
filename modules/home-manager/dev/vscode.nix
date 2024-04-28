{pkgs, ...}: {
  home.packages = with pkgs; [
    alejandra
    nodenv
    rustup
  ];

  programs.vscode = {
    enable = true;
    enableExtensionUpdateCheck = true;
    enableUpdateCheck = false;
    mutableExtensionsDir = true;
    extensions = with pkgs; [
      ## Formatter
      vscode-extensions.redhat.vscode-xml
      vscode-extensions.redhat.vscode-yaml
      vscode-extensions.tamasfe.even-better-toml
      vscode-extensions.editorconfig.editorconfig
      # Misc
      vscode-extensions.ms-vscode-remote.remote-ssh
      vscode-extensions.eamodio.gitlens
      # [Missing] Encode Decode
      ## nix
      vscode-extensions.bbenoist.nix
      vscode-extensions.kamadorueda.alejandra
      ## js/ts
      vscode-extensions.esbenp.prettier-vscode
      vscode-extensions.dbaeumer.vscode-eslint
      # [Missing] prettier-eslint
      # [Missing] pretty typescript errors
      ## Rust
      vscode-extensions.rust-lang.rust-analyzer
    ];

    userSettings = {
      "editor.mouseWheelZoom" = true;
      "window.zoomLevel" = 2;
      "editor.formatOnSave" = true;
      "editor.codeActionsOnSave" = [
        "source.organizeImports"
        "source.fixAll.eslint"
      ];
      "editor.maxTokenizationLineLength" = 2000;
      "editor.rulers" = [80 100 120];
      "editor.minimap.enabled" = true;
      "editor.tabSize" = 2;
      "files.trimTrailingWhitespace" = true;
      "files.insertFinalNewline" = true;

      "[typescriptreact]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[typescript]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[javascript]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[json]" = {
        "editor.defaultFormatter" = "vscode.json-language-features";
      };

      "git.enableCommitSigning" = true;
      "update.showReleaseNotes" = false;
      "typescript.updateImportsOnFileMove.enabled" = "always";
      "extensions.ignoreRecommendations" = true;
      "redhat.telemetry.enabled" = false;

      "workbench.colorTheme" = "Default Dark Modern";
      "terminal.integrated.defaultProfile.linux" = "zsh";
    };
  };
}
