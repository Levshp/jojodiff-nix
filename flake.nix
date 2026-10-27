{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

      jptch = pkgs.stdenv.mkDerivation {
        pname = "jptch";
        version = "1.0";
        src = ./.;

        nativeBuildInputs = [ pkgs.gnumake ];

        buildPhase = ''
          make all
        '';

        installPhase = ''
          mkdir -p $out/bin
          # Replace this with the actual built executable path/name:
          install -m755 jptch $out/bin/jptch
        '';
      };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = [ pkgs.gnumake ];
      };

      packages.${system} = {
        jptch = jptch;
        default = jptch;
      };
    };
}

