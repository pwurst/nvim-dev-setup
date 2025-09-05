return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    ensure_installed = {
      "lua", "bash", "regex", "vim", "vimdoc",
      "markdown", "markdown_inline", "python", "json", "yaml", "toml", "query",
    },
    auto_install = true,
    highlight = { enable = true, additional_vim_regex_highlighting = false },
    indent = { enable = true },
    parser_install_dir = vim.fn.stdpath("data") .. "/treesitter-parsers",
  },
  config = function(_, opts)
    -- ensure parser dir is on runtimepath
    local parser_dir = opts.parser_install_dir
    if parser_dir and not string.find(vim.o.runtimepath, parser_dir, 1, true) then
      vim.opt.runtimepath:append(parser_dir)
    end
    require("nvim-treesitter.configs").setup(opts)

    -- Proactively install missing parsers (bash/regex) to silence health warnings
    local ensure = { "bash", "regex" }
    local parsers_ok, parsers = pcall(require, "nvim-treesitter.parsers")
    if parsers_ok and parsers then
      for _, lang in ipairs(ensure) do
        local has = parsers.has_parser(lang)
        if not has then
          pcall(vim.cmd, "TSInstallSync " .. lang)
        end
      end
    end
  end,
}