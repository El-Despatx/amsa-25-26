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
        buildInputs = [ quarto-dev pkgs.vscode pkgs.pandoc pkgs.fontconfig pkgs.texliveTeTeX pkgs.chromium ];
        shellHook = ''
          export LD_LIBRARY_PATH=${pkgs.lib.getLib pkgs.fontconfig}/lib:${pkgs.freetype}/lib:$LD_LIBRARY_PATH
          # export LD_PRELOAD=${pkgs.fontconfig}/lib/libfontconfig.so.1:${pkgs.freetype}/lib/libfreetype.so.6
        '';
      };
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "amsa-slides";
        version = "2025.2026.v1";
        src = ./src;
        buildInputs = [ quarto pkgs.which pkgs.pandoc pkgs.fontconfig pkgs.chromium (pkgs.texlive.combine {
        inherit (pkgs.texlive)
        scheme-medium  # or scheme-small if you want minimal
        collection-latexextra
        xcolor         # since your doc also uses \definecolor
        ;
    }) ];
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
