{
  pkgs,
  pkgs-stable,
  config,
  lib,
  ...
}: {
  # Theme configuration
  home.pointerCursor = {
    gtk.enable = true;
    name = "phinger-cursors-light";
    package = pkgs.phinger-cursors;
    size = 24;
  };

  gtk = {
    enable = true;
    theme = {
      name = "Nordic";
      package = pkgs.nordic;
    };
    iconTheme = {
      name = "Nordic-blueish";
      package = pkgs.nordic;
    };
  };

  wayland.windowManager.sway = {
    enable = true;
    package = config.lib.nixGL.wrap pkgs.sway;
    
    # Sway configuration
    config = {
      modifier = "Mod1"; # Alt key
      
      # Set default terminal
      terminal = "kitty";
      
      # Set menu launcher
      menu = "fuzzel";
      
      # Set default font
      fonts = {
        names = [ "Source Code Pro" ];
        size = 10.0;
      };

      # Input configuration
      input = {
        "type:keyboard" = {
          xkb_layout = "us";
          xkb_variant = "intl";
          xkb_options = "ctrl:nocaps,grp:win_space_toggle";
        };
        "type:touchpad" = {
          tap = "enabled";
          natural_scroll = "enabled";
          dwt = "enabled";
          accel_profile = "adaptive";
          pointer_accel = "0.5";
        };
      };

      # Output configuration
      output = {
        "*" = {
          bg = "${config.home.homeDirectory}/Pictures/wallpaper.jpg fill";
        };
      };

      # Window and workspace settings
      window = {
        border = 2;
        hideEdgeBorders = "smart";
        titlebar = false;
      };

      floating = {
        border = 2;
        titlebar = false;
      };

      gaps = {
        inner = 5;
        outer = 5;
        smartGaps = true;
        smartBorders = "on";
      };

      # Colors (Nordic theme)
      colors = {
        focused = {
          border = "#5e81ac";
          background = "#5e81ac";
          text = "#ffffff";
          indicator = "#5e81ac";
          childBorder = "#5e81ac";
        };
        focusedInactive = {
          border = "#4c566a";
          background = "#4c566a";
          text = "#d8dee9";
          indicator = "#4c566a";
          childBorder = "#4c566a";
        };
        unfocused = {
          border = "#3b4252";
          background = "#3b4252";
          text = "#d8dee9";
          indicator = "#3b4252";
          childBorder = "#3b4252";
        };
        urgent = {
          border = "#bf616a";
          background = "#bf616a";
          text = "#ffffff";
          indicator = "#bf616a";
          childBorder = "#bf616a";
        };
      };

      # Key bindings
      keybindings = let
        modifier = config.wayland.windowManager.sway.config.modifier;
        terminal = config.wayland.windowManager.sway.config.terminal;
        menu = config.wayland.windowManager.sway.config.menu;
      in lib.mkOptionDefault {
        # Application shortcuts
        "${modifier}+Return" = "exec ${terminal}";
        "${modifier}+d" = "exec ${menu}";
        "${modifier}+e" = "exec nautilus";
        "${modifier}+l" = "exec swaylock";
        
        # Window management
        "${modifier}+Shift+q" = "kill";
        "${modifier}+Shift+space" = "floating toggle";
        "${modifier}+f" = "fullscreen toggle";
        "${modifier}+Tab" = "focus next";
        
        # Layout management
        "${modifier}+s" = "layout stacking";
        "${modifier}+w" = "layout tabbed";
        "${modifier}+t" = "layout toggle split";
        "${modifier}+v" = "split vertical";
        "${modifier}+h" = "split horizontal";
        
        # Focus movement
        "${modifier}+Left" = "focus left";
        "${modifier}+Down" = "focus down";
        "${modifier}+Up" = "focus up";
        "${modifier}+Right" = "focus right";
        
        # Window movement
        "${modifier}+Shift+Left" = "move left";
        "${modifier}+Shift+Down" = "move down";
        "${modifier}+Shift+Up" = "move up";
        "${modifier}+Shift+Right" = "move right";
        
        # Workspace switching
        "${modifier}+1" = "workspace number 1";
        "${modifier}+2" = "workspace number 2";
        "${modifier}+3" = "workspace number 3";
        "${modifier}+4" = "workspace number 4";
        "${modifier}+5" = "workspace number 5";
        "${modifier}+6" = "workspace number 6";
        "${modifier}+7" = "workspace number 7";
        "${modifier}+8" = "workspace number 8";
        "${modifier}+9" = "workspace number 9";
        "${modifier}+0" = "workspace number 10";
        
        # Move container to workspace
        "${modifier}+Shift+1" = "move container to workspace number 1";
        "${modifier}+Shift+2" = "move container to workspace number 2";
        "${modifier}+Shift+3" = "move container to workspace number 3";
        "${modifier}+Shift+4" = "move container to workspace number 4";
        "${modifier}+Shift+5" = "move container to workspace number 5";
        "${modifier}+Shift+6" = "move container to workspace number 6";
        "${modifier}+Shift+7" = "move container to workspace number 7";
        "${modifier}+Shift+8" = "move container to workspace number 8";
        "${modifier}+Shift+9" = "move container to workspace number 9";
        "${modifier}+Shift+0" = "move container to workspace number 10";
        
        # Screenshots
        "Print" = "exec grim -g \"$(slurp)\" ${config.home.homeDirectory}/Pictures/Screenshots/screenshot-$(date +%Y%m%d_%H%M%S).png";
        "Shift+Print" = "exec grim ${config.home.homeDirectory}/Pictures/Screenshots/fullscreen-$(date +%Y%m%d_%H%M%S).png";
        
        # System control
        "Ctrl+Alt+Delete" = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway?' -b 'Yes, exit sway' 'swaymsg exit'";
        
        # Audio controls
        "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
        "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
        "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
        "XF86AudioMicMute" = "exec pactl set-source-mute @DEFAULT_SOURCE@ toggle";
        
        # Brightness controls
        "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
        "XF86MonBrightnessUp" = "exec brightnessctl set 5%+";
      };

      # Startup applications
      startup = [
        {
          command = "waybar";
          always = false;
        }
        {
          command = "nm-applet --indicator";
          always = false;
        }
        {
          command = "blueman-applet";
          always = false;
        }
        {
          command = "dbus-update-activation-environment --systemd --all";
          always = false;
        }
        {
          command = "gnome-keyring-daemon --start --components=secrets";
          always = false;
        }
      ];

      # Window rules
      window.commands = [
        {
          criteria = { app_id = "firefox"; };
          command = "inhibit_idle fullscreen";
        }
        {
          criteria = { class = "Steam"; };
          command = "floating enable";
        }
        {
          criteria = { app_id = "pavucontrol"; };
          command = "floating enable";
        }
      ];
    };

    # Extra configuration
    extraConfig = ''
      # Set environment variables for Wayland
      exec_always {
          export GDK_BACKEND=wayland,x11
          export QT_QPA_PLATFORM=wayland;xcb
          export SDL_VIDEODRIVER=wayland
          export CLUTTER_BACKEND=wayland
          export XDG_CURRENT_DESKTOP=sway
          export XDG_SESSION_TYPE=wayland
          export XDG_SESSION_DESKTOP=sway
          export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
          export _JAVA_AWT_WM_NONREPARENTING=1
          export MOZ_ENABLE_WAYLAND=1
          export MOZ_ACCELERATED=1
          export MOZ_WEBRENDER=1
          export ELECTRON_OZONE_PLATFORM_HINT=auto
      }
      
      # Disable laptop screen when lid is closed
      bindswitch --reload --locked lid:on output eDP-1 disable
      bindswitch --reload --locked lid:off output eDP-1 enable
    '';
  };

  # Additional packages for sway functionality
  home.packages = with pkgs; [
    sway-contrib.grimshot  # Screenshots
    swaylock              # Screen locking
    swayidle              # Idle management
    wl-clipboard          # Clipboard utilities
    brightnessctl         # Brightness control
    playerctl             # Media control
    pavucontrol           # Audio control GUI
  ];

  # Services
  services = {
    swayidle = {
      enable = true;
      timeouts = [
        {
          timeout = 300;
          command = "${pkgs.swaylock}/bin/swaylock -fF";
        }
        {
          timeout = 600;
          command = "${pkgs.sway}/bin/swaymsg \"output * dpms off\"";
        }
      ];
      events = [
        {
          event = "before-sleep";
          command = "${pkgs.swaylock}/bin/swaylock -fF";
        }
      ];
    };
  };

  # Create screenshots directory
  home.file."Pictures/Screenshots/.keep".text = "";
} 