{ config, pkgs, system, self, ... }:
let
  inherit (self) inputs;
in
{
  nixpkgs.config.allowUnfree = true;

  imports =
    [
      self.inputs.home-manager.nixosModules.home-manager
      ./configurations/overlays.nix
      ./configurations/boot.nix
      ./configurations/hardware.nix
      ./configurations/desktop.nix
      ./configurations/cli.nix
      ./configurations/misc.nix
    ];

  home-manager = {
    useUserPackages = true;
    extraSpecialArgs = {
      inherit self system;
    };
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  services.printing.enable = true;

  users.users.diraol = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "docker"
      "networkmanager"
      "video"
      "audio"
      "sound"
      "adbusers"
      "input"
    ];

    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;
  };

  security.sudo.extraRules= [
    {  users = [ "diraol" ];
       commands = [
         { command = "ALL" ;
           options= [ "NOPASSWD" ];
         }
       ];
    }
  ];

  nix = {
    settings.allowed-users = [ "diraol" ];
    settings.trusted-users = [ "root" "diraol" ];
    nixPath = [
      "nixpkgs=${self.inputs.nixpkgs}"
    ];

    package = pkgs.nixVersions.stable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  system.stateVersion = "25.05";
}
