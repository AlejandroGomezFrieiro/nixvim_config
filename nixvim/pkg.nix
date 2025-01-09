{ inputs, self, ... }:
{
  perSystem =
    {
      inputs',
      self',
      pkgs,
      system,
      ...
    }:
    {
      packages = {
        nixvim = inputs'.nixvim.legacyPackages.makeNixvimWithModule {
          module = {
            imports = [ ./config/default.nix ];
          };
          extraSpecialArgs = {
            flake = self;
        };
      };
      };

      checks.launch-neovim = inputs.nixvim.lib.${system}.check.mkTestDerivationFromNvim {
        # nvim = self'.packages.nixvim;
        nvim = self'.packages.nixvim.extend (
          { lib, ... }:
          {
            # test.checkWarnings = false;
            plugins.image.enable = lib.mkForce false;
            # plugins.diagram-nvim.enable = lib.mkForce false;
          }
        );
        name = "Neovim configuration";
      };
    };
}
