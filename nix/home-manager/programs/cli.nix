{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    ### Wifi/hacking tools
    # aircrack-ng
    # hashcat
    # hashcat-utils
    # hcxtools
    aider-chat
    ollama
    awscli
    stable.appimage-run
    aspell
    aspellDicts.en
    aspellDicts.en-computers
    bzip2
    cachix
    curl
    copilot-language-server-fhs
    docker-compose
    espeak
    envsubst
    fd
    fzf
    file
    ffmpeg
    fontconfig
    gitFull
    gnumake
    stable.gnupg
    go
    gotop
    grub2
    inotify-tools
    jq
    killall
    libvterm-neovim
    lshw
    man-pages
    nssTools
    mediainfo
    neofetch
    nodejs_20
    curlftpfs
    openssl
    pinentry
    ripgrep
    rxvt-unicode
    stable.sbt
    shellcheck
    sqlite
    inetutils
    translate-shell
    tree
    unrar
    unzip
    usbutils
    wget
    wirelesstools
    wmctrl
    xdotool
    xsel
  ];
}
