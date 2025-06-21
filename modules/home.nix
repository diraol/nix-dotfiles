{pkgs, config, ...}: {
  home = let
    DOTFILES = "$HOME/dev/dotfiles-nix";
    user = "diraol";
    awesome-terminal-fonts = pkgs.fetchFromGitHub {
      owner = "gabrielelana";
      repo = "awesome-terminal-fonts";
      rev = "v1.1.0";
      sha256 = "sha256-yBYk5kzgNgHkqiXE/8ptIC1z/0NblvpUmOSAEiLYzqY=";
    };
  in {
    username = user;
    homeDirectory = "/home/${user}";
    stateVersion = "25.05";
    sessionVariables = {
      # Set default applications
      SHELL = "$HOME/.nix-profile/bin/zsh";
      TERMINAL = "kitty";
      VISUAL = "vim";
      EDITOR = "vim";
      BROWSER = "firefox";
      PAGER = "less";
      # Set XDG directories
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_BIN_HOME = "$HOME/.local/bin";
      XDG_LIB_HOME = "$HOME/.local/lib";
      XDG_CACHE_HOME = "$HOME/.cache";
      # Respect XDG directories
      DOCKER_CONFIG = "$HOME/.config/docker";
      LESSHISTFILE = "-"; # Disable less history
      # Python config
      PYTHONDONTWRITEBYTECODE = "true";
      PIP_REQUIRE_VIRTUALENV = "true";
      POETRY_VIRTUALENVS_IN_PROJECT = "true";
      # SSH Agent
      SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/ssh-agent";
      #TODO: Add more variables here
    };
    sessionPath = [
      "$XDG_CACHE_HOME/.bun/bin"
      "$HOME/.local/bin"
      #TODO: Add more paths here ?
    ];

    # Additional font packages for icons and symbols
    packages = with pkgs; [
      # Font management
      fontconfig
      
      # Nerd Fonts - patched fonts with extra glyphs
      nerd-fonts.caskaydia-mono
      nerd-fonts.cousine
      nerd-fonts.droid-sans-mono
      nerd-fonts.fira-code
      nerd-fonts.fira-mono
      nerd-fonts.hack
      nerd-fonts.inconsolata
      nerd-fonts.inconsolata-lgc
      nerd-fonts.jetbrains-mono
      nerd-fonts.meslo-lg
      nerd-fonts.sauce-code-pro
      nerd-fonts.ubuntu
      
      # Additional icon fonts for better compatibility
      font-awesome            # FontAwesome icons
      material-design-icons   # Material Design icons
      
      # Emoji support
      noto-fonts-emoji
    ];
    # awesome terminal fonts setup
    file.".fonts/fontawesome-regular.ttf".source = "${awesome-terminal-fonts}/build/fontawesome-regular.ttf";
    file.".fonts/devicons-regular.ttf".source = "${awesome-terminal-fonts}/build/devicons-regular.ttf";
    file.".fonts/octicons-regular.ttf".source = "${awesome-terminal-fonts}/build/octicons-regular.ttf";
    file.".fonts/pomicons-regular.ttf".source = "${awesome-terminal-fonts}/build/pomicons-regular.ttf";
    
    # font maps (shell scripts with glyph name variables)
    file.".fonts/fontawesome-regular.sh".source = "${awesome-terminal-fonts}/build/fontawesome-regular.sh";
    file.".fonts/devicons-regular.sh".source = "${awesome-terminal-fonts}/build/devicons-regular.sh";
    file.".fonts/octicons-regular.sh".source = "${awesome-terminal-fonts}/build/octicons-regular.sh";
    file.".fonts/pomicons-regular.sh".source = "${awesome-terminal-fonts}/build/pomicons-regular.sh";

    # todo
    # activation scripts for self-contained dotfiles setup
    activation.linkdotfiles = config.lib.dag.entryAfter [ "writeboundary" ] ''
      # create necessary directories
      mkdir -p $HOME/.config $HOME/.fontconfig $HOME/.cache/fontconfig
      
      # refresh font cache to ensure all fonts are available
      ${pkgs.fontconfig}/bin/fc-cache -fv
      
      # link self-contained configuration files from nix-dotfiles
      ln -sf ${DOTFILES}/config/.p10k.zsh $HOME/.p10k.zsh
    #   ln -sf ${DOTFILES}/config/.nurc $HOME/.nurc
    #   ln -sf ${DOTFILES}/config/.nugitconfig $HOME/.nugitconfig
    #   ln -sf ${DOTFILES}/config/.diraol $HOME/.diraol
    #   
    #   # link ssh config from local config (self-contained)
    #   if [ -d "${DOTFILES}/config/.ssh" ]; then
    #     mkdir -p $HOME/.ssh
    #     ln -sf ${DOTFILES}/config/.ssh/* $HOME/.ssh/ 2>/dev/null || true
    #   fi
    #   
    #   # link desktop environment configs from local config (self-contained)
    #   # prioritize hyprland as primary window manager
    #   for config_dir in hypr waybar wofi rofi kanshi kitty dunst sway; do
    #     if [ -d "${DOTFILES}/config/.config/$config_dir" ]; then
    #       ln -sf ${DOTFILES}/config/.config/$config_dir $HOME/.config/$config_dir
    #     fi
    #   done
    #   
    #   # link additional local config files
    #   ln -sf ${DOTFILES}/config/background.jpg $home/background.jpg
    '';

  };

  # ease usage on non-nixos installations
  # targets.genericlinux.enable = true;

  programs.home-manager.enable = true;

  # font configuration
  fonts.fontconfig.enable = true;

  xdg.configFile."environment.d/envvars.conf".text = ''
    path="$home/.nix-profile/bin:$path"
  '';

  # better font rendering
  xdg.configFile."fontconfig/conf.d/1-better-rendering.conf".text = ''
    <!-- better font rendering by changing settings. -->
    <!-- https://wiki.archlinux.org/title/font_configuration -->
    <match target="font">
      <!-- disable embedded bitmaps in fonts to fix calibri, cambria, etc. -->
      <edit name="embeddedbitmap" mode="assign">
        <bool>false</bool>
      </edit>
      <!-- enable anti-aliasing in font rendering -->
      <edit mode="assign" name="antialias">
        <bool>true</bool>
      </edit>
      <!-- enable hinting in font rendering -->
      <edit mode="assign" name="hinting">
        <bool>true</bool>
      </edit>
      <!-- only hint slightly -->
      <edit mode="assign" name="hintstyle">
        <const>hintslight</const>
      </edit>
      <!-- set subpixel rendering to reduce color fringing -->
      <edit mode="assign" name="lcdfilter">
        <const>lcddefault</const>
      </edit>
      <!-- set correct pixel alignment-->
      <edit mode="assign" name="rgba">
        <const>rgb</const>
      </edit>
    </match>
  '';

  # fontconfig for awesome-terminal-fonts fallback
  xdg.configFile."fontconfig/conf.d/10-symbols.conf".text = ''
    <?xml version="1.0"?>
    <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
    <fontconfig>
      <!-- Add awesome-terminal-fonts as fallback for symbols -->
      <alias>
        <family>monospace</family>
        <prefer>
          <family>Inconsolata Nerd Font</family>
          <family>MesloLGS Nerd Font</family>
          <family>FontAwesome</family>
          <family>Devicons</family>
          <family>Octicons</family>
          <family>Pomicons</family>
        </prefer>
      </alias>
    </fontconfig>
  '';

}
