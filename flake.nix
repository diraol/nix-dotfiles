{
  description = "Ubuntu Nix dotfiles with flakes and home-manager";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Flake utils for easier multi-system support
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, home-manager, flake-utils, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      # Home Manager configuration (top-level for home-manager to find)
      homeConfigurations = {
        "diraol" = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs;
          modules = [
            ./home.nix
          ];
          extraSpecialArgs = {
            inherit system;
          };
        };
      };
    } //
    # System-specific outputs using flake-utils
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        # Development shell
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            git
            curl
            wget
          ];
        };
      }
    );
}
