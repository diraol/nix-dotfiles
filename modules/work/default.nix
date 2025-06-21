{
  lib,
  pkgs,
  ...
}: let
  zsh_start_logic = ''
    if [ -x "$HOME/.nix-profile/bin/zsh" ]; then
        export PATH="$HOME/.nix-profile/bin:$PATH" # Add to PATH
    fi
  '';
in {
  # Add packages
  home.packages = lib.mkMerge [
    (with pkgs; [
      # TODO: Nubank stuff
      # aws-signing-helper
      awscli
    ])
  ];

  # Bash configuration
  # Workaround since chsh -s is not persisted on company laptop
  home.file = {
    ".bashrc".text = zsh_start_logic;
    ".zshrc".text = zsh_start_logic;
  };

  # Take system packages for git and ssh since I could not get Nix to support GSSAPIKeyExchange that is enabled at work.
  # https://github.com/nix-community/home-manager/issues/4763#issuecomment-1986996921
  programs.git.package = lib.mkForce pkgs.emptyDirectory;
  programs.ssh.package = lib.mkForce pkgs.emptyDirectory;
}
