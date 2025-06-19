{...}: {
  plugins.codecompanion.settings.prompt_library."Ask Mathematician" = {
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
}
