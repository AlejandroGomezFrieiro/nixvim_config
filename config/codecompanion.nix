{
  config,
  lib,
  pkgs,
  ...
}: let
  # vectorcode = pkgs.vimUtils.buildVimPlugin {
  #   name = "vectorcode";
  #
  #   src = pkgs.fetchFromGitHub {
  #   owner = "Davidyz";
  #   repo = "VectorCode";
  #   rev = "a80509949eb8c315a9e46069a2d85fd33080249c";
  #   hash = "sha256-8PpY64F9i/dp+c70VcsZVGEfcocD+g778bravximCzM=";
  # };
  # };
in {
  extraPlugins = [pkgs.vimPlugins.vectorcode-nvim];
  extraConfigLua = "require('vectorcode').setup()";
  plugins.render-markdown = {
    enable = true;
    settings = {
      file_types = ["markdown" "codecompanion" "quarto"];
    };
  };

  plugins.codecompanion.enable = true;

  plugins.codecompanion.settings = {
    opts = {
      send_code = true;
      use_default_actions = true;
      use_default_prompts = true;
      extensions = {
        vectorcode = {
          opts = {
            add_tool = true;
            add_slash_command = true;
            tool_opts = {
              max_num = {
                chunk = -1;
                document = -1;
              };
              default_num = {
                chunk = 50;
                document = 10;
              };
              include_stderr = false;
              use_lsp = false;
              auto_submit = {
                ls = false;
                query = false;
              };
              ls_on_start = false;
              no_duplicate = true;
              chunk_mode = false;
            };
          };
        };
      };
    };
    display = {
      action_palette = {
        opts = {
          show_default_prompt_library = true;
        };
        provider = "telescope";
      };
    };
    strategies = {
      agent = {adapter = "openrouter_claude";};
      chat = {
        adapter = "openrouter_claude";
        slash_commands = {
          codebase = "require('vectorcode.integrations').codecompanion.chat.make_slash_command()";
        };
        tools = {
          vectorcode = {
            description = "Use vectorcode";
            callback = {
              __raw = ''
                  function()
                  require("vectorcode.integrations").codecompanion.chat.make_tool(
                  ---@type VectorCode.CodeCompanion.ToolOpts
                  {
                    -- -- your options goes here
                      ls_on_start = true,
                      no_duplicate = true,
                  }
                );
                end
              '';
            };
          };
        };
      };
      inline = {adapter = "openrouter_claude";};
    };

    prompt_library = {
      "Ask Mathematician" = {
        description = "Consult an expert mathematician by asking questions in a loop";
        opts = {
          # index = 6;
          short_name = "math";
        };
        strategy = "chat";
        prompts = [
          {
            content = {
              __raw = ''
                function()
                  return [[I want you to act as an expert mathematician. I'll ask questions about mathematics and you should provide detailed, accurate responses. Keep responding to follow-up questions until I say stop. If there are any formulas, use mathjax format. For example, for a function that is a sin of x, use the following syntax: $$f(x) = \sin(x)$$.

                  If there are any theorems, use a markdown codeblock.]]
                end
              '';
            };
            opts = {
              tag = "system_tag";
              # visible = false;
            };
            role = "system";
          }
          {
            content = "Explain the following mathematical concept: ";
            opts = {
              # tag = "system_tag";
              # visible = true;
            };
            role = "user";
          }
        ];
      };

      "Custom Prompt" = {
        description = "Prompt the LLM from Neovim";
        opts = {
          index = 3;
          is_default = true;
          is_slash_cmd = false;
          user_prompt = true;
        };
        prompts = [
          {
            content = {
              __raw = ''

                function(context)
                  return string.format(
                    [[I want you to act as a senior %s developer. I will ask you specific questions and I want you to return raw code only (no codeblocks and no explanations). If you can't respond with code, respond with nothing]],
                    context.filetype
                  )
                end
              '';
            };
            opts = {
              tag = "system_tag";
              visible = true;
            };
            role = {
              __raw = "system";
            };
          }
        ];
        strategy = "inline";
      };
      "Edit<->Test workflow" = {
        description = "Use a workflow to repeatedly edit then test code";
        opts = {
          # index = 5;
          # is_default = true;
          short_name = "et";
        };
        strategy = "chat";
        prompts = [
          {
            content = {
              __raw = ''
                            function()

                              vim.g.codecompanion_auto_tol_mode = true

                              return [[### Instructions

                              Your instructions here

                ### Steps to Follow

                              You are required to write code following the instructions provided above and test the correctness by running the designated test suite. Follow these steps exactly:

                              1. Update the code in #buffer using the @editor tool
                              2. Then use the @cmd_runner tool to run the test suite with `<test_cmd>` (do this after you have updated the code)
                              3. Make sure you trigger both tools in the same response

                              We'll repeat this cycle until the tests pass. Ensure no deviations from these steps.]]
                            end
              '';
            };
            opts = {auto_submit = false;};
            role = "user";
          }
          {
            opts = {auto_submit = true;};
            role = "user";
            repeat_until = {
              __raw = ''
                function(chat)
                  return chat.tools.flags.testing == true
                end
              '';
            };
            condition = {
              __raw = ''
                function()
                  return _G.codecompanion_current_tool == "cmd_runner"
                end
              '';
            };
            content = {
              __raw = ''
                function() return [["The tests have failed. Can you edit the buffer and run the test suite again?"]] end
              '';
            };
          }
        ];
      };
      "Generate a Commit Message" = {
        description = "Generate a commit message";
        opts = {
          auto_submit = true;
          index = 10;
          is_default = true;
          is_slash_cmd = true;
          short_name = "commit";
        };
        prompts = [
          {
            content = {
              __raw = ''
                function()
                  return string.format(
                    [[You are an expert at following the Conventional Commit specification. Given the git diff listed below, please generate a commit message for me:

                    ```diff
                    %s
                    ```
                    ]],
                    vim.fn.system("git diff --no-ext-diff --staged")
                  )
                end
              '';
            };
            opts = {
              contains_code = true;
            };
            role = "user";
          }
        ];
        strategy = "chat";
      };
    };

    adapters = {
      openrouter_claude = {
        __raw = ''
          function()
            return require("codecompanion.adapters").extend("openai_compatible", {
              env = {
                url="https://openrouter.ai/api";
                api_key=os.getenv("OPENROUTER_API_KEY");
                chat_url = "/v1/chat/completions",
              };
              schema = {
                model = {
                  -- default = "deepseek/deepseek-r1-0528-qwen3-8b:free",
                  default = "deepseek/deepseek-chat-v3-0324:free",

                };

              };
            })
          end
        '';
      };
      ollama = {
        __raw = ''
          function()
            return require("codecompanion.adapters").extend("ollama", {
              schema = {
                model = {
                  default = "moondream:latest"
                }
              }
            })
          end
        '';
      };
    };
  };
}
