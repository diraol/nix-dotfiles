{ config, lib, self, system, pkgs, ... }:

{
  imports = [
    ../../configuration.nix
  ];

  home-manager.users.diraol = {
    imports = [
      ../../home-manager/common.nix
      ../../configurations/overlays.nix
      ../../home-manager/programs/zsh.nix
      ../../home-manager/programs/clojure.nix
      ../../home-manager/programs/vscode.nix
      ../../home-manager/programs/idea.nix
      ../../home-manager/programs/python.nix
      ../../home-manager/programs/nubank.nix
      ../../home-manager/programs/java.nix
      ../../home-manager/programs/opentofu.nix
    ];
  };
  networking.hostName = "diraol-nubank";

  boot = {
    extraModprobeConfig = ''options bluetooth disable_ertm=1'';
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/fa09abc3-cb9e-4a15-a5cf-e756fbb8e960";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/72B4-1BAE";
    fsType = "vfat";
    options = [ "fmask=0022" "dmask=0022" ];
  };

  swapDevices = [{
    device = "/dev/disk/by-uuid/d8325f60-ea5a-4da2-8124-1144775be653";
  }];

  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
}
