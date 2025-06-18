# This file is mainly for NixOS systems, but included for reference
# Since you're on Ubuntu, you'll primarily use home.nix for configuration

{ config, pkgs, ... }:

{
  # This is a reference configuration for NixOS
  # On Ubuntu, you'll mainly use home-manager (home.nix) instead
  
  # System packages that would be installed system-wide on NixOS
  # On Ubuntu, these would go in home.nix instead
  environment.systemPackages = with pkgs; [
    vim
    git
    curl
    wget
    htop
  ];

  # Enable flakes (for NixOS systems)
  # Note: On Ubuntu with single-user Nix, this is configured in ~/.config/nix/nix.conf
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken.
  system.stateVersion = "23.11";
}
