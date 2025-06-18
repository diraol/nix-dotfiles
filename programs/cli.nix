{ config, pkgs, ... }:

{
  # CLI packages
  home.packages = with pkgs; [
    # Development tools
    git
    gh
    curl
    wget
    jq
    
    # Text processing
    ripgrep
    fd
    fzf
    tree
    htop
    
    # Text editors
    nano
    
    # Terminal utilities
    tmux
    tmuxinator
    
    # Build tools
    gnumake
    gcc
    
    # System utilities
    unzip
    zip
    p7zip
    bzip2
    imagemagick
    
    # Network tools
    openssh
    
    # File management
    rsync
    
    # Audio and notifications
    espeak
    libnotify  # for notify-send
    
    # Additional zsh-related tools
    xclip      # for clipboard operations
    
    # Development languages
    nodejs
    python3
    
    # Optional tools (commented out - uncomment as needed)
    # bat         # Better cat
    # exa         # Better ls  
    # zoxide      # Smart cd
    # lazygit     # Git TUI
    # lazydocker  # Docker TUI
    # go          # Go language
    # rustc       # Rust compiler
    # cargo       # Rust package manager
    
    # Android development (if needed)
    # android-tools
    
    # Flutter development (if needed)
    # flutter
  ];

  # Vim configuration
  programs.vim = {
    enable = true;
    defaultEditor = true;
    settings = {
      expandtab = true;
      history = 1000;
      ignorecase = true;
      mouse = "a";
      number = true;
      shiftwidth = 2;
      smartcase = true;
      tabstop = 2;
    };
    extraConfig = ''
      " Basic settings
      set nocompatible
      set encoding=utf-8
      set fileencoding=utf-8
      set backspace=indent,eol,start
      
      " Search settings
      set hlsearch
      set incsearch
      
      " Display settings
      set showcmd
      set showmatch
      set ruler
      set laststatus=2
      
      " Syntax highlighting
      syntax on
      filetype plugin indent on
      
      " Color scheme
      set background=dark
      
      " Remove trailing whitespace on save
      autocmd BufWritePre * :%s/\s\+$//e
    '';
  };
} 