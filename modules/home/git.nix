{
  programs.git = {
    includes = [
      {path = "/run/secrets/git_config";}
    ];

    enable = true;
    settings.user = {
      name = "Yoann Bigor";
    };
  };
}
