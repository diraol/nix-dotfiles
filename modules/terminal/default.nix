{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./git.nix
    ./kitty.nix
    ./kubernetes.nix
    ./ssh.nix
    ./tmux.nix
    ./zsh.nix
  ];

  # Add packages
  home.packages = lib.mkMerge [
    (with pkgs; [
      # Nix related
      alejandra  # nix code formatter

      # Dev tools
      curl
      ipcalc
      jq
      uv
      wget
      yq-go

      # Text processing
      fd
      fzf
      htop
      ripgrep
      tree

      # Terminal utilities
      tmux

      # Build Tools
      gnumake
      gcc

      # System Utilities
      unzip
      zip
      p7zip
      bzip2
      imagemagick

      # Network tools
      openssh

      # File management
      rsync

      # Audio and Notifications
      # espeak
      # libnotify  # NOTE: Check if we need it.

      # NOTE: Fonts were moved "up" to home.nix
      
      # Others
      rclone # Rclone is a command-line program to manage files on cloud storage
      tealdeer # tldr tooling - https://github.com/tealdeer-rs/tealdeer
      yt-dlp # fork of youtube-dl

      # Disabled, don't need for now
      # docker-compose
      # git-crypt

      # TODO: Move to nubank specific
      jira-cli-go

      # TODO: To be discovered
      # choose
      # delta
      # dogdns
      # glances
      # go-migrate
      # helmfile
      # httpie
      # mmv
      # ncdu
    ])
  ];

  # Allow fontconfig to discover fonts and configurations installed through home.packages
  fonts.fontconfig.enable = true;

  programs.nix-index.enable = true;

  programs.micro = {
    enable = true;
    settings = {
      colorscheme = "nord-16"; # installed via below
    };
  };

  xdg.configFile."micro/colorschemes/nord-16.micro".source = "${pkgs.fetchFromGitHub {
    owner = "KiranWells";
    repo = "micro-nord-tc-colors";
    rev = "132e847cb02ee20bfae566212d0358f0f98313cb";
    sha256 = "m1qOvnfOCE8itE/LkDWeZ7yyIUXcAlAvw8FPWZeGfvw="; # nix flake prefetch github:KiranWells/micro-nord-tc-colors/132e847cb02ee20bfae566212d0358f0f98313cb
  }}/colorschemes/nord-16.micro";

  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [
      #batdiff
      batman
      batgrep
      batwatch
    ];
    config = {
      theme = "Nord";
      italic-text = "never";
      # Show line numbers, Git modifications and file header (but no grid)
      style = "numbers,changes,header,grid";
      # Add mouse scrolling support in less (does not work with older
      # versions of "less").
      pager = "less -FR";
      # Use "gitignore" highlighting for ".ignore" files
      map-syntax = [".ignore:.gitignore" "*.jenkinsfile:Groovy"];
    };
  };
}
