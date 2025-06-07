{ pkgs, config, self, ... }:
let
  username = "diraol";
in
{
  imports = [
    ../../home-manager/common.nix
    ../../configurations/overlays.nix
    ../../home-manager/programs/vscode.nix
    ../../home-manager/programs/clojure.nix
    ../../home-manager/programs/python.nix
    ../../home-manager/programs/java.nix
    ../../home-manager/programs/idea.nix
    ../../home-manager/programs/zsh.nix
  ];

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    sessionVariables = {
      DOTFILES = "$HOME/.dotfiles";
      NIXOS_OZONE_WL = "1";
    };
  };
}
