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
    # checks.buildWithModule = inputs'.nixvim.lib.${system}.check.mkTestDerivationFromNvim {
    #           name = "Test";
    #       nvim = inputs'.nixvim.legacyPackages.makeNixvimWithModule{
    #         module = self'.outputs.nixosModules.default;
    #           };
    #       };
    packages = rec {
      default = nixvim;
      nixvim = inputs'.nixvim.legacyPackages.makeNixvimWithModule {
        module = {
          imports = [./config];
          extraPackages = [pkgs.vectorcode];
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
