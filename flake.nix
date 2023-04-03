{
  description = "Svelte flake template";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    gitignore.url = "github:hercules-ci/gitignore.nix";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    gitignore,
    flake-parts,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin"];
      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        system,
        lib,
        ...
      }: let
        inherit (gitignore.lib) gitignoreSource;
        packageJSON = lib.importJSON ./package.json;
      in {
        packages = rec {
          site-src = pkgs.mkYarnPackage rec {
            name = "${packageJSON.name}-site-${version}";
            version = packageJSON.version;
            src = gitignoreSource ./.;
            packageJson = "${src}/package.json";
            yarnLock = "${src}/yarn.lock";
            buildPhase = ''
              yarn --offline build
            '';
            distPhase = "true";
          };

          default = pkgs.writeShellApplication {
            name = packageJSON.name;
            runtimeInputs = [site-src pkgs.nodejs];
            text = ''
              node ${site-src}/libexec/${packageJSON.name}/deps/${packageJSON.name}/build
            '';
          };
        };

        devShells = {
          default = pkgs.mkShell {
            buildInputs = [
              pkgs.yarn
              pkgs.nodejs
            ];
          };
        };
      };
    };
}
