{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    
    # History configuration
    history = {
      size = 10000;
      save = 10000;
      extended = true;
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
    };
    
    # ZSH plugins configuration
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];
    
    # Oh My Zsh configuration (alternative to Prezto for Nix compatibility)
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "docker"
        "kubectl"
        "python"
        "node"
        "npm"
        "fzf"
        "tmux"
      ];
      # Note: powerlevel10k theme is loaded manually from Nix package below
    };
    
    # Core shell aliases (system integration only)
    # Note: User-customizable aliases are in config/.zsh_aliases
    shellAliases = {
      # Leave empty or add only core system integration aliases
      # All user aliases are now defined in config/.zsh_aliases for easy customization
    };
    
    # Environment variables
    sessionVariables = {
      # Development environments
      NU_HOME = "$HOME/dev/nu";
      NUCLI_HOME = "$NU_HOME/nucli";
      GOPATH = "$HOME/go";
      
      # Android development
      # ANDROID_HOME = "$HOME/Android/Sdk";
      # ANDROID_SDK = "$ANDROID_HOME";
      
      # Flutter development
      # FLUTTER_SDK_HOME = "$HOME/sdk-flutter";
      # FLUTTER_ROOT = "$FLUTTER_SDK_HOME";
      
      # Mobile monorepo
      # MONOREPO_ROOT = "$NU_HOME/mini-meta-repo";
      
      # NVM
      NVM_DIR = "$HOME/.nvm";
      
      # GPG
      GPG_TTY = "$(tty)";
      
      # Enhancd plugin configuration
      ENHANCD_DOT_ARG = "...";
    };
    
    # Custom zsh configuration
    initContent = ''
      # Ensure Nix is available in single-user setup
      if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
        source "$HOME/.nix-profile/etc/profile.d/nix.sh"
      fi
      
      # Source custom rc file (if exists)
      if [ -f "$HOME/.diraol/rc" ]; then
        source "$HOME/.diraol/rc"
      fi
      
      # Source critical keys and environment
      [ -f ~/.critical-keys ] && source ~/.critical-keys
      [ -f ~/.env ] && source ~/.env
      
      # Vi mode key bindings
      bindkey -v
      bindkey -M viins '^r' history-incremental-search-backward
      bindkey -M vicmd '^r' history-incremental-search-backward
      
      # FZF integration
      [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
      
      # P10K theme configuration (self-contained)
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
      
      # Nubank specific configurations (self-contained)
      [ -f ~/.nurc ] && source ~/.nurc
      # Note: Nubank aliases are now included in local .zsh_aliases
      
      # NVM integration
      [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
      [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
      
      # Nodenv integration
      command -v nodenv >/dev/null 2>&1 && eval "$(nodenv init -)"
      
      # Nucli completion
      if [ -f "$NU_HOME/nucli/nu.bashcompletion" ]; then
        source "$NU_HOME/nucli/nu.bashcompletion"
      fi
      
      # SSH key auto-loading
      [ -f ~/.ssh/github ] && ssh-add ~/.ssh/github > /dev/null 2>&1
      
      # Homebrew integration (if installed)
      if [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        export XDG_DATA_DIRS="/home/linuxbrew/.linuxbrew/share:$XDG_DATA_DIRS"
      fi
      
      # Custom completions
      fpath=(~/.zsh/completion $fpath)
      
      # Auto-completion initialization
      autoload -Uz compinit && compinit
      
      # Local zsh aliases (self-contained)
      [ -f "$DOTFILES/config/.zsh_aliases" ] && source "$DOTFILES/config/.zsh_aliases"
      
      # Auto-start Hyprland on TTY1 login (optional)
      # Uncomment the following lines to auto-start Hyprland:
      # if [ "$(tty)" = "/dev/tty1" ]; then
      #   exec Hyprland
      # fi
    '';
  };

  # Install zsh plugins and tools
  home.packages = with pkgs; [
    zsh
    # Note: zsh-powerlevel10k is handled by plugins configuration above
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-history-substring-search
    
    # Comprehensive Nerd Fonts for powerlevel10k icons and symbols
    nerd-fonts.inconsolata       # System fallback
    nerd-fonts.meslo-lg          # Recommended for powerlevel10k
    nerd-fonts.fira-code         # Popular programming font
    nerd-fonts.hack              # Clean monospace font
    nerd-fonts.dejavu-sans-mono  # System fallback
  ];

  # Note: Powerlevel10k configuration is self-contained in ../config/.p10k.zsh
  # Edit that file to customize your prompt appearance and segments

  # Direnv integration for zsh
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  # FZF integration for zsh
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "fd --type f";
    defaultOptions = [ "--height 40%" "--border" ];
  };
} 