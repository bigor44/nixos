# Platform: ollama
# Purpose: Ollama LLM server on the RX 7800 XT via ROCm (API on localhost:11434)
{ pkgs, ... }:
{
  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm;
    environmentVariables = {
      # rocminfo also lists the Radeon 610M iGPU (gfx1036), which ROCm does not support
      ROCR_VISIBLE_DEVICES = "GPU-243e7b6761295453";
      # Default is 4k on a 16 GB card; agent tools (opencode) need room for their system prompt and files
      OLLAMA_CONTEXT_LENGTH = "32768";
    };
  };
}
