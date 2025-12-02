local status, treesitter = pcall(require, "nvim-treesitter.configs")
if not status then
  return
end

treesitter.setup({
  -- A list of parser names, or "all" (supported parsers)
  -- Since we use Nix to manage grammars, we don't need to ensure_installed here usually,
  -- but setting it to {} or verifying is fine.
  -- If we use `withAllGrammars`, they are already on rtp.
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
  },
  autotag = {
    enable = true,
  },
})
