{...}: {
  services.ollama = {
    enable = true;
    acceleration = "rocm";
    environmentVariables = {
      HCC_AMDGPU_TARGET = "gfx1031"; # used to be necessary, but doesn't seem to anymore
    };
  };
  services.open-webui.enable = true;
}
