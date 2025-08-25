{
  description = "AMSA 25-26 slides";

  inputs.nixpkgs = {
    url = "github:nixos/nixpkgs/nixos-unstable?shallow=1";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";  # or "aarch64-darwin" etc. depending on your system
      pkgs = import nixpkgs {
        inherit system; 
        config.allowUnfree = true;
      };
      quarto = pkgs.quarto;
      quarto-dev = pkgs.quarto.overrideAttrs (oldAttrs: {
          # Don't relly know why the nixpkgs repo removes the binaries inside quarto...
          installPhase = ''
            runHook preInstall
            mkdir -p $out/bin $out/share
            mv bin/* $out/bin
            mv share/* $out/share
            runHook postInstall
          '';
      });
    in {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [ quarto-dev pkgs.vscode pkgs.pandoc ];
      };
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "amsa-slides";
        version = "2025.2026.v1";
        src = ./src;
        buildInputs = [ quarto pkgs.which ];
        buildPhase = ''
          # Deno needs to add stuff to $HOME/.cache
          # so we give it a home to do this
          mkdir home
          export HOME=$PWD/home
          quarto render --no-cache
        '';
        installPhase = ''
          mkdir -p $out
          cp -r docs/* $out/
        '';
      };
    };
}
