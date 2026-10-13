{
  description = "CLI tool for internet speed checking, from bredbandskollen.se";

  inputs.pins.url            = "github:anderslundstedt/nix-pins";
  inputs.flake-utils.follows = "pins/flake-utils";

  outputs = inputs@{self,...}:
    let
      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin"];
    in
      inputs.flake-utils.lib.eachSystem systems (system:
        let
          nixpkgs-stable =
            inputs.pins.nixpkgs-stable.${system}.legacyPackages.${system};
        in {
          packages.default = nixpkgs-stable.stdenv.mkDerivation rec {
            name    = "bbk-cli-${version}";
            version = "5.1.0";

            src = nixpkgs-stable.fetchFromGitLab {
              owner  = "internetstiftelsen-oss";
              repo   = "bredbandskollen";
              rev    = version;
              sha256 = "sha256-vl2TrNQ4tMTioZjmtd44HYG3pkgMAgNHSgxhI/KXNiQ=";
            };

            sourceRoot = "source";

            preBuild = "cd cli";

            buildInputs = [];

            enableParallelBuilding = true;

            installPhase = ''
              mkdir -p $out/bin
              mv bbk $out/bin/bbk
            '';

            meta = {
              homepage    =
                "https://gitlab.com/internetstiftelsen-oss/bredbandskollen";
              description = "CLI to bredbandskollen.se";
              license     = nixpkgs-stable.lib.licenses.mit;
              mainProgram = "bbk";
            };
          };
        }
      );
}
