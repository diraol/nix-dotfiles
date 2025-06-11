{ config, lib, inputs, system, pkgs, ... }:

{
  home.packages = [
    pkgs.vpn
  ];

  xdg.desktopEntries = {
    vpn = {
      name = "GlobalProtect Openconnect VPN Client";
      genericName = "GlobalProtect VPN Client";
      exec = "gpclient launch-gui %u";
      terminal = true;
      categories = [ "Application" "Network"];
      mimeType = [ "x-scheme-handler/globalprotectcallback" ];
    };
  };
}

# TODO: Download https://github.com/nubank/ansible-pull/blob/master/common/files/Zscaler-linux-3.7.1.71-installer.run
