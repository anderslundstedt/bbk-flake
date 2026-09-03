{
  description = "CLI tool for internet speed checking, from bredbandskollen.se";

  inputs.pins.url            = "github:anderslundstedt/nix-pins";
  inputs.flake-utils.follows = "pins/flake-utils";

  outputs = inputs@{self,...}:
    let
      systems = ["x86_64-linux"  "aarch64-linux" "aarch64-darwin"];
    in
      inputs.flake-utils.lib.eachSystem systems (system:
        let
          nixpkgs-stable =
            inputs.pins.nixpkgs-stable.${system}.legacyPackages.${system};
        in {
          packages.default = nixpkgs-stable.stdenv.mkDerivation rec {
            name    = "bbk-cli-${version}";
            version = "1.2.2";

            src = nixpkgs-stable.fetchFromGitHub {
              owner  = "dotse";
              repo   = "bbk";
              rev    = "BBK_CLI_${version}";
              sha256 = "sha256-CQEnMBARxEqUj+eB5Cf/aF918lPeN5PA+qb8HNlN2X0=";
            };

            sourceRoot = "source/src";

            preBuild = "cd cli";

            buildInputs = [];

            installPhase = ''
              mkdir -p $out/bin
              mv cli $out/bin/bbk-cli
            '';

            meta = {
              homepage    = "https://github.com/dotse/bbk";
              description = "CLI to bredbandskollen.se";
              license     = nixpkgs-stable.lib.licenses.mit;
            };
          };
        }
      );
}
