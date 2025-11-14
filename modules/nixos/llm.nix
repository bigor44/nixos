{lib, config, ...}:
lib.mkIf config.server.enable {
  services.ollama = {
    enable = true;
    acceleration = "rocm";
    loadModels = [
      "qwen3-coder"
      "deepseek-r1:32b"
      "codellama:34b-instruct"
    ];
  };
}
