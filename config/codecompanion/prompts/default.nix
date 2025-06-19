{lib,...}: 
let
  files = lib.fileset.toList ./.;
in {
  imports = builtins.filter (x: !(x == ./default.nix)) files;
}
