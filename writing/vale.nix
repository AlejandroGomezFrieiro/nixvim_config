{pkgs, ...}: let
  styles = {
    proselint = pkgs.fetchFromGitHub {
      owner = "vale-cli";
      repo = "proselint";
      rev = "8e24adbaa5dc6593b331f8bfab23c9af044af406";
      hash = "sha256-lHA50ln58PmTKIjGHfT4Q1XkZWYAMH7x6Fxuz3wEBXM=";
    };
    alex = pkgs.fetchFromGitHub {
      owner = "vale-cli";
      repo = "alex";
      rev = "21c1e9bdaf8df231ce1eb689dea9deb6680ba196";
      hash = "sha256-epzGMXbqdT5eUmcJtf78HaWsokh7OCSdYDP9WtEFGTs=";
    };
    write-good = pkgs.fetchFromGitHub {
      owner = "vale-cli";
      repo = "write-good";
      rev = "c9ceca7f574248a201d5524b001099c5626c7519";
      hash = "sha256-C7v4GqBQLHXohESacPc/aFsMAZMSCr+gIk8VzP8mmZY=";
    };
    readability = pkgs.fetchFromGitHub {
      owner = "vale-cli";
      repo = "readability";
      rev = "04fe2a19dc2b4d3df237345639a6c048d8b66e2c";
      hash = "sha256-5Y9v8QsZjC2w3/pGIcL5nBdhpogyJznO5IFa0s8VOOI=";
    };
  };
in
  pkgs.runCommand "writing-vale" {} ''
    mkdir -p $out/styles
    cp -r ${styles.proselint}/proselint $out/styles/proselint
    cp -r ${styles.alex}/alex $out/styles/alex
    cp -r ${styles.write-good}/write-good $out/styles/write-good
    cp -r ${styles.readability}/Readability $out/styles/Readability
    cp ${./vale/.vale.ini} $out/.vale.ini
  ''
