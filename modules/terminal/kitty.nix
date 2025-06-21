{
  pkgs,
  pkgs-stable,
  config,
  ...
}: {
  xdg.configFile."kitty/theme.conf".source = ../../config/.config/kitty/themes/GruvBoxMaterialDarkSoft.conf;
  programs.kitty = {
    enable = true
    settings = {
      copy_on_select = "clipboard";
      dynamic_background_opacity = true;
      enable_audio_bell = false;
      scrollback_lines = 10000;
      shell = "zsh";
      show_hyperlink_targets = "yes";
      underline_hyperlinks = "never";
      url_style = "none";
      window_padding_width = 10;
    };
    themeFile = "GruvboxMaterialDarkSoft";
    # Samples at: https://github.com/dexpota/kitty-themes
    # Themes from: https://github.com/kovidgoyal/kitty-themes
    # afterglow
    # apprentice
    # arthur
    # AtelierSulphurpool
    # ayu mirage
    # Blazer
    # Broadcast
    # Chalk
    # ciapre
    # desert
    # Dracula
    # earthsong
    # espresso
    # flat
    # flatland
    # gruvbox dark
    # GruvboxMaterialDarkSoft

    font = "Inconsolata Nerd Font";
  };
}
