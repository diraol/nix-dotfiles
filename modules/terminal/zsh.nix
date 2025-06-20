{ config, pkgs, lib, ... }:

let
  prezto-contrib = pkgs.fetchFromGitHub {
    owner = "belak";
    repo = "prezto-contrib";
    rev = "a05508a716cad6e45e90cb8b0f73c811cbd4438a";
    sha256 = "sha256-nGbrc4Q66jyOHrEQOt0gyRbllqguoKAAIDoltNIyvJc=";
    fetchSubmodules = true;
  };
in
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    
    # History configuration
    history = {
      size = 10000;
      save = 10000;
      extended = true;
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
    };
    
    # Prezto configuration
    prezto = {
      enable = true;
      pmoduleDirs = [ "${config.home.homeDirectory}/.zprezto-contrib" ];
      pmodules = [
        "environment"
        "editor"
        "history"
        "directory"
        "spectrum"
        "utility"
        "completion"
        "syntax-highlighting"
        "history-substring-search"
        "autosuggestions"
        "prompt"
        "tmux"
        "gpg"
        "git"
        "docker"
        "dpkg"
        "python"
        "tmux-xpanes"
        "enhancd"
        "kubernetes"
        "gcloud"
        "direnv"
        "node"
      ];
      
      # Editor settings
      editor = {
        keymap = "vi";
        dotExpansion = false;
      };
      
      # Prompt theme
      prompt.theme = "powerlevel10k";
      
      # Python settings
      python.virtualenvAutoSwitch = true;
      python.virtualenvInitialize = true;
      
      # Tmux settings
      tmux.autoStartRemote = true;
      
      # Utility settings - disable safe-ops to match original config
      utility.safeOps = false;
      
      # Additional configuration for prezto-contrib and enhancd
      extraConfig = ''
        # Add additional directories to load prezto modules from
        # zstyle ':prezto:load' pmodule-dirs $HOME/.zprezto-contrib
        
        # Enhanced from prezto-contrib
        zstyle ":prezto:module:enhancd" command "fzf"
        zstyle ":prezto:module:enhancd" command "cd"
      '';
    };
    
    # Environment variables
    sessionVariables = {
      EDITOR = "vim";
      GPG_TTY = "$(tty)";
    };
    
    # Basic zsh configuration
    initContent = ''
      # Ensure Nix is available in single-user setup
      if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
        source "$HOME/.nix-profile/etc/profile.d/nix.sh"
      fi
      
      # Load awesome-terminal-fonts font maps (glyph name variables)
      if [ -d "$HOME/.fonts" ]; then
        for fontmap in "$HOME/.fonts"/*.sh; do
          [ -r "$fontmap" ] && source "$fontmap"
        done
      fi
      
      # Load my personal configs
      if [ -e "$HOME/.diraol/rc" ]; then
        source "$HOME/.diraol/rc"
      fi

      # zsh/zprezto-contrib enhancd plugin
      ENHANCD_DOT_ARG="..."

      bindkey -M viins '^r' history-incremental-search-backward
      bindkey -M vicmd '^r' history-incremental-search-backward
      
      [[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
      
      # Load Nubank's configs
      if [ -e "$HOME/.nurc" ]; then
        source "$HOME/.nurc"
      fi

      # Load local zsh aliases (self-contained)
      [ -f "$DOTFILES/config/.zsh_aliases" ] && source "$DOTFILES/config/.zsh_aliases"

      # Vi mode key bindings
      bindkey -v
      
      # Auto-completion initialization
      autoload -Uz compinit && compinit
    '';
  };

  # Link prezto-contrib to the expected location
  home.file.".zprezto-contrib".source = prezto-contrib;

  # Zsh and powerlevel10k packages
  home.packages = with pkgs; [
    zsh
    zsh-powerlevel10k
  ];
} 
