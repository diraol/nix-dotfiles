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
    prezto = {
        enable = true;
        pmodulesDirs = [ "''${config.home.homeDirectory}/.zprezto-contrib" ];
        plugins = [ "git" "fzf" ];
        pmodules = [ "environment" "editor" "history" "directory" "spectrum" "utility" "completion" "syntax-highlighting" "history-substring-search" "autosuggestions" "prompt" "tmux" "gpg" "git" "docker" "dpkg" "python" "tmux-xpanes" "enhancd" "kubernetes" "direnv" "node" ];
        # autosuggestions.color = "fg=blue";
        editor.keymap = "vi";
        prompt.theme = "powerlevel10k";
        virtualenvAutoSwitch = true;
        virualenvInitialize = true;
        syntaxHighlighting.highlighters = [ "main" "brackets" "pattern" "line" "root" ];
        styles = {
          builtin = "bg=blue";
          command = "bg=blue";
          function = "bg=blue";
        };
        pattern = {
            "rm*-rf*" = "fg=white,bold,bg=red";
        };
        tmux.autoStartRemote = true;
        utility.safeOps = false;

        extraConfig = {

        };
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
          fetchSubmodules = true;
        };
      }
    ];
  };
}
