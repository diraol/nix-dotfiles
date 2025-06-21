{
  nixGL,
  pkgs,
  ...
}: {
  nixGL = {
    packages = nixGL.packages; # you must set this or everything will be a noop
    defaultWrapper = "mesaPrime"; # Try mesaPrime for Intel graphics
    installScripts = ["mesa" "mesaPrime"];
    vulkan.enable = true; # Enable vulkan for Intel graphics
  };
}
