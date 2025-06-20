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
  home.username = "diraol";
  home.homeDirectory = "/home/diraol";

  # This value determines the Home Manager release that your
  # configuration is compatible with.
  home.stateVersion = "23.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Environment variables
  home.sessionVariables = {
    EDITOR = "vim";
    BROWSER = "firefox";
    NIXPKGS_ALLOW_UNFREE = "1";
    DOTFILES = "$HOME/dev/nix-dotfiles";
    DEFAULT_USER = "diraol";
    GITHUB_USER = "diraol";
    # ref: https://github.com/flameshot-org/flameshot/blob/master/docs/Sway%20and%20wlroots%20support.md#basic-steps
    SDL_VIDEODRIVER = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    QT_QPA_PLATFORM = "wayland";
    PYTHON_CONFIGURE_OPTS = "--enable-shared";
  };

  # Session path
  home.sessionPath = [
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

  # XDG directories
  xdg.enable = true;

  # Font configuration
  fonts.fontconfig.enable = true;

  # Additional font packages for icons and symbols
  home.packages = with pkgs; [
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
  ];

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
}
