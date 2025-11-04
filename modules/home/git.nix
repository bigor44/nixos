/*
  Title: Git Configuration
  Description: Enables and configures Git with user details.
*/
{
  programs.git = {
    enable = true;
    settings.user = {
      name = "Yoann Bigor";
      email = "bigor44@gmail.com";
    };
  };
}
