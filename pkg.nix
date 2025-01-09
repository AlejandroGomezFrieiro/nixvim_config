{
  inputs,
  self,
  ...
}: {
  perSystem = {
    inputs',
    self',
    pkgs,
    system,
    ...
  }: {
    packages = rec {
      default = nixvim;
      nixvim = inputs'.nixvim.legacyPackages.makeNixvimWithModule {
        module = {
          imports = [./config/default.nix];
        };
        extraSpecialArgs = {
          flake = self;
        };
      };
    };

    checks.launch-neovim = inputs.nixvim.lib.${system}.check.mkTestDerivationFromNvim {
      nvim = self'.packages.nixvim.extend (
        {lib, ...}: {
          plugins.image.enable = lib.mkForce false;
        }
      );
      name = "Neovim configuration";
    };
  };
}