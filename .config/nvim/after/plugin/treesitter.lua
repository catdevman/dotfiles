require('nvim-treesitter.configs').setup {
  ensure_installed = { 'vimdoc', 'javascript', 'typescript', 'python', 'lua', 'rust', 'go', 'java' },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}
