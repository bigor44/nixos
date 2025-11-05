/*
Title: Module Options
Description: Defines custom options for enabling and disabling different modules in the NixOS configuration.
*/
{lib, ...}: {
  options = {
    adblocker.enable = lib.mkEnableOption "Enable Adguard Home";
    desktop.enable = lib.mkEnableOption "Enable desktop environment";
    llm.enable = lib.mkEnableOption "Enable Ollama";
    sshserver.enable = lib.mkEnableOption "Enable SSH Server";
    dashboard.enable = lib.mkEnableOption "Enable Grafana & Prometheus";
    monitoring.enable = lib.mkEnableOption "Enable Prometheus node exporter";
  };
}
