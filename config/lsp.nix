{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  plugins.lsp-format.enable = true;
  plugins = {
    luasnip.enable = true;
    cmp-omni.enable = true;
    cmp-dap.enable = true;
    cmp-nvim-lsp.enable = true;
    lspkind = {
      enable = true;

      cmp = {
        enable = true;
        menu = {
          nvim_lsp = "[LSP]";
          nvim_lua = "[api]";
          path = "[path]";
          luasnip = "[snip]";
          buffer = "[buffer]";
          neorg = "[neorg]";
          cmp_tabby = "[Tabby]";
        };
      };
    };
    cmp = {
      enable = true;
      settings = {
        snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";
        sources = [
          {name = "path";}
          {name = "nvim_lsp";}
          {name = "cmp_tabby";}
          {name = "luasnip";}
          {
            name = "buffer";
            # Words from other open buffers can also be suggested.
            option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
          }
        ];
        mapping = {
          "<C-d>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-e>" = "cmp.mapping.close()";
          "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
        };
      };
    };
  };

  plugins.lsp = {
    enable = true;
    servers = {
      nixd = {
        enable = true;
        settings = {
          formatting.command = ["alejandra"];
          nixpkgs = {
            expr = "import <nixpkgs> { }";
          };
        };
      };
    };
    keymaps = {
      lspBuf = {
        gd = "definition";
      };
    };
  };
}
