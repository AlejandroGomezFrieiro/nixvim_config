{
  description = "Writing project: distraction-free prose in Neovim, with prose linting (LTeX + Vale).";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    systems.url = "github:nix-systems/default";
    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    nixvim_config.url = "github:AlejandroGomezFrieiro/nixvim_config";
    nixvim_config.inputs.nixpkgs.follows = "nixpkgs";
    nixvim_config.inputs.nixvim.follows = "nixvim";
    nixvim_config.inputs.systems.follows = "systems";
  };
  outputs = inputs @ {
    nixpkgs,
    nixvim,
    nixvim_config,
    ...
  }: let
    eachSystem = nixpkgs.lib.genAttrs (import inputs.systems);

    mkPkgs = system:
      import inputs.nixpkgs {
        inherit system;
        # blink-cmp-spell (spelling suggestions as completions) is non-free.
        config.allowUnfreePredicate = pkg:
          builtins.elem (pkg.pname or pkg.name) ["blink-cmp-spell"];
      };

    # Creative-writing Neovim with the prose-linting stack switched on:
    # LTeX (grammar) on top of Vale (proselint / alex / write-good / readability).
    writing = system: let
      pkgs = mkPkgs system;
    in
      nixvim.legacyPackages.${system}.makeNixvimWithModule {
        inherit pkgs;
        module = {
          imports = [nixvim_config.nixosModules.writing];
          writing.grammar.enable = true;
          writing.vale.enable = true;
          writing.markdownOxide.enable = true;
          plugins.lsp.enable = true;
          plugins.blink-cmp.enable = true;
          plugins.luasnip.enable = true;
          plugins.blink-cmp.settings.sources.default = ["lsp" "path" "snippets" "buffer" "spell" "dictionary"];
        };
      };

    # Bundled default Vale config + styles, provisioned into the project by
    # the devShell's shellHook below.
    valeStarter = system: nixvim_config.packages.${system}.writing-vale;
  in {
    devShells = eachSystem (system: let
      pkgs = mkPkgs system;
    in {
      default = pkgs.mkShell {
        packages = [
          (writing system)
          # Export manuscript to DOCX / EPUB / PDF.
          pkgs.pandoc
          # Small task runner (see justfile).
          pkgs.just
          # Vale CLI, so `just lint` works from the shell.
          pkgs.vale
        ];
        shellHook = ''
          # Provision the default Vale config + styles once.
          if [ ! -f .vale.ini ] || [ ! -d styles ]; then
            cp -r ${valeStarter system}/. .
            chmod -R u+w .vale.ini styles
          fi
        '';
      };
    });

    formatter = eachSystem (system: (mkPkgs system).alejandra);
  };
}
