{
  description = "AMSA 25-26 slides";

  inputs.nixpkgs = {
    url = "github:nixos/nixpkgs/nixos-unstable?shallow=1";
  };

  outputs = { self, nixpkgs, ... }:
    let
      systems = [ "aarch64-darwin" "x86_64-linux" ];
      sysPkgs = builtins.listToAttrs (map (s: {
        name = s;
        value = import nixpkgs { system = s; config = { allowUnfree = true; }; };
      }) systems);
    in {
      devShells = builtins.listToAttrs (map (s: {
        name = s;
        value = { default = let pkgs = sysPkgs.${s}; in pkgs.mkShell {
          buildInputs = [
            (pkgs.quarto.overrideAttrs (oldAttrs: {
              installPhase = ''
                runHook preInstall
                mkdir -p $out/bin $out/share
                mv bin/* $out/bin
                mv share/* $out/share
                runHook postInstall
              '';
            }))
            pkgs.vscode pkgs.pandoc pkgs.fontconfig (pkgs.texlive.combine {
              inherit (pkgs.texlive) scheme-medium collection-latexextra xcolor;
            })
          ];
          shellHook = ''
            export LD_LIBRARY_PATH=${pkgs.lib.getLib pkgs.fontconfig}/lib:${pkgs.freetype}/lib:$LD_LIBRARY_PATH
          '';
        }; };
      }) systems);

      packages = builtins.listToAttrs (map (s: {
        name = s;
        value = { default = let pkgs = sysPkgs.${s}; in pkgs.stdenv.mkDerivation {
          pname = "amsa-slides";
          version = "2025.2026.v1";
          src = ./src;
          buildInputs = [ pkgs.quarto pkgs.which pkgs.pandoc pkgs.fontconfig pkgs.chromium (pkgs.texlive.combine {
            inherit (pkgs.texlive) scheme-medium collection-latexextra xcolor;
          }) ];
          buildPhase = ''
            mkdir home
            export HOME=$PWD/home
            quarto render --no-cache
          '';
          installPhase = ''
            mkdir -p $out
            cp -r docs/* $out/
          '';
        }; };
      }) systems);
    };
}
