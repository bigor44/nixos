{ pkgs, ... }:
{
  programs.nixvim = {
    extraPackages = with pkgs; [
      curl # Required by avante for API calls
    ];

    plugins.avante = {
      enable = true;
      settings = {
        provider = "claude";
        providers = {
          claude = {
            model = "claude-sonnet-4-20250514";
            extra_request_body = {
              max_tokens = 4096;
            };
          };
        };
        behaviour = {
          auto_suggestions = false;
          auto_set_keymaps = true;
        };
        hints = {
          enabled = true;
        };
      };
    };
  };
}
