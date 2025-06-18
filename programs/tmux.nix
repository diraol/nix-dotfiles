{ config, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    shortcut = "a";
    baseIndex = 1;
    newSession = true;
    escapeTime = 0;
    
    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank
      {
        plugin = resurrect;
        extraConfig = "set -g @resurrect-strategy-vim 'session'";
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '60' # minutes
        '';
      }
    ];
    
    extraConfig = ''
      # Set window split
      bind - split-window -v -c '#{pane_current_path}'
      bind '\' split-window -h -c '#{pane_current_path}'
      bind c new-window -c '#{pane_current_path}'
      
      # Reload config
      bind r source-file ~/.tmux.conf \; display-message "Config reloaded!"
      
      # Terminal settings
      set-option -g default-terminal "tmux-256color"
      set-option -g pane-base-index 1
      set-option -g renumber-windows on
      
      # Xterm keys
      set-option -gw xterm-keys on
      bind -n C-PageUp send-keys C-PageUp
      bind -n C-PageDown send-keys C-PageDown
      
      # Smart pane switching with awareness of Vim splits
      # Binding Ctrl+Shift to move to cycle between tmux windows
      bind-key -n C-Tab next-window
      bind-key -n C-S-Tab previous-window
      bind-key -n C-S-n new-window
      
      # Vim-like pane switching
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
      bind -n S-Left if-shell "$is_vim" "send-keys S-Left"  "select-pane -L"
      bind -n S-Right if-shell "$is_vim" "send-keys S-Right"  "select-pane -R"
      bind -n S-Up if-shell "$is_vim" "send-keys S-Up"  "select-pane -U"
      bind -n S-Down if-shell "$is_vim" "send-keys S-Down"  "select-pane -D"
      
      # Remove ESC time wait
      set -g escape-time 0
      set -g repeat-time 300
      set -g focus-events on
      
      # Vi mode
      set-window-option -g mode-keys vi
      
      # Mouse support
      set -g mouse on
      bind -n WheelUpPane if-shell -F -t = "#{mouse_any_flag}" "send-keys -M" "if -Ft= '#{pane_in_mode}' 'send-keys -M' 'select-pane -t=; copy-mode -e; send-keys -M'"
      bind -n WheelDownPane select-pane -t= \; send-keys -M
      bind -n C-WheelUpPane select-pane -t= \; copy-mode -e \; send-keys -M
      bind -T copy-mode-vi    C-WheelUpPane   send-keys -X halfpage-up
      bind -T copy-mode-vi    C-WheelDownPane send-keys -X halfpage-down
      bind -T copy-mode-emacs C-WheelUpPane   send-keys -X halfpage-up
      bind -T copy-mode-emacs C-WheelDownPane send-keys -X halfpage-down
      
      # Copy mode bindings
      unbind -T copy-mode-vi Enter
      bind-key -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel "wl-copy"
      bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "wl-copy"
      
      # Status bar configuration (Gruvbox theme)
      set-option -g status "on"
      set-option -g status-bg colour237 #bg1
      set-option -g status-fg colour223 #fg1
      set-option -g status-justify "left"
      set-option -g status-left-length "80"
      set-option -g status-right-length "80"
      set-window-option -g window-status-separator ""
      
      set-option -g status-left "#[fg=colour248, bg=colour241] #S #[fg=colour241, bg=colour237, nobold, noitalics, nounderscore]"
      set-option -g status-right "#[fg=colour239, bg=colour237, nobold, nounderscore, noitalics]#[fg=colour246,bg=colour239] %Y-%m-%d  %H:%M #[fg=colour248, bg=colour239, nobold, noitalics, nounderscore]#[fg=colour237, bg=colour248] #h "
      
      set-window-option -g window-status-current-format "#[fg=colour239, bg=colour248, :nobold, noitalics, nounderscore]#[fg=colour239, bg=colour214] #I #[fg=colour239, bg=colour214, bold] #W #[fg=colour214, bg=colour237, nobold, noitalics, nounderscore]"
      set-window-option -g window-status-format "#[fg=colour237,bg=colour239,noitalics]#[fg=colour223,bg=colour239] #I #[fg=colour223, bg=colour239] #W #[fg=colour239, bg=colour237, noitalics]"
      
      # Pane border colors
      set-option -g display-panes-active-colour colour250 #fg2
      set-option -g display-panes-colour colour237 #bg1
      
      # Clock
      set-window-option -g clock-mode-colour colour109 #blue
      
      # Bell
      set-window-option -g window-status-bell-style fg=colour235,bg=colour167 #bg, red
      
      # Status bar
      set-option -g status-interval 5
      set-option -g visual-activity on
      set-window-option -g monitor-activity on
    '';
  };
} 