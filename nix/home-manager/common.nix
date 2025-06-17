{ config, lib, pkgs, ... }:

let
  dotfilesDir = "$HOME/.dotfiles";
in {
  nixpkgs.config.allowUnfree = true;

  imports = [
    ./programs/cli.nix
    ./programs/clojure.nix
    ./programs/git.nix
    ./programs/nubank.nix
    ./programs/python.nix
    ./programs/network-manager.nix
    ./programs/shell.nix
    ./programs/zsh.nix
    ./programs/tmux.nix
    ./programs/vim.nix
  ];

  home = {
    stateVersion = "25.05";
    packages = with pkgs; [
      nodePackages.eask
      # master.graalvm-ce
      gh
      sway-contrib.grimshot
      imagemagick
      kitty
      kdePackages.polkit-kde-agent-1
      maven
      mariadb
      nodePackages.node2nix
      vesktop
      pandoc
      # stable.postman
      stable.ferdium
      s3cmd
      srt-to-vtt-cl
      pulseaudioFull
      p7zip
      websocat
      hover
      upx
      grim
      hyprshot
    ];
    activation.linkFiles = config.lib.dag.entryAfter [ "writeBoundary" ] ''
      cp -n ${dotfilesDir}/.critical-keys.sample ~/.critical-keys

      ln -sf ${dotfilesDir}/.nubank_aliases ~/.nubank_aliases
      ln -sf ${dotfilesDir}/.nubank_extra ~/.extra
      ln -sf ${dotfilesDir}/.nugitconfig ~/.nugitconfig

      ln -sf ${dotfilesDir}/.gitignore ~/.gitignore

      ln -Tsf ${dotfilesDir}/.config/hypr ~/.config/hypr
      ln -Tsf ${dotfilesDir}/.config/waybar ~/.config/waybar
      ln -Tsf ${dotfilesDir}/.config/kanshi ~/.config/kanshi
      ln -Tsf ${dotfilesDir}/.config/wofi ~/.config/wofi
      ln -Tsf ${dotfilesDir}/.config/dunst ~/.config/dunst
      ln -Tsf ${dotfilesDir}/.config/networkmanager-dmenu ~/.config/networkmanager-dmenu

      ln -Tsf ${dotfilesDir}/.config/kitty ~/.config/kitty

      mkdir -p ~/.config/Code/User
      ln -sf ${dotfilesDir}/.config/Code/User/keybindings.json ~/.config/Code/User/keybindings.json
      ln -sf ${dotfilesDir}/.config/Code/User/settings.json ~/.config/Code/User/settings.json

      ln -Tsf ${dotfilesDir}/.config/clojure ~/.config/clojure
      mkdir -p ~/.config/clojure-lsp
      ln -sf ${dotfilesDir}/.config/clojure-lsp/config.edn ~/.config/clojure-lsp/config.edn
    '';
  };
}
