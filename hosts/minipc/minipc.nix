{ ... }:
{
  networking.hostName = "minipc";
  audio.enable = false;
  bluetooth.enable = false;
  adblocker.enable = true;
  desktop.enable = false;
  llm.enable = true;
  sshserver.enable = true;
  podman.enable = false;
  monitoring.enable = true;
  dashboard.enable = true;
}
