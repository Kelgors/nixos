{
  config,
  pkgs,
  ...
}: {
  programs.tmux = {
    enable = true;
    prefix = "²";
    terminal = "tmux-256color";
    shell = "${pkgs.zsh}/bin/zsh";
    mouse = true;
    keyMode = "vi";
    historyLimit = 2000;
    escapeTime = 0;
    sensibleOnTop = false;
    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.yank;
        extraConfig = ''
          bind-key -T copy-mode-vi 'v' send-keys -X begin-selection
          bind-key -T copy-mode-vi 'y' send-keys -X copy-selection
          bind-key -T copy-mode-vi 'p' paste-buffer \; send-keys -X cancel
        '';
      }
      tmuxPlugins.vim-tmux-navigator
      {
        plugin = tmuxPlugins.catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavour 'mocha'
          set -g @catppuccin_window_left_separator ""
          set -g @catppuccin_window_right_separator " "
          set -g @catppuccin_window_middle_separator " █"
          set -g @catppuccin_window_number_position "right"
          set -g @catppuccin_window_default_fill "number"
          set -g @catppuccin_window_default_text "#W"
          set -g @catppuccin_window_current_fill "number"
          set -g @catppuccin_window_current_text "#W#{?window_zoomed_flag,(),}"
          set -g @catppuccin_status_modules_right "directory date_time"
          set -g @catppuccin_status_modules_left "session"
          set -g @catppuccin_status_left_separator  " "
          set -g @catppuccin_status_right_separator " "
          set -g @catppuccin_status_right_separator_inverse "no"
          set -g @catppuccin_status_fill "icon"
          set -g @catppuccin_status_connect_separator "no"
          set -g @catppuccin_directory_text "#{b:pane_current_path}"
          set -g @catppuccin_date_time_text "%H:%M"
          set -g pane-active-border-style 'fg=magenta,bg=default'
          set -g pane-border-style 'fg=brightblack,bg=default'
        '';
      }
    ];
    extraConfig = ''
      set -g base-index 1              # start indexing windows at 1 instead of 0
      set -g renumber-windows on       # renumber all windows when any window is closed
      set -g set-clipboard on          # use system clipboard
      set -g status-position top       # macOS / darwin style
      ## split panes using | and -
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      unbind '"'
      unbind %
      # Resize pane with <prefix> hjkl
      bind -r -T prefix h resize-pane -L 10
      bind -r -T prefix l resize-pane -R 10
      bind -r -T prefix j resize-pane -D 5
      bind -r -T prefix k resize-pane -U 5
      ## switch window using Alt-HJKL without prefix
      bind -n M-h previous-window
      bind -n M-l next-window
    '';
  };
}
