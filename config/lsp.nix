{
  config,
  lib,
  pkgs,
  helpers,
  inputs,
  ...
}: {
  extraPlugins = with pkgs.vimPlugins; [
    markdown-nvim
  ];
  extraConfigLua = "require('markdown').setup()";
  plugins.friendly-snippets.enable = true;
  # plugins.image.enable = true;
  plugins.lsp-format.enable = true;
  plugins.lsp-format.lspServersToEnable = ["pylsp"];
  plugins = {
    gitsigns = {
      enable = true;
      settings.current_line_blame = true;
    };
    lspsaga = {
      enable = true;
      symbolInWinbar.enable = false;
      lightbulb.sign = false; # disable bulb in status col
      lightbulb.virtualText = true; # enable at end of line
    };
    # luasnip.enable = true;
    luasnip = {
      enable = true;
      # fromLua = [../snippets/lua];
      settings = {
        update_events = [
          "TextChanged"
          "TextChangedI"
        ];
      };
    };
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
        mapping = {
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
    enable = true;
    autoLoad = true;
    servers = {
      lua_ls.enable = true;
      markdown_oxide.enable = true;
      nil_ls.enable = true;
      rust_analyzer.enable = true;
      rust_analyzer.installRustc = true;
      rust_analyzer.installCargo = true;
      # ruff.enable = true;
      # pylyzer.enable = true;
      # ruff.enable = true;
      pylsp = {
        enable = true;
        settings.plugins = {
          pylsp_mypy.enable = true;
          ruff.enable = true;
        };
      };
      # pyright.enable = true;
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
    # keymaps = {
    #   lspBuf = {
    #     gd = "definition";
    #   };
    # };
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
