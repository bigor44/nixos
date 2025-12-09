{
  programs.nixvim = {
    autoGroups = {
      gemini_highlight_yank = {clear = true;};
    };

    autoCmd = [
      {
        event = "TextYankPost";
        group = "gemini_highlight_yank";
        callback = {__raw = "function() vim.highlight.on_yank({ timeout = 250 }) end";};
      }
      {
        event = "BufEnter";
        pattern = "*";
        callback = {__raw = "function() vim.opt_local.formatoptions:remove({ 'r', 'o' }) end";};
      }
    ];
  };
}
