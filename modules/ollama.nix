{...}: {
  services.ollama = {
    enable = true;
    acceleration = "rocm";
  };
  services.open-webui = {
    enable = true;
    host = "0.0.0.0";
    openFirewall = true;
    environment = {
      ANONYMIZED_TELEMETRY = "False";
      DO_NOT_TRACK = "True";
      SCARF_NO_ANALYTICS = "True";
      WEBUI_AUTH = "False";
    };
  };
}
