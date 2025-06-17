{ config, lib, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = false;
    autosuggestion.enable = true;
    syntaxHighlighting = {
      enable = true;
      styles.cursor = "fg=#ffffff";
    };
    profileExtra = ''
      if [[ -z "$XDG_DATA_DIRS" ]]; then
        XDG_DATA_DIRS="/usr/local/share/:/usr/share/"
      fi
      export XDG_DATA_DIRS="$HOME/.nix-profile/share:$HOME/.share:$XDG_DATA_DIRS"
      if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then . $HOME/.nix-profile/etc/profile.d/nix.sh; fi
      # Natural scrolling
      # xinput set-prop 13 324 1
    '';
    # plugins = [ "git" "fzf" ];
    prezto = {
        enable = true;
        pmoduleDirs = [ "${config.home.homeDirectory}/.zprezto-contrib" ];
        pmodules = [ "environment" "editor" "history" "directory" "spectrum" "utility" "completion" "syntax-highlighting" "history-substring-search" "autosuggestions" "prompt" "tmux" "gpg" "git" "docker" "dpkg" "python" "tmux-xpanes" "enhancd" "kubernetes" "direnv" "node" ];
        # autosuggestions.color = "fg=blue";
        editor.keymap = "vi";
        prompt.theme = "powerlevel10k";
        python.virtualenvAutoSwitch = true;
        python.virtualenvInitialize = true;
        syntaxHighlighting.highlighters = [ "main" "brackets" "pattern" "line" "root" ];
        syntaxHighlighting.styles = {
          builtin = "bg=blue";
          command = "bg=blue";
          function = "bg=blue";
        };
        syntaxHighlighting.pattern = {
            "rm*-rf*" = "fg=white,bold,bg=red";
        };
        tmux.autoStartRemote = true;
        utility.safeOps = false;

        extraModules = [ "enhancd" ];
        extraConfig = ''
            zstyle ":prezto:module:enhancd" command "fzf"
            zstyle ":prezto:module:enhancd" command "cd"
        '';
    };

    plugins = [
      {
        name = "prezto-contrib";
        src = pkgs.fetchFromGitHub {
          owner = "belak";
          repo = "prezto-contrib";
          rev = "a05508a716cad6e45e90cb8b0f73c811cbd4438a";
          sha256 = "sha256-nGbrc4Q66jyOHrEQOt0gyRbllqguoKAAIDoltNIyvJc=";
          fetchSubmodules = true;
        };
      }
    ];
  };
}
