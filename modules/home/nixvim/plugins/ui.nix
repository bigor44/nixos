{
  programs.nixvim = {
    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "mocha";
        integrations = {
          cmp = true;
          treesitter = true;
          gitsigns = true;
          snacks = true;
          noice = true;
        };
      };
    };

    plugins = {
      web-devicons.enable = true;
      gitsigns = {
        enable = true;
        settings = {
          current_line_blame = true;
          signs = {
            add = {
              text = "│";
            };
            change = {
              text = "│";
            };
            delete = {
              text = "_";
            };
          };
        };
      };
      snacks = {
        enable = true;
        settings = {
          picker.enabled = true;
          explorer.enabled = true;
          indent.enabled = true;
          statuscolumn.enabled = true;
          bufdelete.enabled = true;
          lazygit.enabled = true;
          gitbrowse.enabled = true;
          terminal.enabled = true;
          notifier.enabled = true;
          quickfile.enabled = true;
          bigfile.enabled = true;
          dashboard.enabled = false;
        };
      };
      nvim-autopairs.enable = true;
      nvim-surround.enable = true;
      comment.enable = true;
      colorizer = {
        enable = true;
        settings = {
          userDefaultOptions = {
            names = false;
            RGB = true;
            RRGGBB = true;
          };
        };
      };
      which-key.enable = true;
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>ff";
        action = ''<cmd>lua Snacks.picker.files()<CR>'';
        options.desc = "Find Files";
      }
      {
        mode = "n";
        key = "<leader>fg";
        action = ''<cmd>lua Snacks.picker.grep()<CR>'';
        options.desc = "Live Grep";
      }
      {
        mode = "n";
        key = "<leader>fb";
        action = ''<cmd>lua Snacks.picker.buffers()<CR>'';
        options.desc = "Buffers";
      }
      {
        mode = "n";
        key = "<leader>/";
        action = ''<cmd>lua Snacks.picker.grep_buffers()<CR>'';
        options.desc = "Search Buffers";
      }
      {
        mode = "n";
        key = "<leader>e";
        action = ''<cmd>lua Snacks.explorer()<CR>'';
        options.desc = "Explorer";
      }
      {
        mode = "n";
        key = "<leader>gg";
        action = ''<cmd>lua Snacks.lazygit()<CR>'';
        options.desc = "Lazygit";
      }
      {
        mode = "n";
        key = "<leader>gl";
        action = ''<cmd>lua Snacks.lazygit.log()<CR>'';
        options.desc = "Git Log";
      }
      {
        mode = "n";
        key = "<leader>bd";
        action = ''<cmd>lua Snacks.bufdelete()<CR>'';
        options.desc = "Delete Buffer";
      }
      {
        mode = "n";
        key = "<c-t>";
        action = ''<cmd>lua Snacks.terminal.toggle()<CR>'';
        options.desc = "Toggle Terminal";
      }
    ];
  };
}
