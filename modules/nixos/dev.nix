{ pkgs, ... }:
{
  programs = {
    git = {
      enable = true;
      config.credential = {
        "https://github.com".helper = "${pkgs.gh}/bin/gh auth git-credential";
        "https://gist.github.com".helper = "${pkgs.gh}/bin/gh auth git-credential";
      };
    };
    fish.shellAbbrs = {
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
  environment = {
    systemPackages = with pkgs; [
      gh
      claude-code
      antigravity-cli
      gcc
      gnumake
      python3
      uv
    ];
  };
}
