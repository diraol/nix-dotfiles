{ pkgs, config, ... }:
let
  dotfilesDir = "$HOME/.dotfiles";
  master = import (fetchTarball https://github.com/NixOS/nixpkgs/archive/master.tar.gz) {};

in {
  imports = [
    ./common/programs.nix
    ./common/tmux.nix
  ];

  home = {
    packages = with pkgs; [
      master.alda
      blender
      master.graalvm11-ce
      heroku
      imagemagick
      mysql
      nodePackages.node2nix
      omnisharp-roslyn
      pandoc
      postman
      rust-analyzer
      s3cmd
      sass
      sassc
      srt-to-vtt-cl
      rustup
      skype
      teamviewer
      unityhub
      websocat
    ];
    activation.linkFiles = config.lib.dag.entryAfter ["writeBoundary"] ''
        cp -n ${dotfilesDir}/.critical-keys.sample ~/.critical-keys
        ln -Tsf ${dotfilesDir}/.env ~/.env
        ln -sf ${dotfilesDir}/.zsh_aliases ~/.zsh_aliases
        ln -sf ${dotfilesDir}/.frigocenter_aliases ~/.frigocenter_aliases
        ln -sf ${dotfilesDir}/.zshrc ~/.zshrc
        ln -sf ${dotfilesDir}/.functions ~/.functions

        ln -Tsf ${dotfilesDir}/.config/bspwm ~/.config/bspwm
        ln -Tsf ${dotfilesDir}/.config/sxhkd ~/.config/sxhkd
        ln -Tsf ${dotfilesDir}/.config/rofi ~/.config/rofi
        ln -Tsf ${dotfilesDir}/.config/polybar ~/.config/polybar
        ln -Tsf ${dotfilesDir}/.config/dunst ~/.config/dunst
        ln -Tsf ${dotfilesDir}/.config/networkmanager-dmenu ~/.config/networkmanager-dmenu
        ln -Tsf ${dotfilesDir}/.config/libinput-gestures.conf ~/.config/libinput-gestures.conf

        ln -Tsf ${dotfilesDir}/.doom.d ~/.doom.d
        ln -Tsf ${dotfilesDir}/.lsp ~/.lsp
        ln -Tsf ${dotfilesDir}/.clj-kondo ~/.clj-kondo
        ln -sf ${dotfilesDir}/.joker ~/.joker
        ln -Tsf ${dotfilesDir}/.jokerd ~/.jokerd

        ln -sf ${dotfilesDir}/.gitconfig ~/.gitconfig
        ln -sf ${dotfilesDir}/.gitignore_global ~/.gitignore_global

        ln -sf ${dotfilesDir}/.tmdb-functions ~/.tmdb-functions
        ln -sf ${dotfilesDir}/.gregflix-functions ~/.gregflix-functions
        ln -sf ${dotfilesDir}/.s3cfg ~/.s3cfg

        ln -Tsf ${dotfilesDir}/.tmuxinator ~/.tmuxinator

        ln -sf ${dotfilesDir}/.vimrc ~/.vimrc

        ln -sf ${dotfilesDir}/.config/Code/User/keybindings.json ~/.config/Code/User/keybindings.json
        ln -sf ${dotfilesDir}/.config/Code/User/settings.json ~/.config/Code/User/settings.json

        ln -sf ${dotfilesDir}/.Xresources ~/.Xresources

        mkdir -p ~/.android/avd/device.avd
        ln -sf ${dotfilesDir}/nix/android/emulator-config.ini ~/.android/avd/device.avd/config.ini
    '';
  };
}
