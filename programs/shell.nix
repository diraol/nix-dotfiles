{ config, pkgs, ... }:

{
  # Enhanced Bash configuration - migrated from dotfiles
  programs.bash = {
    enable = true;
    enableCompletion = true;
    
    historyControl = [ "ignoreboth" ];
    historySize = 1000;
    historyFileSize = 2000;
    
    shellOptions = [
      "histappend"
      "checkwinsize"
    ];
    
    bashrcExtra = ''
      # Ensure Nix is available in single-user setup
      if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
        source "$HOME/.nix-profile/etc/profile.d/nix.sh"
      fi
      
      # Source custom rc file (if exists)
      if [ -f "$HOME/.diraol/rc" ]; then
        source "$HOME/.diraol/rc"
      fi
      
      # Color prompt setup
      force_color_prompt=yes
      if [ -n "$force_color_prompt" ]; then
          if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
              color_prompt=yes
          else
              color_prompt=
          fi
      fi
      
      if [ "$color_prompt" = yes ]; then
          PS1='$\{debian_chroot:+($debian_chroot)\}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
      else
          PS1='$\{debian_chroot:+($debian_chroot)\}\u@\h:\w\$ '
      fi
      unset color_prompt force_color_prompt
      
      # Custom aliases
      alias ll='ls -alF'
      alias la='ls -A'
      alias l='ls -CF'
      alias grep='grep --color=auto'
      alias fgrep='fgrep --color=auto'
      alias egrep='egrep --color=auto'
      
      # Enable color support of ls
      if [ -x /usr/bin/dircolors ]; then
          test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
          alias ls='ls --color=auto'
      fi
      
      # FZF integration
      [ -f ~/.fzf.bash ] && source ~/.fzf.bash
      
      # Nubank specific configs (if file exists)
      [ -f ~/.nurc ] && source ~/.nurc
      
      # Custom bash aliases (if file exists)
      [ -f ~/.bash_aliases ] && source ~/.bash_aliases
      
      # Environment variables
      export NIXPKGS_ALLOW_UNFREE=1
      export EDITOR=vim
      export BROWSER=firefox
    '';
  };

  # Note: Direnv and FZF are configured in programs/zsh.nix for ZSH integration
  # If you primarily use bash, uncomment these:
  # programs.direnv = {
  #   enable = true;
  #   enableBashIntegration = true;
  #   nix-direnv.enable = true;
  # };
  # programs.fzf = {
  #   enable = true;
  #   enableBashIntegration = true;
  #   defaultCommand = "fd --type f";
  #   defaultOptions = [ "--height 40%" "--border" ];
  # };
} 