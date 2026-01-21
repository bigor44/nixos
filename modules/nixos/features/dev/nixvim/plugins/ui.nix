# Feature: nixvim-ui
# Purpose: UI plugins and visual enhancements for nixvim
{
  programs.nixvim = {
    plugins = {
      web-devicons.enable = true;

      # ========================================================================
      # Notifications (required by Noice)
      # ========================================================================
      notify = {
        enable = true;
        settings = {
          stages = "fade_in_slide_out";
          timeout = 3000;
          render = "default";
          max_width = 80;
          max_height = 10;
          top_down = true;
        };
      };

      # ========================================================================
      # Git Signs
      # ========================================================================
      gitsigns = {
        enable = true;
        settings = {
          current_line_blame = true;
          signs = {
            add.text = "│";
            change.text = "│";
            delete.text = "_";
          };
        };
      };

      # ========================================================================
      # Noice (CMD line & Notifications)
      # ========================================================================
      noice = {
        enable = true;
        settings = {
          notify.enabled = true;
          lsp.override = {
            "vim.lsp.util.convert_input_to_markdown_lines" = true;
            "vim.lsp.util.stylize_markdown" = true;
          };
          presets = {
            bottom_search = true;
            command_palette = true;
            long_message_to_split = true;
            inc_rename = false;
            lsp_doc_border = false;
          };
        };
      };

      # ========================================================================
      # Dressing (UI Improvement)
      # ========================================================================
      dressing = {
        enable = true;
        settings = {
          input.enabled = true;
          select = {
            enabled = true;
            backend = [
              "telescope"
              "builtin"
            ];
          };
        };
      };
    };
  };
}
