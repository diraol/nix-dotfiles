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
    
    # nixGL for OpenGL support on non-NixOS systems
    nixgl = {
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, flake-utils, nixgl, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          nixgl.overlay
        ];
      };
    in
    {
      # Home Manager configuration (top-level for home-manager to find)
      homeConfigurations = {
        "diraol" = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            config = {
              allowUnfree = true;
              allowUnfreePredicate = _: true;
            };
          };
          modules = [
            ./home.nix
          ];
          extraSpecialArgs = {
            inherit system;
            inherit nixgl;
          };
        };
      };
    } //
    # System-specific outputs using flake-utils
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            nixgl.overlay
          ];
        };
      in
      {
        # Development shell
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            git
            curl
            wget
            nixgl.nixGLIntel
            nixgl.nixVulkanIntel
          ];
        };
      }
    );
}
