{config, ...}: {
  xdg.configFile = {
    cosmic.source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/dotfiles/cosmic";
    autostart.source = ../../dotfiles/autostart;
  };
}
