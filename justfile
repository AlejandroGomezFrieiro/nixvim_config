[group('test')]
test:
    nix flake check

[group('test')]
test_rust:
    nix flake check ./examples/rust_environment

[group('test')]
develop_rust:
    nix develop ./examples/rust_environment/

[group('test')]
cargo_version:
    nix develop ./examples/rust_environment --command cargo --version
