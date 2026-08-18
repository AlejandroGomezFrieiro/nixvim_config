{pkgs, ...}: {
  extraPlugins = with pkgs.vimPlugins; [math-conceal-nvim];

  extraConfigLua = ''
    require("math-conceal").setup({
      conceal = {
        "greek",
        "script",
        "font",
        "delim",
        "phy",
        "math"
      },
      ft = { "markdown", "typst", "quarto" },
      image = {
        enabled = false,
        filetypes = { "markdown", "typst" },
      },
    })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "markdown",
      callback = function()
        vim.schedule(function()
          require("math-conceal").set("markdown")
        end)
      end,
    })
  '';
}
