{
  description = "Following along with Andrej Karpathy's 'Neural Networks: Zero to Hero' course";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { flake-utils, nixpkgs, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
        haskellPackages = pkgs.haskell.packages.ghc9122;
      in
      {
        devShells.default = pkgs.mkShell {
          packages = [
            haskellPackages.ghc
            haskellPackages.haskell-language-server
            haskellPackages.cabal-install
            haskellPackages.cabal-gild
            haskellPackages.fourmolu
            haskellPackages.hlint
          ];
        };
      }
    );
}
