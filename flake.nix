{
  description = "Nix flake for my custom Neovim configuration using Nixvim";

  nixConfig = {
    extra-substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://nixpkgs-wayland.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
    ];
  };

  inputs = {
    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "systems";
    storyteller.url = "github:AlejandroGomezFrieiro/storytelling.nvim";
    storyteller.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {nixpkgs, ...}: let
    eachSystem = nixpkgs.lib.genAttrs (import inputs.systems);

    overlay = final: prev: {
      jupynvim-core = final.rustPlatform.buildRustPackage rec {
        pname = "jupynvim-core";
        version = "unstable-2026-05-11";

        src = final.fetchFromGitHub {
          owner = "sheng-tse";
          repo = "jupynvim";
          rev = "2ffb8e81eec5c90d1b3c23a97e5d7245964a5148";
          hash = "sha256-U4o/6mdVvkU4QfPg0L63Abg+O2afYXc/SxSFgl2AX2E=";
        };

        sourceRoot = "${src.name}/core";
        cargoLock.lockFile = ./pkgs/jupynvim-core/Cargo.lock;

        meta = {
          description = "Native Rust backend for jupynvim";
          homepage = "https://github.com/sheng-tse/jupynvim";
          license = final.lib.licenses.mit;
          mainProgram = "jupynvim-core";
        };
      };

      vimPlugins = prev.vimPlugins.extend (_: _: {
        jupynvim = final.vimUtils.buildVimPlugin {
          pname = "jupynvim";
          version = "unstable-2026-05-11";
          src = final.fetchFromGitHub {
            owner = "sheng-tse";
            repo = "jupynvim";
            rev = "2ffb8e81eec5c90d1b3c23a97e5d7245964a5148";
            hash = "sha256-U4o/6mdVvkU4QfPg0L63Abg+O2afYXc/SxSFgl2AX2E=";
          };
          dependencies = [final.jupynvim-core];

          meta = {
            description = "Jupyter notebook editor and executor for Neovim";
            homepage = "https://github.com/sheng-tse/jupynvim";
            license = final.lib.licenses.mit;
          };
        };

        math-conceal-nvim = final.vimUtils.buildVimPlugin {
          pname = "math-conceal.nvim";
          version = "unstable-2026-05-21";
          src = final.fetchFromGitHub {
            owner = "pxwg";
            repo = "math-conceal.nvim";
            rev = "28bb79004d0570211f1ae21295dbb3435520af56";
            hash = "sha256-/9yqaJnLp/C+kepQEvBB9cGeAdIzeOsptFgzDXss2xc=";
          };

          meta = {
            description = "Fast LaTeX and Typst conceal for Neovim";
            homepage = "https://github.com/pxwg/math-conceal.nvim";
            license = final.lib.licenses.mit;
          };
        };
      });
    };

    nixvim_module = {pkgs, ...}: {
      nixpkgs.overlays = [overlay];
      imports = [./config];
    };

    # Standalone creative-writing derivation. It has no imports from ./config;
    # Storyteller is available as an opt-in writing.* feature.
    writing_module = {pkgs, ...}: {
      nixpkgs.overlays = [overlay];
      imports = [./writing];
      writing.storyteller.enable = true;
      writing.storyteller.package = inputs.storyteller.packages.${pkgs.system}.default;
      writing.storyteller.lspPackage = inputs.storyteller.packages.${pkgs.system}.storyteller-lsp;
    };

    mkPkgs = system:
      import inputs.nixpkgs {
        inherit system;
        overlays = [overlay];
        # blink-cmp-spell (spelling suggestions as completions) is licensed
        # under a non-free license, so opt in to exactly that one package.
        config.allowUnfreePredicate = pkg:
          builtins.elem (pkg.pname or pkg.name) ["blink-cmp-spell"];
      };
  in {
    checks = eachSystem (system: let
      pkgs = mkPkgs system;
      nvim = inputs.nixvim.legacyPackages.${system}.makeNixvimWithModule {
        inherit pkgs;
        module = nixvim_module;
      };
      writing = inputs.nixvim.legacyPackages.${system}.makeNixvimWithModule {
        inherit pkgs;
        module = writing_module;
      };
    in {
      launch-neovim = inputs.nixvim.lib.${system}.check.mkTestDerivationFromNvim {
        name = "launch-neovim";
        nvim = nvim;
      };
      launch-writing = inputs.nixvim.lib.${system}.check.mkTestDerivationFromNvim {
        name = "launch-writing";
        nvim = writing;
      };
    });

    packages = eachSystem (system: let
      pkgs = mkPkgs system;
      nixvim = inputs.nixvim.legacyPackages.${system}.makeNixvimWithModule {
        inherit pkgs;
        module = nixvim_module;
      };
      writing = inputs.nixvim.legacyPackages.${system}.makeNixvimWithModule {
        inherit pkgs;
        module = writing_module;
      };
    in {
      default = nixvim;
      nixvim = nixvim;
      # Creative writing edition: minimal, prose-focused.
      writing = writing;
      # Default Vale `.vale.ini` + styles to copy into a project root.
      writing-vale = import ./writing/vale.nix {inherit pkgs;};
    });

    devShells = eachSystem (system: let
      pkgs = mkPkgs system;
    in {
      default = pkgs.mkShell {
        nativeBuildInputs = [
          pkgs.alejandra
          pkgs.python311Packages.pylatexenc
          pkgs.vectorcode
          pkgs.nurl
          pkgs.docker
        ];
      };
    });

    formatter = eachSystem (system: (mkPkgs system).alejandra);

    nixosModules.default = nixvim_module;
    nixosModules.writing = writing_module;
    overlays.default = overlay;

    templates = {
      python_uv = {
        path = ./templates/python_uv;
        description = "A basic python environment with UV";
      };
      rust = {
        path = ./templates/rust_environment;
        description = "A basic rust environment";
      };
      storytelling = {
        path = ./templates/storytelling;
        description = "Creative writing project: outline, beat sheets, references, and a distraction-free Neovim prose environment";
      };
      writing = {
        path = ./templates/writing;
        description = "Plain Markdown prose project with a distraction-free Neovim prose environment and prose linting (LTeX + Vale)";
      };
    };
  };
}
