{lib, config, ...}:
lib.mkIf config.server.enable {
  services.ollama = {
    enable = true;
    acceleration = "rocm";
    loadModels = [
      "qwen3-coder"
      "mistral-small3.2"
      "gemma3"
    ];
  };
}
