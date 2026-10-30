# Platform: dev
# Purpose: System git with gh credentials, git abbreviations, compilers and AI coding CLIs
{ pkgs, ... }:
{
  programs = {
    git = {
      enable = true;
      # gh stores the GitHub token; git asks it instead of keeping its own credentials.
      # Identity stays per-user in Home Manager (modules/home/git.nix)
      config.credential = {
        "https://github.com".helper = "${pkgs.gh}/bin/gh auth git-credential";
        "https://gist.github.com".helper = "${pkgs.gh}/bin/gh auth git-credential";
      };
    };
    # Abbreviations rather than aliases: they expand on the command line, so history shows the real command
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
      # The system Python is read-only; uv handles per-project venvs and tools
      uv
    ];
  };
}
