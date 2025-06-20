{ config, pkgs, ... }:

let
  awesome-terminal-fonts = pkgs.fetchFromGitHub {
    owner = "gabrielelana";
    repo = "awesome-terminal-fonts";
    rev = "v1.1.0";
    sha256 = "sha256-yBYk5kzgNgHkqiXE/8ptIC1z/0NblvpUmOSAEiLYzqY=";
  };
in
{
  # Import modular configurations
  imports = [
    ./programs/cli.nix
    ./programs/git.nix
    ./programs/shell.nix
    ./programs/tmux.nix
    ./programs/zsh.nix
  ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
    username = "diraol";
    homeDirectory = "/home/diraol";
    
    # This value determines the Home Manager release that your
    # configuration is compatible with.
    stateVersion = "23.11";
  
    # Environment variables
    sessionVariables = {
      EDITOR = "vim";
      BROWSER = "firefox";
      NIXPKGS_ALLOW_UNFREE = "1";
      DOTFILES = "$HOME/dev/nix-dotfiles";
      DEFAULT_USER = "diraol";
      GITHUB_USER = "diraol";
      # ref: https://github.com/flameshot-org/flameshot/blob/master/docs/Sway%20and%20wlroots%20support.md#basic-steps
      # SDL_VIDEODRIVER = "wayland";
      _JAVA_AWT_WM_NONREPARENTING = "1";
      # QT_QPA_PLATFORM = "wayland";
      PYTHON_CONFIGURE_OPTS = "--enable-shared";
      
      # Additional Wayland/Hyprland environment variables
      WLR_NO_HARDWARE_CURSORS = "1";        # Fix for cursor issues
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";  # Qt wayland decoration
      MOZ_ENABLE_WAYLAND = "1";             # Firefox Wayland support
      
      # Hyprland-specific variables
      HYPRLAND_LOG_WLR = "1";               # Enable wlroots logging
      WLR_DRM_DEVICES = "/dev/dri/card1";   # Force Intel GPU usage
      
      # XDG Desktop Portal
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
    };
    
    # Session path
    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/bin"
      "$HOME/tools/bin"
      "$HOME/.pyenv/shims"
      "$HOME/go/bin"
      "$HOME/dev/nu/nucli"  # NUCLI_HOME equivalent
      "/opt/idea/current/bin"
      "$HOME/.cargo/bin"
      "$HOME/.local/share/coursier/bin"
      "/snap/bin"
    ];

    # Additional font packages for icons and symbols
    packages = with pkgs; [
      # Font management
      fontconfig
      
      # Nerd Fonts - patched fonts with extra glyphs
      nerd-fonts.hack
      nerd-fonts.inconsolata
      nerd-fonts.inconsolata-lgc
      nerd-fonts.meslo-lg
      nerd-fonts.ubuntu
      
      # Additional icon fonts for better compatibility
      font-awesome            # FontAwesome icons
      material-design-icons   # Material Design icons
      
      # Emoji support
      noto-fonts-emoji
      
      # nixGL for OpenGL support on non-NixOS systems
      # nixgl.nixGLIntel        # Intel GPU support
      # nixgl.nixVulkanIntel    # Intel Vulkan support
      
      # Hyprland and Wayland ecosystem
      hyprland                 # The Wayland compositor
      hyprland-protocols       # Wayland protocols for Hyprland
      mesa
      libdrm
      wlroots
      
      # Essential Wayland tools
      waybar                   # Status bar
      wofi                     # Application launcher (rofi replacement)
      dunst                   # Notification daemon
      kanshi                  # Display management
      
      # Terminal and applications
      kitty                   # Terminal emulator
      
      # Screen/window management
      slurp                   # Select a region (for screenshots)
      wl-clipboard           # Clipboard manager for Wayland
      swaybg                 # Background image setter
      wf-recorder            # Screen recorder
      flameshot              # Screenshot tool
      
      # Audio/Volume control
      pulsemixer             # Audio mixer
      pavucontrol            # PulseAudio volume control
      
      # System tools
      libnotify              # Desktop notifications
      wdisplays              # Display configuration GUI
      udiskie                # Auto-mount USB devices
      polkit_gnome           # Authentication agent
      
      # File manager
      nautilus               # GNOME Files
      
      # Themes and appearance
      adwaita-icon-theme     # GTK icons
      
      # Development tools
      google-chrome          # Web browser
      
      # Additional Hyprland tools
      grim                   # Screenshot tool for Wayland
      swappy                 # Screenshot editor
      wlogout               # Logout menu
      swaylock-effects      # Screen locker
      swayidle              # Idle management daemon
      xdg-desktop-portal-hyprland  # Desktop portal for Hyprland
      qt5.qtwayland         # Qt5 Wayland support
      qt6.qtwayland         # Qt6 Wayland support
      
      # System utilities
      playerctl             # Media player control
      brightnessctl         # Brightness control
    ];

  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # XDG directories
  xdg.enable = true;

  xdg.configFile."environment.d/envvars.conf".text = ''
    PATH="$HOME/.nix-profile/bin:$PATH"
  '';

  wayland.windowManager.hyprland = {
    enable = true;
    package=  config.lib.nixGL.wrap pkgs.hyprland;
    settings = {
      general = {
        gaps_in = 0;
        gaps_out = 0;
        border_size = 20;
      };
    };
  };

  # Font configuration
  fonts.fontconfig.enable = true;

  # Awesome terminal fonts setup
  home.file.".fonts/fontawesome-regular.ttf".source = "${awesome-terminal-fonts}/build/fontawesome-regular.ttf";
  home.file.".fonts/devicons-regular.ttf".source = "${awesome-terminal-fonts}/build/devicons-regular.ttf";
  home.file.".fonts/octicons-regular.ttf".source = "${awesome-terminal-fonts}/build/octicons-regular.ttf";
  home.file.".fonts/pomicons-regular.ttf".source = "${awesome-terminal-fonts}/build/pomicons-regular.ttf";
  
  # Font maps (shell scripts with glyph name variables)
  home.file.".fonts/fontawesome-regular.sh".source = "${awesome-terminal-fonts}/build/fontawesome-regular.sh";
  home.file.".fonts/devicons-regular.sh".source = "${awesome-terminal-fonts}/build/devicons-regular.sh";
  home.file.".fonts/octicons-regular.sh".source = "${awesome-terminal-fonts}/build/octicons-regular.sh";
  home.file.".fonts/pomicons-regular.sh".source = "${awesome-terminal-fonts}/build/pomicons-regular.sh";

  # Fontconfig for awesome-terminal-fonts fallback
  xdg.configFile."fontconfig/conf.d/10-symbols.conf".text = ''
    <?xml version="1.0"?>
    <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
    <fontconfig>
      <!-- Add awesome-terminal-fonts as fallback for symbols -->
      <alias>
        <family>monospace</family>
        <prefer>
          <family>MesloLGS Nerd Font</family>
          <family>FontAwesome</family>
          <family>Devicons</family>
          <family>Octicons</family>
          <family>Pomicons</family>
        </prefer>
      </alias>
    </fontconfig>
  '';

  # Systemd user services
  systemd.user.services.import-environment = {
    Unit = {
      Description = "Import environment variables for user services";
      After = [ "graphical-session-pre.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.systemd}/bin/systemctl --user import-environment PATH DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE";
      RemainAfterExit = true;
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  # Polkit authentication agent for GUI password prompts
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    Unit = {
      Description = "polkit-gnome-authentication-agent-1";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
      KillMode = "mixed";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  # Idle management for Hyprland
  systemd.user.services.swayidle = {
    Unit = {
      Description = "Idle manager for Wayland";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.swayidle}/bin/swayidle -w timeout 300 '${pkgs.swaylock-effects}/bin/swaylock-effects' timeout 600 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on' before-sleep '${pkgs.swaylock-effects}/bin/swaylock-effects'";
      Restart = "on-failure";
      RestartSec = 1;
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  # Optional: Hyprland systemd service (for auto-start)
  systemd.user.services.hyprland-nixgl = {
    Unit = {
      Description = "Hyprland Wayland Compositor with nixGL";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "notify";
      ExecStart = "${pkgs.nixgl.nixGLIntel}/bin/nixGLIntel ${pkgs.hyprland}/bin/Hyprland";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
      KillMode = "mixed";
      Environment = [
        "WLR_NO_HARDWARE_CURSORS=1"
        "WLR_DRM_DEVICES=/dev/dri/card1"
        "XDG_CURRENT_DESKTOP=Hyprland"
        "XDG_SESSION_DESKTOP=Hyprland"
        "XDG_SESSION_TYPE=wayland"
      ];
    };
    Install = {
      # Don't enable by default - user can enable manually if desired
      # WantedBy = [ "graphical-session.target" ];
    };
  };

  # Enable some essential programs
  programs.waybar.enable = true;
  
  # Wayland-specific program configurations
  programs.firefox = {
    enable = false; # Set to true if you want Firefox managed by home-manager
    # package = pkgs.firefox-wayland; # Uncomment for Wayland-specific Firefox
  };
  
  # Enable Wayland support for various programs
  programs.chromium = {
    enable = false; # Set to true if you want Chromium managed by home-manager
    commandLineArgs = [
      "--enable-features=UseOzonePlatform"
      "--ozone-platform=wayland"
      "--enable-wayland-ime"
    ];
  };
  
  # XDG Desktop Portal configuration for Hyprland
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
    config.common.default = "*";
    config.hyprland.default = [
      "hyprland"
      "gtk"
    ];
  };

  # Activation scripts for self-contained dotfiles setup
  home.activation.linkDotfiles = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    # Create necessary directories
    mkdir -p $HOME/.config
    
    # Refresh font cache to ensure all fonts are available
    ${pkgs.fontconfig}/bin/fc-cache -fv
    
    # Link self-contained configuration files from nix-dotfiles
    ln -sf ${config.home.sessionVariables.DOTFILES}/config/.p10k.zsh $HOME/.p10k.zsh
    ln -sf ${config.home.sessionVariables.DOTFILES}/config/.nurc $HOME/.nurc
    ln -sf ${config.home.sessionVariables.DOTFILES}/config/.nugitconfig $HOME/.nugitconfig
    ln -sf ${config.home.sessionVariables.DOTFILES}/config/.diraol $HOME/.diraol
    
    # Link SSH config from local config (self-contained)
    if [ -d "${config.home.sessionVariables.DOTFILES}/config/.ssh" ]; then
      mkdir -p $HOME/.ssh
      ln -sf ${config.home.sessionVariables.DOTFILES}/config/.ssh/* $HOME/.ssh/ 2>/dev/null || true
    fi
    
    # Link desktop environment configs from local config (self-contained)
    # Prioritize hyprland as primary window manager
    for config_dir in hypr waybar wofi rofi kanshi kitty dunst sway; do
      if [ -d "${config.home.sessionVariables.DOTFILES}/config/.config/$config_dir" ]; then
        ln -sf ${config.home.sessionVariables.DOTFILES}/config/.config/$config_dir $HOME/.config/$config_dir
      fi
    done
    
    # Link additional local config files
    ln -sf ${config.home.sessionVariables.DOTFILES}/config/background.jpg $HOME/background.jpg
  '';

  # nixGL-wrapped Hyprland script
  home.file.".local/bin/hyprland-nixgl" = {
    text = ''
      #!/bin/bash
      # nixGL-wrapped Hyprland for Ubuntu compatibility
      export WLR_DRM_DEVICES=/dev/dri/card1
      export WLR_NO_HARDWARE_CURSORS=1
      export DRI_PRIME=0
      exec nixGLIntel Hyprland "$@"
    '';
    executable = true;
  };
}
