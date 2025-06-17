{ config, lib, pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    profiles.default.extensions = with pkgs.vscode-extensions; [
        # bbenoist.Nix
        # ms-python.python
        formulahendry.code-runner
        ms-dotnettools.csharp
        # msjsdiag.debugger-for-chrome
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "calva";
        publisher = "betterthantomorrow";
        version = "2.0.486";
        sha256 = "sha256-pL+OgJvIK5eqE5Kr/wDeJ+2BGUT9Uj42coWSHtbPolk=";
      }
    ];
  };
}
