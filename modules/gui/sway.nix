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
    package = config.lib.nixGL.wrapOffload pkgs.sway;
    
    # Sway configuration
    config = {
      modifier = "Mod1"; # Alt key
      
      # Set default terminal
      terminal = "gnome-terminal";
      
      # Set menu launcher
      menu = "wofi --show=drun -i -I -m";
      
      # Set default font
      fonts = {
        names = [ "Inconsolata Nerd Font" ];
        size = 11.0;
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
      # output = {
      #   "*" = {
      #     bg = "${config.home.homeDirectory}/Pictures/wallpaper.jpg fill";
      #   };
      # };

      # Window and workspace settings
      window = {
        border = 0;
        hideEdgeBorders = "smart";
        titlebar = false;
      };

      floating = {
        border = 0;
        titlebar = false;
      };

      gaps = {
        inner = 5;
        outer = 5;
        smartGaps = true;
        smartBorders = "on";
      };

      # Colors (Gruvbox theme)
      colors = {
        focused = {
          border = "#458588";
          background = "#458588";
          text = "#1d2021";
          indicator = "#b16286";
          childBorder = "#1d2021";
        };
        focusedInactive = {
          border = "#1d2021";
          background = "#1d2021";
          text = "#d79921";
          indicator = "#b16286";
          childBorder = "#1d2021";
        };
        unfocused = {
          border = "#1d2021";
          background = "#1d2021";
          text = "#d79921";
          indicator = "#b16286";
          childBorder = "#1d2021";
        };
        urgent = {
          border = "#cc241d";
          background = "#cc241d";
          text = "#ebdbb2";
          indicator = "#cc241d";
          childBorder = "#cc241d";
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
        "${modifier}+b" = "exec nautilus";
        "${modifier}+c" = "exec gsimplecal";
        "Ctrl+Alt+l" = "exec swaylock -f -c 000000";
        
        # Window management
        "${modifier}+Shift+q" = "kill";
        "${modifier}+Shift+space" = "floating toggle";
        "${modifier}+f" = "fullscreen toggle";
        "${modifier}+Tab" = "focus next";
        "${modifier}+space" = "focus mode_toggle";
        "${modifier}+a" = "focus parent";
        
        # Layout management
        "${modifier}+s" = "sticky toggle";
        "${modifier}+w" = "layout tabbed";
        "${modifier}+e" = "layout toggle split";
        "${modifier}+v" = "splitv";
        "${modifier}+h" = "splith";
        "${modifier}+r" = "mode resize";
        
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
        
        # Workspace switching with F-keys
        "F1" = "workspace number 1";
        "F2" = "workspace number 2";
        "F3" = "workspace number 3";
        "F4" = "workspace number 4";
        "F5" = "workspace number 5";
        "F6" = "workspace number 6";
        "F7" = "workspace number 7";
        "F8" = "workspace number 8";
        "F9" = "workspace number 9";
        "F10" = "workspace number 10";
        "${modifier}+Next" = "workspace next";
        "${modifier}+Prior" = "workspace prev";
        
        # Move container to workspace with Shift+F-keys
        "${modifier}+Shift+F1" = "move container to workspace number 1";
        "${modifier}+Shift+F2" = "move container to workspace number 2";
        "${modifier}+Shift+F3" = "move container to workspace number 3";
        "${modifier}+Shift+F4" = "move container to workspace number 4";
        "${modifier}+Shift+F5" = "move container to workspace number 5";
        "${modifier}+Shift+F6" = "move container to workspace number 6";
        "${modifier}+Shift+F7" = "move container to workspace number 7";
        "${modifier}+Shift+F8" = "move container to workspace number 8";
        "${modifier}+Shift+F9" = "move container to workspace number 9";
        "${modifier}+Shift+F10" = "move container to workspace number 10";
        
        # Screenshots
        "Print" = "exec grim -g \"$(slurp)\" - | wl-copy";
        "Shift+Print" = "exec grim -g \"$(slurp)\" \"${config.home.homeDirectory}/sandbox/screenshots/screenshot_$(date +%Y%m%d_%H%M%S).png\"";
        "Ctrl+Print" = "exec grim \"${config.home.homeDirectory}/sandbox/screenshots/screenshot_$(date +%Y%m%d_%H%M%S).png\"";
        
        # System control
        "${modifier}+Shift+e" = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";
        "${modifier}+Shift+r" = "reload";
        
        # Audio controls
        #"XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
        #"XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
        #"XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
        #"XF86AudioMicMute" = "exec pactl set-source-mute @DEFAULT_SOURCE@ toggle";
        "XF86AudioRaiseVolume" = "exec amixer -D pipewire sset Master 5%+";
        "XF86AudioLowerVolume" = "exec amixer -D pipewire sset Master 5%-";
        "XF86AudioMute" = "exec amixer -D pipewire set Master 1+ toggle";
        "${modifier}+equal" = "exec amixer -D pipewire sset Master 5%+";
        "${modifier}+minus" = "exec amixer -D pipewire sset Master 5%-";
        "XF86AudioPlay" = "exec playerctl play-pause";
        "XF86AudioNext" = "exec playerctl next";
        "XF86AudioPrev" = "exec playerctl previous";
        
        # Brightness controls
        "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
        "XF86MonBrightnessUp" = "exec brightnessctl set 5%+";
        "${modifier}+Shift+minus" = "exec brightnessctl set 5%-";
        "${modifier}+Shift+equal" = "exec brightnessctl set 5%+";
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
          command = "mako";
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
          criteria = { app_id = "pavucontrol"; };
          command = "floating enable";
        }
        {
          criteria = { title = "Launch Application"; };
          command = "floating enable";
        }
        {
          criteria = { title = "Zoom Group Chat"; };
          command = "floating enable";
        }
        {
          criteria = { title = "Zoom - Free Account"; };
          command = "floating enable";
        }
        {
          criteria = { instance = "zoom"; title = "Settings"; };
          command = "floating enable";
        }
        {
          criteria = { app_id = "zoom"; };
          command = "floating enable";
        }
        {
          criteria = { app_id = "org.keepassxc.KeePassXC"; };
          command = "floating enable, move scratchpad, scratchpad show";
        }
        {
          criteria = { title = ".*Firefox.*Sharing Indicator.*"; };
          command = "floating enable";
        }
        {
          criteria = { app_id = "personalfox"; title = "Picture-in-Picture"; };
          command = "floating enable, sticky enable, border none";
        }
        {
          criteria = { app_id = "blueman-manager"; };
          command = "floating enable";
        }
        {
          criteria = { app_id = "gnome-calculator"; };
          command = "floating enable";
        }
      ];
    };

    # Extra configuration
    extraConfig = ''
      # Set environment variables for Wayland and Intel GPU
      exec_always export GDK_BACKEND="wayland,x11"
      exec_always export QT_QPA_PLATFORM="wayland;xcb"
      exec_always export LIBVA_DRIVER_NAME=iHD
      exec_always export VDPAU_DRIVER=va_gl
      exec_always export SDL_VIDEODRIVER=wayland
      exec_always export CLUTTER_BACKEND=wayland
      exec_always export XDG_CURRENT_DESKTOP=sway
      exec_always export XDG_SESSION_TYPE=wayland
      exec_always export XDG_SESSION_DESKTOP=sway
      exec_always export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
      exec_always export _JAVA_AWT_WM_NONREPARENTING=1
      exec_always export MOZ_ENABLE_WAYLAND=1
      exec_always export MOZ_ACCELERATED=1
      exec_always export MOZ_WEBRENDER=1
      exec_always export ELECTRON_OZONE_PLATFORM_HINT=auto
      exec_always test -f ~/.diraol/rc && . ~/.diraol/rc || true
      exec hash dbus-update-activation-environment 2>/dev/null && dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK
      xwayland enable
      
      # Gruvbox color variables
      set $bg #282828
      set $red #cc241d
      set $green #98971a
      set $yellow #d79921
      set $blue #458588
      set $purple #b16286
      set $aqua #689d68
      set $gray #a89984
      set $darkgray #1d2021
      set $white #ebdbb2
      
      # Hide titlebars
      default_border none
      
      # Resize mode
      # mode "resize" {
      #     bindsym Left resize shrink width 10px
      #     bindsym Down resize grow height 10px
      #     bindsym Up resize shrink height 10px
      #     bindsym Right resize grow width 10px
      #     bindsym Return mode "default"
      #     bindsym Escape mode "default"
      # }
      
      # Scratchpad mode
      set $scratchpad "scratchpad"
      mode "$scratchpad" {
          bindsym a [app_id="pavucontrol"] scratchpad show
          bindsym c [app_id="gnome-calendar"] scratchpad show
          bindsym k [app_id="org.keepassxc.KeePassXC"] scratchpad show
          bindsym Return mode "default"
          bindsym Escape mode "default"
      }
      bindsym Mod1+Shift+s mode "$scratchpad"
      
      # Notifications mode
      mode "notifications" {
          bindsym Escape mode "default"
          bindsym Return exec makoctl invoke; exec makoctl dismiss; mode "default"
          bindsym d exec makoctl dismiss; mode "default"
          bindsym a exec makoctl dismiss -a; mode "default"
      }
      bindsym Mod1+Shift+n mode "notifications"
      bindsym Mod1+Shift+z exec makoctl dismiss -a
      
      # Scratchpad bindings
      bindsym Mod5+Shift+minus move scratchpad
      bindsym Mod5+minus scratchpad show
      bindsym Mod4+Shift+k [app_id="org.keepassxc.KeePassXC"] scratchpad show
      
      # Status bar
      #bar {
      #    swaybar_command waybar
      #}
      
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
    wofi                  # Application launcher
    gsimplecal            # Calendar
    gnome-terminal        # Terminal
    grim                  # Screenshots
    slurp                 # Screen area selection
    mako                  # Notifications
    alsa-utils            # Audio utilities
    libnotify             # Notification utilities
  ];

  # Services
  services = {
    swayidle = {
      enable = false;
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

    mako = {
      enable = true;
      settings = {
        background--color = "#1d2021";
        border-color = "#458588";
        border-radius = 5;
        border-size = 2;
        default-timeout = 5000;
        font = "Inconsolata Nerd Font 10";
        text-color = "#ebdbb2";
      };
    };
  };

  # Waybar configuration
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 26;
        modules-left = [
          "sway/workspaces"
          "custom/right-arrow-dark"
          "sway/mode"
        ];
        modules-center = [
          "custom/left-arrow-dark"
          "sway/window"
          "custom/left-arrow-light"
          "custom/left-arrow-dark"
          "custom/clock"
          "custom/right-arrow-dark"
        ];
        modules-right = [
          "custom/left-arrow-dark"
          "idle_inhibitor"
          "custom/left-arrow-light"
          "custom/left-arrow-dark"
          "pulseaudio"
          "custom/left-arrow-light"
          "custom/left-arrow-dark"
          "network"
          "custom/left-arrow-light"
          "custom/left-arrow-dark"
          "disk#root"
          "disk#home"
          "custom/left-arrow-light"
          "custom/left-arrow-dark"
          "battery#1"
          "battery#2"
          "custom/left-arrow-light"
          "custom/left-arrow-dark"
          "tray"
        ];
        
        "sway/workspaces" = {
          disable-scroll = true;
          all-outputs = false;
        };
        
        "sway/window" = {
          tooltip = false;
          max-length = 60;
        };
        
        "sway/mode" = {
          format =  " {}";
          max-length = 50;
        };
        
        tray = {
          spacing = 5;
        };
        
        "custom/clock" = {
          exec = "date '+%Y-%m-%d %H:%M'";
          interval = 45;
          tooltip = false;
          on-click = "gsimplecal";
        };
        
        cpu = {
          interval = 5;
          format =  "  {usage}%";
        };
        
        "disk#root" = {
          format = " : /{percentage_used}%";
          on-click = "nautilus";
          path = "/";
        };
        
        "disk#home" = {
          format = ":: {percentage_used}%";
          on-click = "nautilus";
          path = "/home";
        };
        
        memory = {
          interval = 5;
          format = "Mem {}%";
        };
        
        "battery#1" = {
          bat = "BAT0";
          states = {
            warning = 20;
            critical = 10;
          };
          format = "{icon} {capacity}%";
          format-charging = "{icon} {capacity}%  ";
          format-plugged = "{icon} {capacity}%  ";
          format-warning = "{icon} {capacity}%  ";
          format-critical = "{icon}  {capacity}%  ";
          format-icons = ["󰂃" "󰁺" "󰁼" "󰁾" "󰂀" "󰂂" "󰁹"];
        };
        
        "battery#2" = {
          bat = "BAT1";
          states = {
            warning = 20;
            critical = 10;
          };
          format = "{icon} {capacity}%";
          format-charging = "{icon} {capacity}%  ";
          format-plugged = "{icon} {capacity}%  ";
          format-warning = "{icon} {capacity}%  ";
          format-critical = "{icon}  {capacity}%  ";
          format-icons = ["󰂃" "󰁺" "󰁼" "󰁾" "󰂀" "󰂂" "󰁹"];
        };
        
        network = {
          format-wifi = "{essid} ({signalStrength}%) {ipaddr}  ";
          format-ethernet = "{ifname}: {ipaddr}/{cidr}  ";
          format-disconnected = " 󰌙";
          tooltip = false;
          on-click = "swaymsg exec '$term -e nmtui-connect'";
        };
        
        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = " ";
            deactivated = " ";
          };
          tooltip = false;
        };
        
        pulseaudio = {
          format = "{volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon} {desc} | {format_source}";
          format-bluetooth-muted = "󰟎 {icon}  {desc} | {format_source}";
          format-muted = "󰝟 {format_source}";
          format-source = "{volume}%  ";
          format-source-muted = " ";
          format-icons = {
            headphones = "󰋋";
            default = [
              ""
              ""
              ""
            ];
          };
          scroll-step = 5;
          on-click = "pavucontrol";
        };
        
        backlight = {
          format = "{percent}% {icon}";
          format-icons = [
            " "
            " "
          ];
        };
        
        "custom/left-arrow-dark" = {
          format = "";
          tooltip = false;
        };
        
        "custom/left-arrow-light" = {
          format = "";
          tooltip = false;
        };
        
        "custom/right-arrow-clock" = {
          format = "";
          tooltip = false;
        };
        
        "custom/right-arrow-dark" = {
          format = "";
          tooltip = false;
        };
        
        "custom/right-arrow-light" = {
          format = "";
          tooltip = false;
        };
      };
    };
    
    style = ''
      * {
          font-size: 14px;
          font-family: "Inconsolata Nerd Font";
      }

      window.DP-5 * { font-size: 10px; }

      window#waybar {
          background: #292b2e;
          color: #fdf6e3;
      }

      #custom-right-arrow-dark,
      #custom-left-arrow-dark,
      #custom-right-arrow-light,
      #custom-left-arrow-light {
          font-size: 14px;
          margin: 0;
          padding: 0;
      }

      #custom-right-arrow-dark,
      #custom-left-arrow-dark {
          color: #1a1a1a;
      }
      #custom-right-arrow-light,
      #custom-left-arrow-light {
          color: #292b2e;
          background: #1a1a1a;
      }

      #backlight,
      #battery.1,
      #battery.2,
      #custom-clock,
      #clock.1,
      #clock.2,
      #cpu,
      #disk,
      #idle_inhibitor,
      #memory,
      #mode,
      #network,
      #pulseaudio,
      #tray,
      #window,
      #workspaces {
          background: #1a1a1a;
      }

      #workspaces button {
          padding: 0 1px;
          color: #fdf6e3;
      }
      #workspaces button.focused {
          color: #268bd2;
      }
      #workspaces button:hover {
          box-shadow: inherit;
          text-shadow: inherit;
      }
      #workspaces button:hover {
          background: #1a1a1a;
          border: #1a1a1a;
          padding: 0 2px;
      }

      #pulseaudio {
          color: #268bd2;
      }
      #backlight {
          color: #b58900;
      }
      #memory {
          color: #2aa198;
      }
      #cpu {
          color: #6c71c4;
      }
      #battery.1, #battery.2 {
          color: #859900;
      }

      #backlight,
      #battery.1,
      #battery.2,
      #custom-clock,
      #clock.1,
      #clock.2,
      #cpu,
      #disk,
      #idle_inhibitor,
      #memory,
      #mode,
      #network,
      #pulseaudio,
      #window {
          padding: 0 10px;
      }
    '';
  };

  # Create sandbox directory for screenshots (matching reference config)
  home.file."sandbox/screenshots/.keep".text = "";

  # Create sway desktop entry for GDM
  # home.file.".local/share/wayland-sessions/sway.desktop".text = ''
  #   [Desktop Entry]
  #   Name=Sway
  #   Comment=An i3-compatible Wayland compositor
  #   Exec=/home/diraol/.local/bin/start-sway
  #   Type=Application
  #   Keywords=tiling;wm;windowmanager;window;manager;
  #   DesktopNames=sway
  # '';

  # # Also create in xsessions for compatibility
  # home.file.".local/share/xsessions/sway.desktop".text = ''
  #   [Desktop Entry]
  #   Name=Sway
  #   Comment=An i3-compatible Wayland compositor
  #   Exec=/home/diraol/.local/bin/start-sway
  #   Type=Application
  #   Keywords=tiling;wm;windowmanager;window;manager;
  #   DesktopNames=sway
  # '';

  # # Create a sway startup script with proper environment
  # home.file.".local/bin/start-sway".text = ''
  #   #!/bin/bash
  #   
  #   # Set up environment for sway
  #   export GDK_BACKEND=wayland,x11
  #   export QT_QPA_PLATFORM=wayland;xcb
  #   export SDL_VIDEODRIVER=wayland
  #   export CLUTTER_BACKEND=wayland
  #   export XDG_CURRENT_DESKTOP=sway
  #   export XDG_SESSION_TYPE=wayland
  #   export XDG_SESSION_DESKTOP=sway
  #   export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
  #   export _JAVA_AWT_WM_NONREPARENTING=1
  #   export MOZ_ENABLE_WAYLAND=1
  #   export MOZ_ACCELERATED=1
  #   export MOZ_WEBRENDER=1
  #   export ELECTRON_OZONE_PLATFORM_HINT=auto
  #   
  #   # Start sway
  #   exec ${config.wayland.windowManager.sway.package}/bin/sway "$@" 2>&1 | tee /var/log/sway/sway.log
  # '';
  
  # # Make the script executable
  # home.file.".local/bin/start-sway".executable = true;
} 
