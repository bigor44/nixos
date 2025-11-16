{
  lib,
  config,
  ...
}:
lib.mkIf config.server.enable {
  services.ollama = {
    enable = true;
    acceleration = "rocm";
  };
}
