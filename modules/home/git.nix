# Home: git
# Purpose: Git, GitHub CLI, and Fish shell aliases
{
  programs = {
    git = {
      enable = true;
      settings = {
        user = {
          name = "Yoann Bigor";
          email = "bigor44@gmail.com";
        };
      };
    };

    # Also registers gh as the git credential helper for github.com
    gh.enable = true;

    fish.shellAliases = {
      g = "git";
      gaa = "git add -A";
      gc = "git commit";
      gcm = "git commit -m";
      gca = "git commit --amend";
      gd = "git diff";
      gds = "git diff --staged";
      gl = "git pull";
      gp = "git push";
      gpf = "git push --force-with-lease";
      gst = "git status";
      gco = "git checkout";
      gcb = "git checkout -b";
      gb = "git branch";
      glog = "git log --oneline --graph --decorate";
    };
  };
}
