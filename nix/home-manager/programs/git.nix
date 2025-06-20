{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs;
    [
      difftastic
    ];
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.hub;
    # userName = "Diego Rabatone Oliveira";
    # userEmail = "diraol@diraol.eng.br";
    # includes = [{ path = "~/.dotfiles/.gitconfig"; }];
  };
}
