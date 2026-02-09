{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
    in {
      devShell = with pkgs;
        mkShell {
          buildInputs = [
            (python3.withPackages (ps: with ps; [pip]))
            virtualenv

            vhdl-ls # language server
            ghdl # compile / simulate vhdl
            gtkwave # waveform visualizer

            netlistsvg
            yosys
            yosys-ghdl
            mermaid-cli

            gnumake # make
          ];
        };
    });
}
