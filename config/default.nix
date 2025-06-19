{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  # Automatically import all other config files
  imports = map (n: "${./.}/${n}") (builtins.filter (x: !(x=="default.nix")) (builtins.attrNames (builtins.readDir ./.)));
  performance = {
    byteCompileLua = {
      enable = true;
      nvimRuntime = true;
      configs = true;
      plugins = true;
    };
  };

  # extraPlugins = [
  #  (pkgs.vimUtils.buildVimPlugin {
  #   name = "ghost-text";
  # src = pkgs.fetchFromGitHub {
  #   owner = "wallpants";
  #   repo = "ghost-text.nvim";
  #   rev = "v2.0.4";
  #   hash = "sha256-zsyB3eJpwN8+dknjRZ89RttdiC1IA2LakBfnFNudQOI=";
  #   };
  # })
  # ];
  # extraConfigLua = ''
  #   require('ghost-text').setup({
  #     autostart=true,
  #     port = 4001,
  #     log_level = nil,
  #   })
  # '';
  plugins.zen-mode = {
    enable = true;
  };
  plugins.nvim-ufo = {
    enable=false;
    settings = {

  fold_virt_text_handler = ''
    function(virtText, lnum, endLnum, width, truncate)
      local newVirtText = {}
      local suffix = ('  %d '):format(endLnum - lnum)
      local sufWidth = vim.fn.strdisplaywidth(suffix)
      local targetWidth = width - sufWidth
      local curWidth = 0
      for _, chunk in ipairs(virtText) do
        local chunkText = chunk[1]
        local chunkWidth = vim.fn.strdisplaywidth(chunkText)
        if targetWidth > curWidth + chunkWidth then
          table.insert(newVirtText, chunk)
        else
          chunkText = truncate(chunkText, targetWidth - curWidth)
          local hlGroup = chunk[2]
          table.insert(newVirtText, {chunkText, hlGroup})
          chunkWidth = vim.fn.strdisplaywidth(chunkText)
          -- str width returned from truncate() may less than 2nd argument, need padding
          if curWidth + chunkWidth < targetWidth then
            suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
          end
          break
        end
        curWidth = curWidth + chunkWidth
      end
      table.insert(newVirtText, {suffix, 'MoreMsg'})
      return newVirtText
    end
  '';
  provider_selector = ''
    function(bufnr, filetype, buftype)
      local ftMap = {
        vim = "indent",
        python = {"indent"},
        git = ""
      }
    
     return ftMap[filetype]
    end
  '';
    };
  };
  # plugins.statuscol.enable = true;
  plugins.nix.enable = true;
  plugins.todo-comments.enable = true;
  plugins.lualine.enable = true;
  plugins.lz-n.enable = true;
  plugins.web-devicons.enable = true;
  colorschemes.catppuccin.enable = true;
  diagnostic.settings = {
    virtual_text=false;
  };
  opts = {
    showmatch = true;
    ignorecase = true;
    hlsearch = true;
    title = true;
    si = true;
    smarttab = true;
    smartindent = true;
    incsearch = true;
    tabstop = 2;
    shiftwidth = 2;
    softtabstop = 2;
    conceallevel = 0;
    termguicolors = true;
    number = true;
    relativenumber = true;
    autoindent = true;
    clipboard = "unnamedplus";
    cursorline = true;
    list = true;
    expandtab = true;
    shiftround = true;
  };
  keymaps = [
    {
      key = "<ESC>";
      mode = ["t"];
      action = "<C-\\><C-n>";
    }
    {
      key = "U";
      mode = ["n" "v"];
      action = "<cmd>redo<cr>";
    }
  ];
}
