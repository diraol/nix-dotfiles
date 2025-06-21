{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./chrome.nix
    ./firefox.nix
    ./vscode.nix
    # Fix for GPU stuff on non-nixos systems
    ./nixgl.nix
    # ./hyprland.nix
    ./sway.nix
  ];

  # Add packages
  home.packages = lib.mkMerge [
    (with pkgs; [
      (config.lib.nixGL.wrap spotify)
      (config.lib.nixGL.wrap zed-editor)
      dunst
      grim
      kanshi
      slurp
      swaybg
      swayidle
      wdisplays
      wl-clipboard
    ])
  ];
}
