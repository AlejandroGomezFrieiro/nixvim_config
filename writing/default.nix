{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.writing;
in {
  options.writing = {
    enable = lib.mkEnableOption "creative writing Neovim config" // {default = true;};

    focus = {
      enable = lib.mkEnableOption "goyo + twilight distraction-free focus mode" // {default = true;};
    };

    preview.enable =
      lib.mkEnableOption "markdown-preview live browser preview" // {default = true;};

    grammar.enable =
      lib.mkEnableOption "LTeX (LanguageTool) grammar checking over LSP" // {default = false;};

    vale.enable =
      lib.mkEnableOption "Vale prose linting (vale-ls, proselint/alex/write-good/readability styles)" // {default = false;};

    markdownOxide.enable =
      lib.mkEnableOption "markdown-oxide LSP (notes, links, tags, outline)" // {default = true;};

    export.enable =
      lib.mkEnableOption "pandoc export (`WritingExport` -> DOCX)" // {default = true;};

    dictionary = {
      files = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        default = [./dictionary.txt];
        description = ''
          Word-list files (one word per line) offered by the dictionary
          completion source. Add project vocabulary (character names,
          world-building terms, invented words) here — they'll autocomplete
          as you write.
        '';
      };
    };

    gitDrafts.enable =
      lib.mkEnableOption "git-based draft branches (fugitive + gitsigns + diffview)" // {default = false;};

    storyteller = {
      enable = lib.mkEnableOption "Storyteller novel-writing engine" // {default = false;};

      package = lib.mkOption {
        type = lib.types.nullOr lib.types.package;
        default = null;
        description = "Storyteller plugin package supplied by the consuming flake.";
      };

      settings = lib.mkOption {
        type = lib.types.attrs;
        default = {};
        description = "Options passed to storyteller.setup({...}).";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    globals.mapleader = " ";

    colorschemes.catppuccin.enable = lib.mkDefault true;

    plugins = {
      treesitter = {
        enable = lib.mkDefault true;
        settings = {
          ensure_installed = lib.mkDefault ["markdown" "markdown_inline"];
          indent.enable = lib.mkDefault true;
          highlight.enable = lib.mkDefault true;
        };
      };

      # In-buffer markdown rendering (headings, bullets, code blocks)
      render-markdown.enable = lib.mkDefault true;

      # Auto-continue numbered/bulleted lists while writing prose
      bullets.enable = lib.mkDefault true;

      # File tree / binder-style navigation
      oil.enable = lib.mkDefault true;

      telescope.enable = lib.mkDefault true;
      web-devicons.enable = lib.mkDefault true;
      which-key.enable = lib.mkDefault true;

      # ---- Completion (blink.cmp) ----
      blink-cmp = {
        enable = lib.mkDefault true;
        setupLspCapabilities = lib.mkDefault true;
        settings.keymap = lib.mkDefault {preset = "super-tab";};
        # LuaSnip owns the writing templates (`chapter`, `scene`, `char`,
        # etc.). Blink's default preset only expands native snippets, so make
        # the completion source use the same engine that loads our snippets.
        settings.snippets.preset = lib.mkDefault "luasnip";
        settings.sources = {
          default = lib.mkDefault ["lsp" "path" "snippets" "buffer" "spell" "dictionary"];
          providers = {
            # Spelling suggestions as completions
            spell = lib.mkDefault {
              module = "blink-cmp-spell";
              name = "Spell";
              min_keyword_length = 3;
              score_offset = -5;
            };
            # Project vocabulary: characters, places, invented words
            dictionary = lib.mkDefault {
              module = "blink-cmp-dictionary";
              name = "Dict";
              min_keyword_length = 2;
              score_offset = 2;
              max_items = 12;
              opts.dictionary_files = lib.mkDefault (map (p: builtins.toString p) cfg.dictionary.files);
            };
          };
        };
      };
      blink-cmp-spell.enable = lib.mkDefault true;
      blink-cmp-dictionary.enable = lib.mkDefault true;

      # ---- Snippets (LuaSnip) ----
      luasnip = {
        enable = lib.mkDefault true;
        fromLua = lib.mkDefault [
          {
            paths = ./snippets;
            lazyLoad = false;
          }
        ];
      };

      # ---- Distraction-free writing ----
      twilight.enable = lib.mkDefault cfg.focus.enable;
      goyo.enable = lib.mkDefault cfg.focus.enable;

      # ---- Optional: live browser preview ----
      markdown-preview.enable = lib.mkDefault cfg.preview.enable;

      # ---- Optional: grammar checking (LTeX / LanguageTool) ----
      lsp.enable = lib.mkDefault (cfg.grammar.enable || cfg.markdownOxide.enable || cfg.vale.enable);
      # ltex-extra races LTeX client attachment under current Neovim/Nixvim
      # and emits startup errors. The LTeX server below provides grammar and
      # diagnostics without that wrapper.
      ltex-extra.enable = lib.mkDefault false;
      lsp.servers.ltex = lib.mkDefault {
        enable = cfg.grammar.enable;
        settings.ltex = {
          language = "en-US";
          additionalRules.enablePickyRules = true;
        };
      };

      # ---- Optional: Vale prose linting (vale-ls) ----
      lsp.servers.vale_ls = lib.mkDefault {
        enable = cfg.vale.enable;
        package = pkgs.vale-ls;
      };

      # ---- markdown-oxide LSP (notes, links, tags, outline) ----
      lsp.servers.markdown_oxide = lib.mkDefault {
        enable = cfg.markdownOxide.enable;
        package = pkgs.markdown-oxide;
      };

      # ---- Optional: git-based draft workflow ----
      fugitive.enable = lib.mkDefault cfg.gitDrafts.enable;
      gitsigns.enable = lib.mkDefault cfg.gitDrafts.enable;
      diffview.enable = lib.mkDefault cfg.gitDrafts.enable;
    };

    # pandoc powers the manuscript/export commands; vale is the vale-ls CLI.
    extraPackages = lib.mkDefault (
      (lib.optional cfg.export.enable pkgs.pandoc)
      ++ lib.optional cfg.vale.enable pkgs.vale
    );

    extraPlugins = lib.optional (cfg.storyteller.enable && cfg.storyteller.package != null) cfg.storyteller.package;

    opts = {
      number = lib.mkDefault true;
      relativenumber = lib.mkDefault true;
      cursorline = lib.mkDefault true;
      showmatch = lib.mkDefault true;
      ignorecase = lib.mkDefault true;
      smartcase = lib.mkDefault true;
      hlsearch = lib.mkDefault true;
      incsearch = lib.mkDefault true;
      autoindent = lib.mkDefault true;
      smartindent = lib.mkDefault true;
      shiftround = lib.mkDefault true;
      expandtab = lib.mkDefault true;
      shiftwidth = lib.mkDefault 4;
      tabstop = lib.mkDefault 4;
      clipboard = lib.mkDefault "unnamedplus";
      termguicolors = lib.mkDefault true;
    };

    # Prose-friendly settings applied to Markdown buffers. When focus mode is
    # enabled this *is* the "writing mode": it dims inactive text (Twilight)
    # and enters a distraction-free layout (Goyo) as soon as a markdown file
    # is opened.
    extraConfigLua =
      ''
        vim.api.nvim_create_autocmd("FileType", {
          pattern = { "markdown" },
          callback = function()
            vim.opt_local.wrap = true
            vim.opt_local.linebreak = true
            vim.opt_local.spell = true
            vim.opt_local.spelllang = { "en_us" }
            vim.opt_local.colorcolumn = "80"
          end,
        })
      ''
      + lib.optionalString cfg.export.enable ''
        -- :WritingExport — compile the current markdown to build/<name>.docx
        vim.api.nvim_create_user_command("WritingExport", function()
          local fname = vim.fn.expand("%:t:r")
          if fname == "" then
            vim.notify("No file to export.", vim.log.levels.WARN)
            return
          end
          local dir = vim.fn.getcwd() .. "/build"
          vim.fn.mkdir(dir, "p")
          local src = vim.fn.shellescape(vim.fn.expand("%:p"))
          local out = vim.fn.shellescape(dir .. "/" .. fname .. ".docx")
          local cmd = "pandoc " .. src
            .. " --from=markdown+smart --to=docx --standalone --output=" .. out
          local ok = vim.fn.system(cmd)
          if vim.v.shell_error ~= 0 then
            vim.notify("Export failed: " .. ok, vim.log.levels.ERROR)
          else
            vim.notify("Exported to " .. dir .. "/" .. fname .. ".docx", vim.log.levels.INFO)
          end
        end, { desc = "Export current markdown to DOCX" })
      ''
      + lib.optionalString (cfg.storyteller.enable && cfg.storyteller.package != null) ''
        -- Storyteller is the project-aware layer over the writing defaults.
        require("storyteller").setup(${builtins.toJSON cfg.storyteller.settings})
      '';

    keymaps = [
      # ---- Finding ----
      {
        key = "<leader>ff";
        action = "<cmd>Telescope find_files<cr>";
        options = {
          silent = true;
          desc = "Find file";
        };
      }
      {
        key = "<leader>fg";
        action = "<cmd>Telescope live_grep<cr>";
        options = {
          silent = true;
          desc = "Grep text";
        };
      }
      {
        key = "<leader>fb";
        action = "<cmd>Telescope buffers<cr>";
        options = {
          silent = true;
          desc = "Switch buffer";
        };
      }

      # ---- Binder / file tree ----
      {
        key = "<leader>e";
        action = "<cmd>Oil<cr>";
        options = {
          silent = true;
          desc = "File tree";
        };
      }
      # Keep the main nixvim profile's familiar file-tree shortcut. The
      # writing build uses Oil rather than Fyler, but both keys open the binder.
      {
        key = "<leader>n";
        action = "<cmd>Oil<cr>";
        options = {
          silent = true;
          desc = "File tree";
        };
      }

      # ---- Outline (markdown-oxide document symbols) ----
      {
        key = "<leader>o";
        action = "<cmd>Telescope lsp_document_symbols<cr>";
        options = {
          silent = true;
          desc = "Document outline";
        };
      }

      # ---- Focus ----
      {
        key = "<leader>z";
        action = "<cmd>Goyo<cr>";
        options = {
          silent = true;
          desc = "Toggle Goyo";
        };
      }
      {
        key = "<leader>t";
        action = "<cmd>Twilight<cr>";
        options = {
          silent = true;
          desc = "Toggle Twilight";
        };
      }

      # ---- Preview ----
      {
        key = "<leader>mp";
        action = "<cmd>MarkdownPreviewToggle<cr>";
        options = {
          silent = true;
          desc = "Toggle markdown preview";
        };
      }

      # ---- Writing helpers ----
      {
        key = "<leader>wc";
        action = "<cmd>lua print('words: ' .. vim.fn.wordcount().words)<cr>";
        options = {
          silent = true;
          desc = "Word count";
        };
      }
      {
        key = "<leader>we";
        action = "<cmd>WritingExport<cr>";
        options = {
          silent = true;
          desc = "Export to DOCX";
        };
      }
    ];

    plugins.which-key.settings.spec = lib.mkDefault [
      {
        __unkeyed-1 = "<leader>f";
        group = "Find";
      }
      {
        __unkeyed-1 = "<leader>z";
        group = "Focus";
      }
      {
        __unkeyed-1 = "<leader>m";
        group = "Markdown";
      }
      {
        __unkeyed-1 = "<leader>w";
        group = "Writing";
      }
    ];
  };
}
