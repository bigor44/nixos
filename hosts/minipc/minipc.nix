{...}: {
  networking.hostName = "minipc";
  adblocker.enable = true;
  desktop.enable = false;
  llm.enable = true;
  sshserver.enable = true;
  monitoring.enable = true;
  dashboard.enable = true;
}
