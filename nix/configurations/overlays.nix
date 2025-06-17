{ pkgs, lib, self, system, ... }:

let
  inherit (self) inputs;
in {
  nixpkgs.overlays = [
    # inputs.macs.overlay

    (final: prev: {
      stable = import inputs.stable {
        inherit system;
        config = prev.config;
      };

      master = import inputs.master {
        inherit system;
        config = prev.config;
      };

      nubank = import inputs.nubank {
        inherit system;
        config = prev.config;
      };
      # vpn = inputs.vpn.packages.${system}.default;
    })
  ];
}
