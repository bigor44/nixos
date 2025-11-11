/*
  Title: Module Options
  Description: Defines custom options for enabling and disabling different modules in the NixOS configuration.
*/
{ lib, ... }:
{
  options = {
    adblocker.enable = lib.mkEnableOption "Enable Adguard Home";
    desktop.enable = lib.mkEnableOption "Enable desktop environment";
    server.enable = lib.mkEnableOption "Enable SSH Server";
    nfs.client.enable = lib.mkEnableOption "Enable nfs client";
    nfs.server.enable = lib.mkEnableOption "Enable nfs server";
  };
}
