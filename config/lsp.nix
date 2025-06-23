{
  lib,
  pkgs,
  ...
}: {
  extraPlugins = with pkgs.vimPlugins; [
    markdown-nvim
  ];
  extraConfigLua = ''require("markdown").setup()'';
  plugins.friendly-snippets.enable = lib.mkDefault true;
  plugins.lsp-format.enable = lib.mkDefault true;
  plugins.lsp-format.lspServersToEnable = lib.mkDefault ["pylsp"];
  plugins = {
    gitsigns = {
      enable = lib.mkDefault true;
      settings.current_line_blame = lib.mkDefault true;
    };
    lspsaga = {
      enable = lib.mkDefault true;
      symbolInWinbar.enable = lib.mkDefault false;
      lightbulb.sign = lib.mkDefault false; # disable bulb in status col
      lightbulb.virtualText = lib.mkDefault true; # enable at end of line
    };
    # luasnip.enable = true;
    luasnip = {
      enable = lib.mkDefault true;
      fromLua = lib.mkDefault [{paths = ./snippets;}];
      settings = {
        update_events = lib.mkDefault [
          "TextChanged"
          "TextChangedI"
        ];
      };
    };
    cmp-omni.enable = lib.mkDefault true;
    cmp-dap.enable = lib.mkDefault true;
    cmp-nvim-lsp.enable = lib.mkDefault true;
    lspkind = {
      enable = lib.mkDefault true;

      cmp = {
        enable = lib.mkDefault true;
        menu = lib.mkDefault {
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
      enable = lib.mkDefault true;
      settings = {
        snippet.expand = lib.mkDefault "function(args) require('luasnip').lsp_expand(args.body) end";
        sources = lib.mkDefault [
          {name = "luasnip";}
          {name = "nvim_lsp";}
          {name = "cmp_tabby";}
          {name = "path";}
          {
            name = "buffer";
            # Words from other open buffers can also be suggested.
            option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
          }
        ];
        mapping = lib.mkDefault {
          "<C-d>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-e>" = "cmp.mapping.close()";
          "<C-n>" = ''
            cmp.mapping(function(fallback)
              local luasnip = require("luasnip")
              if luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
              elseif luasnip.jumpable(1) then
                luasnip.jump(1)
              else
                fallback()
              end
            end, { "i", "s" })
          '';
          "<C-p>" = ''
            cmp.mapping(function(fallback)
              local luasnip = require("luasnip")
              if luasnip.jumpable(-1) then
                luasnip.jump(-1)
              else
                fallback()
              end
            end, { "i", "s" })
          '';
          "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
        };
      };
    };
  };

  plugins.lsp = {
    enable = lib.mkDefault true;
    autoLoad = lib.mkDefault true;
    servers = {
      teal_ls.enable = lib.mkDefault true;
      lua_ls.enable = lib.mkDefault true;
      markdown_oxide.enable = lib.mkDefault true;
      nil_ls.enable = lib.mkDefault true;
      rust_analyzer.enable = lib.mkDefault true;
      rust_analyzer.installRustc = lib.mkDefault true;
      rust_analyzer.installCargo = lib.mkDefault true;
      pylsp = {
        enable = lib.mkDefault true;
        settings.plugins = {
          pylsp_mypy.enable = lib.mkDefault true;
          ruff.enable = lib.mkDefault true;
        };
      };
      nixd = {
        enable = lib.mkDefault true;
        settings = {
          formatting.command = lib.mkDefault ["alejandra"];
          nixpkgs = {
            expr = lib.mkDefault "import <nixpkgs> { }";
          };
        };
      };
    };
  };
  keymaps = [
    {
      key = "<leader>lr";
      mode = ["n"];
      action = ":Lspsaga rename<CR>";
      options = {
        silent = true;
        desc = "LSP Rename";
      };
    }
    {
      key = "<leader>la";
      mode = ["v"];
      action = ":<C-U>Lspsaga range_code_action<CR>";
      options = {
        silent = true;
        desc = "Code Action";
      };
    }
    {
      key = "<leader>la";
      mode = ["n"];
      action = ":Lspsaga code_action<CR>";
      options = {
        silent = true;
        desc = "Code Action";
      };
    }
    {
      key = "<leader>lK";
      mode = ["n"];
      action = "<Cmd>:Lspsaga hover_doc<CR>";
      options = {
        silent = true;
        desc = "Hover doc";
      };
    }
    {
      key = "gd";
      mode = ["n"];
      action = "<Cmd>:Lspsaga goto_definition<CR>";
      options = {
        silent = true;
        desc = "Goto Definition";
      };
    }
    {
      key = "<leader>ll";
      mode = ["n"];
      action = "<Cmd>Lspsaga show_line_diagnostics<CR>";
      options = {
        silent = true;
        desc = "Show Line Diagnostics";
      };
    }
  ];
}
