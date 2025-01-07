# The importApply argument. Use this to reference things defined locally,
# as opposed to the flake where this is imported.
localFlake:
# Regular module arguments; self, inputs, etc all reference the final user flake,
# where this module was imported.
{
  lib,
  config,
  self,
  inputs,
  ...
}: {
  perSystem = {system, ...}: rec {

    packages.nixvim = localFlake.withSystem system (
    {pkgs, ...}: let
        nixvim' = inputs.nixvim.legacyPackages.${system};
    in nixvim'.makeNixvimWithModule {
        inherit pkgs;
        module = self.nixosModules.nixvim;
    });
    devShells.default = localFlake.withSystem system({pkgs, ...}: pkgs.mkShell {
          packages = [packages.nixvim pkgs.just];
        });
  };
  flake.nixosModules.nixvim = localFlake.moduleWithSystem (
    perSystem @ {config}: {
      imports = [./config];
    }
  );
  flake.templates = localFlake {
    rust = {
      path = ./templates/rust_environment;
      description = "Rust environment";
    };
    python_uv = {
      path = ./templates/python_uv;
      description = "Simple Python environment";
    };
  };
}
